# 🔧 Fork CB1 Enhanced - OctoPrint-DetailedProgress

Este é um **fork aprimorado** do plugin OctoPrint-DetailedProgress especificamente desenvolvido para resolver problemas de compatibilidade com placas **CB1 da BTT**.

## 👨‍💻 Informações do Fork

**Desenvolvedor**: Edilson Correa  
**Email**: edilsoncorrea117@gmail.com  
**Repositório**: https://github.com/edilsoncorrea/OctoPrint-DetailedProgress  
**Baseado em**: Plugin original de Tom M (tpmullan)  

## 🎯 Objetivo do Fork

Resolver o problema onde o plugin **aparecia como desabilitado** em instalações CB1 da BTT, mesmo funcionando perfeitamente em Raspberry Pi padrão.

## ✨ Melhorias Exclusivas

### 🔍 **Compatibilidade CB1**
- ✅ Detecção automática de ambiente virtual
- ✅ Tratamento robusto para instalações venv
- ✅ Verificações específicas para CB1

### 🛠️ **Ferramentas Inclusas**
- 📊 `diagnostic_tool.py` - Diagnóstico completo do ambiente
- 🚀 `install_cb1.sh` - Instalador automatizado
- ⚡ `check_status.sh` - Verificação rápida
- 📖 `INSTALACAO_CB1.md` - Guia completo em português

### 🔧 **Melhorias Técnicas**
- 🛡️ Tratamento de erros aprimorado
- 📝 Logs mais informativos
- 🔄 Inicialização defensiva
- 🐍 Compatibilidade Python 3.7+ (removido 2.7)

## 📥 Instalação Rápida

```bash
# Clone do repositório fork
git clone https://github.com/edilsoncorrea/OctoPrint-DetailedProgress.git
cd OctoPrint-DetailedProgress

# Instalação automática para CB1
chmod +x install_cb1.sh
./install_cb1.sh
```

## 🆚 Diferenças do Original

| Recurso | Original | Fork CB1 Enhanced |
|---------|----------|-------------------|
| **CB1 Support** | ❌ Problemas | ✅ Nativo |
| **Diagnóstico** | ❌ Manual | ✅ Automatizado |
| **Instalação CB1** | ❌ Complexa | ✅ Script automático |
| **Documentação PT** | ❌ Ausente | ✅ Completa |
| **Logs Detalhados** | ❌ Básicos | ✅ Informativos |

## 🎉 Resultado

Após usar este fork:
- ✅ Plugin **funciona corretamente** na CB1
- ✅ **Não aparece mais desabilitado**
- ✅ **Mensagens no LCD** durante impressão
- ✅ **Compatibilidade total** com Raspberry Pi padrão

## 🤝 Suporte

Para problemas específicos de CB1:
- 📧 **Email**: edilsoncorrea117@gmail.com
- 🔧 **Use**: `diagnostic_tool.py` para análise
- 📋 **Inclua**: Logs e saída do diagnóstico

## 🙏 Créditos

- **Tom M**: Autor do plugin original
- **Comunidade BTT**: Feedback e testes
- **Comunidade OctoPrint**: Suporte técnico

---

**Versão**: 0.2.8 CB1 Enhanced  
**Data**: Novembro 2025  
**Status**: Testado e funcionando em CB1 + OctoPrint venv