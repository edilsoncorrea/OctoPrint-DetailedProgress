#!/bin/bash
#
# Verificação rápida do status do plugin OctoPrint-DetailedProgress
#

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=== Verificação Rápida - OctoPrint-DetailedProgress ==="

# Verificar se está em venv
if [ -n "$VIRTUAL_ENV" ]; then
    echo -e "${GREEN}✓${NC} Ambiente virtual ativo: $VIRTUAL_ENV"
else
    echo -e "${RED}✗${NC} Ambiente virtual não ativo"
    echo "Execute: source ~/OctoPrint/venv/bin/activate"
fi

# Verificar instalação do plugin
if pip list | grep -i "OctoPrint-DetailedProgress" > /dev/null 2>&1; then
    version=$(pip list | grep -i "OctoPrint-DetailedProgress" | awk '{print $2}')
    echo -e "${GREEN}✓${NC} Plugin instalado - versão: $version"
else
    echo -e "${RED}✗${NC} Plugin não instalado"
fi

# Verificar se pode importar
if python -c "from octoprint_detailedprogress import DetailedProgress" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Plugin pode ser importado"
else
    echo -e "${RED}✗${NC} Erro ao importar plugin"
fi

# Verificar OctoPrint
if systemctl is-active --quiet octoprint 2>/dev/null; then
    echo -e "${GREEN}✓${NC} OctoPrint está rodando"
else
    echo -e "${YELLOW}!${NC} OctoPrint não está rodando"
fi

# Verificar logs recentes
if [ -f "$HOME/.octoprint/logs/octoprint.log" ]; then
    echo ""
    echo "=== Logs Recentes ==="
    grep -i "detailedprogress\|DetailedProgress" "$HOME/.octoprint/logs/octoprint.log" | tail -5
else
    echo -e "${YELLOW}!${NC} Arquivo de log não encontrado"
fi

echo ""
echo "Para diagnóstico completo: python diagnostic_tool.py"
echo "Para reinstalar: ./install_cb1.sh"