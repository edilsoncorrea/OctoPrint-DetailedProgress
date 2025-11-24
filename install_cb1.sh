#!/bin/bash
#
# Script de instalação automatizada para OctoPrint-DetailedProgress na CB1
# Versão: 1.0
# Compatível com: CB1 da BTT, OctoPrint em venv
#

set -e  # Sair se algum comando falhar

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções auxiliares
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

# Verificar se é uma instalação CB1
check_cb1() {
    print_info "Verificando se é sistema CB1..."
    
    if [ -f "/boot/BoardEnv.txt" ]; then
        if grep -q "CB1" /boot/BoardEnv.txt; then
            print_success "Sistema CB1 detectado"
            return 0
        fi
    fi
    
    print_warning "Sistema CB1 não detectado claramente, continuando..."
    return 0
}

# Verificar se OctoPrint está instalado
check_octoprint() {
    print_info "Verificando instalação do OctoPrint..."
    
    if [ ! -d "$HOME/OctoPrint" ]; then
        print_error "Diretório OctoPrint não encontrado em $HOME/OctoPrint"
        print_error "Este script requer que OctoPrint esteja instalado conforme o tutorial padrão"
        exit 1
    fi
    
    if [ ! -f "$HOME/OctoPrint/venv/bin/activate" ]; then
        print_error "Ambiente virtual do OctoPrint não encontrado"
        exit 1
    fi
    
    print_success "Instalação do OctoPrint encontrada"
}

# Verificar se OctoPrint está rodando
check_octoprint_running() {
    print_info "Verificando status do OctoPrint..."
    
    if systemctl is-active --quiet octoprint; then
        print_info "OctoPrint está rodando, será reiniciado após instalação"
        OCTOPRINT_WAS_RUNNING=1
    else
        print_warning "OctoPrint não está rodando"
        OCTOPRINT_WAS_RUNNING=0
    fi
}

# Ativar ambiente virtual
activate_venv() {
    print_info "Ativando ambiente virtual do OctoPrint..."
    
    source "$HOME/OctoPrint/venv/bin/activate"
    
    if [ -z "$VIRTUAL_ENV" ]; then
        print_error "Falha ao ativar ambiente virtual"
        exit 1
    fi
    
    print_success "Ambiente virtual ativado: $VIRTUAL_ENV"
}

# Verificar dependências
check_dependencies() {
    print_info "Verificando dependências..."
    
    # Verificar Python
    python_version=$(python --version 2>&1)
    print_info "Versão Python: $python_version"
    
    # Verificar OctoPrint
    if ! python -c "import octoprint" 2>/dev/null; then
        print_error "OctoPrint não pode ser importado no ambiente atual"
        exit 1
    fi
    
    octoprint_version=$(python -c "import octoprint; print(getattr(octoprint, '__version__', 'desconhecida'))" 2>/dev/null)
    print_success "OctoPrint versão: $octoprint_version"
}

# Fazer backup se plugin já estiver instalado
backup_existing() {
    print_info "Verificando instalação existente..."
    
    if pip list | grep -i "OctoPrint-DetailedProgress" > /dev/null; then
        print_info "Plugin já instalado, fazendo backup..."
        BACKUP_DIR="$HOME/.octoprint/plugins_backup/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        
        if [ -d "$HOME/.octoprint/plugins/detailedprogress" ]; then
            cp -r "$HOME/.octoprint/plugins/detailedprogress" "$BACKUP_DIR/"
            print_info "Backup criado em: $BACKUP_DIR"
        fi
    fi
}

# Instalar plugin
install_plugin() {
    print_info "Instalando OctoPrint-DetailedProgress..."
    
    # Atualizar pip primeiro
    print_info "Atualizando pip..."
    pip install --upgrade pip
    
		# Se temos o código local, usar ele
		if [ -f "setup.py" ] && [ -d "octoprint_detailedprogress" ]; then
			print_info "Instalando do código local..."
			pip install .
		else
			print_info "Instalando do repositório GitHub..."
			pip install https://github.com/edilsoncorrea/OctoPrint-DetailedProgress/archive/master.zip
		fi    print_success "Plugin instalado"
}

# Verificar instalação
verify_installation() {
    print_info "Verificando instalação..."
    
    if pip list | grep -i "OctoPrint-DetailedProgress" > /dev/null; then
        print_success "Plugin encontrado na lista de pacotes instalados"
    else
        print_error "Plugin não encontrado após instalação"
        return 1
    fi
    
    # Testar importação
    if python -c "from octoprint_detailedprogress import DetailedProgress" 2>/dev/null; then
        print_success "Plugin pode ser importado corretamente"
    else
        print_warning "Problema ao importar plugin, verifique logs"
    fi
}

# Executar diagnóstico
run_diagnostic() {
    if [ -f "diagnostic_tool.py" ]; then
        print_info "Executando diagnóstico..."
        python diagnostic_tool.py
    fi
}

# Reiniciar OctoPrint
restart_octoprint() {
    if [ "$OCTOPRINT_WAS_RUNNING" -eq 1 ]; then
        print_info "Reiniciando OctoPrint..."
        sudo systemctl restart octoprint
        sleep 5
        
        if systemctl is-active --quiet octoprint; then
            print_success "OctoPrint reiniciado com sucesso"
        else
            print_error "Falha ao reiniciar OctoPrint"
            print_info "Verifique: sudo systemctl status octoprint"
        fi
    else
        print_info "Para iniciar OctoPrint: sudo systemctl start octoprint"
    fi
}

# Mostrar logs
show_logs() {
    print_info "Para monitorar logs do OctoPrint:"
    echo "tail -f ~/.octoprint/logs/octoprint.log"
    echo ""
    print_info "Procure por mensagens como:"
    echo "- 'OctoPrint-DetailedProgress loaded!'"
    echo "- 'Plugin initialization completed successfully'"
    echo ""
    print_info "Para verificar se o plugin está habilitado:"
    echo "Settings → Plugin Manager no interface web"
}

# Função principal
main() {
    echo "============================================================"
    echo "    Instalador OctoPrint-DetailedProgress para CB1"
    echo "============================================================"
    echo ""
    
    check_cb1
    check_octoprint
    check_octoprint_running
    activate_venv
    check_dependencies
    backup_existing
    install_plugin
    
    if verify_installation; then
        run_diagnostic
        restart_octoprint
        
        echo ""
        echo "============================================================"
        print_success "INSTALAÇÃO CONCLUÍDA!"
        echo "============================================================"
        echo ""
        show_logs
        
    else
        print_error "Falha na verificação da instalação"
        exit 1
    fi
}

# Executar função principal
main "$@"