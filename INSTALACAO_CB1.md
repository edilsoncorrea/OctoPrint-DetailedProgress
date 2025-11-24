# Instalação do OctoPrint-DetailedProgress na CB1 da BTT

Este guia aborda especificamente a instalação do plugin **OctoPrint-DetailedProgress** em sistemas CB1 da BTT executando OctoPrint em ambiente virtual (venv).

## Problema Identificado

O plugin pode não funcionar corretamente em instalações CB1 devido a:
- Diferenças no ambiente virtual (venv)
- Permissões específicas do sistema
- Carregamento diferente de módulos Python
- Configurações específicas da CB1

## Solução Implementada

### 1. Melhorias no Código

O plugin foi atualizado com:
- Verificações robustas de ambiente virtual
- Tratamento de erros melhorado
- Validação de dependências
- Logs mais detalhados para diagnóstico

### 2. Instalação na CB1

#### Pré-requisitos
```bash
# Certifique-se de que está conectado via SSH à CB1
ssh pi@<ip-da-cb1>

# Verifique se o OctoPrint está funcionando
sudo systemctl status octoprint
```

#### Instalação Passo a Passo

1. **Ativar o ambiente virtual do OctoPrint:**
```bash
cd ~
source OctoPrint/venv/bin/activate
```

2. **Verificar o ambiente:**
```bash
# Verificar se está no venv correto
echo $VIRTUAL_ENV
# Deve mostrar: /home/pi/OctoPrint/venv

# Verificar versão do Python
python --version
# Deve mostrar: Python 3.11.x

# Verificar instalação do OctoPrint
python -c "import octoprint; print(octoprint.__version__)"
```

3. **Instalar o plugin melhorado:**

Opção A - Instalar diretamente do código local:
```bash
# Se você tem o código do plugin
cd /caminho/para/OctoPrint-DetailedProgress
pip install .
```

Opção B - Instalar do repositório (Fork melhorado):
```bash
pip install https://github.com/edilsoncorrea/OctoPrint-DetailedProgress/archive/master.zip
```

4. **Executar diagnóstico:**
```bash
# Usar a ferramenta de diagnóstico incluída
python diagnostic_tool.py
```

5. **Reiniciar OctoPrint:**
```bash
sudo systemctl restart octoprint
```

6. **Verificar logs:**
```bash
tail -f ~/.octoprint/logs/octoprint.log
```

### 3. Verificação da Instalação

#### No Interface Web do OctoPrint:

1. Acesse **Settings** → **Plugin Manager**
2. Verifique se "Detailed Progress" aparece na lista
3. Se estiver desabilitado, tente habilitar manualmente

#### Nos Logs:

Procure por estas mensagens nos logs:
```
INFO - OctoPrint-DetailedProgress loaded!
INFO - Plugin initialization completed successfully
```

Se houver erros, procure por:
```
ERROR - Error during plugin startup
ERROR - Error in on_event
```

### 4. Solução de Problemas

#### Plugin não aparece na lista:
```bash
# Verificar instalação
pip list | grep -i detailed

# Reinstalar com diagnóstico
SKIP_CHECKS=1 pip install --force-reinstall .
```

#### Plugin aparece mas está desabilitado:
1. Verificar logs para erros específicos
2. Executar `diagnostic_tool.py`
3. Verificar permissões do diretório `.octoprint`

#### Erros de importação:
```bash
# Verificar dependências
pip check

# Atualizar pip e reinstalar
pip install --upgrade pip
pip install --force-reinstall .
```

### 5. Diferenças da Instalação Padrão

#### CB1 vs Raspberry Pi Padrão:

| Aspecto | Raspberry Pi | CB1 |
|---------|-------------|-----|
| Ambiente | Sistema global ou venv | Sempre venv |
| Usuário | pi | pi |
| Localização OctoPrint | `/home/pi/OctoPrint` | `/home/pi/OctoPrint` |
| Serviço | systemd | systemd |
| Logs | `~/.octoprint/logs/` | `~/.octoprint/logs/` |

#### Configurações específicas CB1:

O ambiente virtual na CB1 pode ter configurações específicas que requerem:
- Verificação explícita de `sys.prefix`
- Carregamento tardio de configurações
- Tratamento robusto de falhas de inicialização

### 6. Script Automatizado

Use o script `install_cb1.sh` (gerado pela ferramenta de diagnóstico):

```bash
chmod +x install_cb1.sh
./install_cb1.sh
```

### 7. Configuração Manual (se necessário)

Se a instalação automática falhar:

1. **Criar arquivo de configuração manual:**
```bash
mkdir -p ~/.octoprint/plugins
```

2. **Copiar arquivos do plugin:**
```bash
# Copiar para diretório de plugins se necessário
cp -r octoprint_detailedprogress ~/.octoprint/plugins/
```

3. **Configurar permissões:**
```bash
chmod -R 755 ~/.octoprint/plugins/octoprint_detailedprogress
```

### 8. Verificação Final

Após a instalação:

1. ✅ Plugin aparece em Settings → Plugin Manager
2. ✅ Plugin está habilitado
3. ✅ Não há erros nos logs
4. ✅ Durante impressão, mensagens aparecem no LCD

### 9. Contato e Suporte

Se ainda houver problemas:

1. Execute `diagnostic_tool.py` e compartilhe a saída
2. Inclua logs relevantes: `~/.octoprint/logs/octoprint.log`
3. Especifique:
   - Modelo da CB1
   - Versão do OctoPrint
   - Versão do Python
   - Método de instalação usado

---

**Nota:** Esta versão melhorada (v0.2.8) inclui verificações específicas para ambientes CB1 e deve resolver os problemas de compatibilidade relatados.

## 📧 Contato

**Desenvolvedor do Fork CB1**: Edilson Correa  
**Email**: edilsoncorrea117@gmail.com  
**Repositório**: https://github.com/edilsoncorrea/OctoPrint-DetailedProgress  
**Autor Original**: Tom M (tpmullan)