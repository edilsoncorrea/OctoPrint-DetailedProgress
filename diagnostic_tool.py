#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Ferramenta de diagnóstico para OctoPrint-DetailedProgress
Fork CB1 Enhanced por Edilson Correa (edilsoncorrea117@gmail.com)
Especialmente útil para instalações em CB1 da BTT com venv
Repositório: https://github.com/edilsoncorrea/OctoPrint-DetailedProgress
"""

import sys
import os
import logging
import json
from pathlib import Path

def check_python_environment():
    """Verificar o ambiente Python"""
    print("=== DIAGNÓSTICO DO AMBIENTE PYTHON ===")
    print(f"Versão do Python: {sys.version}")
    print(f"Executável: {sys.executable}")
    
    # Verificar se está em venv
    if hasattr(sys, 'prefix') and hasattr(sys, 'base_prefix'):
        if sys.prefix != sys.base_prefix:
            print(f"✅ Executando em ambiente virtual: {sys.prefix}")
        else:
            print("❌ NÃO está executando em ambiente virtual")
    else:
        print("⚠️ Não é possível determinar se está em venv (Python < 3.3)")
    
    print(f"sys.path: {sys.path[:3]}...")
    print()

def check_octoprint_installation():
    """Verificar a instalação do OctoPrint"""
    print("=== DIAGNÓSTICO DA INSTALAÇÃO DO OCTOPRINT ===")
    try:
        import octoprint
        print(f"✅ OctoPrint importado com sucesso")
        print(f"Versão: {getattr(octoprint, '__version__', 'Não disponível')}")
        print(f"Localização: {octoprint.__file__}")
        
        # Verificar módulos específicos
        try:
            import octoprint.plugin
            print("✅ octoprint.plugin disponível")
        except ImportError as e:
            print(f"❌ Erro ao importar octoprint.plugin: {e}")
            
        try:
            import octoprint.util
            print("✅ octoprint.util disponível")
        except ImportError as e:
            print(f"❌ Erro ao importar octoprint.util: {e}")
            
        try:
            from octoprint.events import Events
            print("✅ octoprint.events.Events disponível")
        except ImportError as e:
            print(f"❌ Erro ao importar octoprint.events.Events: {e}")
            
    except ImportError as e:
        print(f"❌ Erro ao importar OctoPrint: {e}")
        return False
    
    print()
    return True

def check_plugin_structure():
    """Verificar a estrutura do plugin"""
    print("=== DIAGNÓSTICO DA ESTRUTURA DO PLUGIN ===")
    
    plugin_dir = Path(__file__).parent
    print(f"Diretório do plugin: {plugin_dir}")
    
    # Verificar arquivos essenciais
    essential_files = [
        'setup.py',
        'octoprint_detailedprogress/__init__.py',
        'octoprint_detailedprogress/templates/detailedprogress_settings.jinja2',
        'octoprint_detailedprogress/static/js/DetailedProgress.js',
        'octoprint_detailedprogress/static/css/detailedprogress.css'
    ]
    
    for file_path in essential_files:
        full_path = plugin_dir / file_path
        if full_path.exists():
            print(f"✅ {file_path}")
        else:
            print(f"❌ {file_path} (FALTANDO)")
    
    print()

def check_plugin_compatibility():
    """Verificar compatibilidade do plugin"""
    print("=== DIAGNÓSTICO DE COMPATIBILIDADE ===")
    
    try:
        # Tentar importar o plugin
        sys.path.insert(0, str(Path(__file__).parent))
        from octoprint_detailedprogress import DetailedProgress
        
        print("✅ Plugin importado com sucesso")
        
        # Verificar se o plugin herda das classes corretas
        import octoprint.plugin
        base_classes = [
            'EventHandlerPlugin',
            'SettingsPlugin', 
            'TemplatePlugin',
            'AssetPlugin',
            'StartupPlugin'
        ]
        
        for base_class in base_classes:
            if hasattr(octoprint.plugin, base_class):
                base = getattr(octoprint.plugin, base_class)
                if issubclass(DetailedProgress, base):
                    print(f"✅ Herda corretamente de {base_class}")
                else:
                    print(f"❌ NÃO herda de {base_class}")
            else:
                print(f"⚠️ {base_class} não encontrado no octoprint.plugin")
        
        # Verificar métodos obrigatórios
        required_methods = [
            'on_event',
            'get_settings_defaults', 
            'get_template_configs',
            'get_assets',
            'on_after_startup'
        ]
        
        for method in required_methods:
            if hasattr(DetailedProgress, method):
                print(f"✅ Método {method} implementado")
            else:
                print(f"❌ Método {method} FALTANDO")
                
    except Exception as e:
        print(f"❌ Erro ao verificar compatibilidade: {e}")
        import traceback
        print(f"Traceback: {traceback.format_exc()}")
    
    print()

def check_octoprint_config():
    """Verificar configuração do OctoPrint"""
    print("=== DIAGNÓSTICO DA CONFIGURAÇÃO ===")
    
    # Tentar encontrar diretório de configuração do OctoPrint
    possible_config_dirs = [
        Path.home() / '.octoprint',
        Path('/home/pi/.octoprint'),
        Path('/opt/octoprint/.octoprint')
    ]
    
    config_dir = None
    for dir_path in possible_config_dirs:
        if dir_path.exists():
            config_dir = dir_path
            print(f"✅ Diretório de configuração encontrado: {config_dir}")
            break
    
    if not config_dir:
        print("❌ Diretório de configuração do OctoPrint não encontrado")
        return
    
    # Verificar config.yaml
    config_file = config_dir / 'config.yaml'
    if config_file.exists():
        print(f"✅ Arquivo de configuração: {config_file}")
    else:
        print(f"⚠️ Arquivo de configuração não encontrado: {config_file}")
    
    # Verificar diretório de plugins
    plugins_dir = config_dir / 'plugins'
    if plugins_dir.exists():
        print(f"✅ Diretório de plugins: {plugins_dir}")
        
        # Listar plugins instalados
        installed_plugins = list(plugins_dir.iterdir())
        if installed_plugins:
            print(f"Plugins instalados: {[p.name for p in installed_plugins]}")
        else:
            print("Nenhum plugin encontrado no diretório de plugins")
    else:
        print(f"⚠️ Diretório de plugins não encontrado: {plugins_dir}")
    
    print()

def generate_installation_script():
    """Gerar script de instalação específico para CB1"""
    print("=== SCRIPT DE INSTALAÇÃO PARA CB1 ===")
    
    script_content = '''#!/bin/bash
# Script de instalação para OctoPrint-DetailedProgress na CB1 da BTT

echo "Instalando OctoPrint-DetailedProgress na CB1..."

# Ativar ambiente virtual do OctoPrint
source ~/OctoPrint/venv/bin/activate

# Verificar se estamos no venv correto
if [[ "$VIRTUAL_ENV" != *"OctoPrint"* ]]; then
    echo "ERRO: Ambiente virtual do OctoPrint não ativado corretamente"
    exit 1
fi

echo "Ambiente virtual ativo: $VIRTUAL_ENV"

# Instalar o plugin
pip install https://github.com/edilsoncorrea/OctoPrint-DetailedProgress/archive/master.zip

# Ou se você tem o código local:
# cd /caminho/para/OctoPrint-DetailedProgress
# pip install .

# Reiniciar OctoPrint
sudo service octoprint restart

echo "Instalação concluída. Verifique os logs do OctoPrint."
'''
    
    script_path = Path(__file__).parent / 'install_cb1.sh'
    with open(script_path, 'w') as f:
        f.write(script_content)
    
    print(f"✅ Script de instalação criado: {script_path}")
    print("Para usar:")
    print(f"1. chmod +x {script_path}")
    print(f"2. ./{script_path}")
    print()

def main():
    """Função principal de diagnóstico"""
    print("FERRAMENTA DE DIAGNÓSTICO - OctoPrint-DetailedProgress")
    print("=" * 60)
    print()
    
    check_python_environment()
    
    if check_octoprint_installation():
        check_plugin_structure()
        check_plugin_compatibility()
        check_octoprint_config()
    
    generate_installation_script()
    
    print("=== DIAGNÓSTICO CONCLUÍDO ===")
    print()
    print("Se o plugin não estiver funcionando na CB1:")
    print("1. Verifique se todos os itens marcados com ✅ estão corretos")
    print("2. Corrija os problemas marcados com ❌")
    print("3. Use o script de instalação gerado")
    print("4. Verifique os logs: tail -f ~/.octoprint/logs/octoprint.log")

if __name__ == '__main__':
    main()