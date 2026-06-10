# Pré-Aula 1 — Checklist Antes do Início

**Tempo estimado:** 15-30 min (depende de quão familiar você está com Azure)
**Quando fazer:** Pelo menos 1 dia antes da Aula 1

---

## Por que esta pré-aula existe

A Aula 1 tem 4 horas para cobrir teoria + 5 laboratórios. Se cada aluno gastar 20 min ativando o Azure ao vivo, perdemos várias horas de tempo coletivo.

**Esta pré-aula resolve isso.** Você chega na Aula 1 com:

- Azure for Students ativado
- Cloud Shell aberto e funcionando
- Crédito de $100 visível

Quem não fizer a pré-aula vai conseguir acompanhar — a Atividade 1 da aula cobre a ativação como fallback. Mas vai ficar mais corrido. **Por favor faça a pré-aula.**

> **Política "no install":** Tudo aqui é via web — não precisa instalar nada no seu computador.

---

## Checklist

### ☐ 1. Ativar Azure for Students (10-15 min)

1. Abra seu navegador em **modo anônimo/privado** (Ctrl+Shift+N no Chrome/Edge, Ctrl+Shift+P no Firefox)
2. Acesse: **https://azure.microsoft.com/free/students**
3. Clique em **"Comece gratuitamente"**
4. Faça login com seu **e-mail FIAP** (`seu.nome@fiap.com.br`) e senha do portal FIAP
5. Complete o MFA (autenticação multifator) se solicitado
6. Confirme o perfil acadêmico — país: **Brasil**
7. Aceite os termos
8. Clique em **"Verificar status acadêmico"** e aguarde 1-2 minutos
9. Você será redirecionado para `portal.azure.com`
10. No canto superior direito, confirme que aparece **$100,00 USD** de crédito

**Se falhar:**

- "Esta conta já está associada..." → acesse `account.microsoft.com`, desconecte a conta existente e tente de novo
- "Não foi possível verificar status acadêmico" → confirme que está usando o e-mail `@fiap.com.br` (não outro)
- Outros erros → traga print da tela para a aula; resolveremos no início

### ☐ 2. Abrir o Azure Cloud Shell (5 min)

O Cloud Shell é o ambiente que usaremos em **TODOS os labs da disciplina**. Vamos abrir agora para confirmar que funciona.

1. No portal Azure, clique no ícone **`>_`** no topo (ou acesse https://shell.azure.com)
2. Na primeira vez, ele pergunta o tipo de shell — escolha **Bash**
3. Ele pede para criar um Storage Account para persistência — **aceite** (custo é zero/negligenciável)
4. Aguarde abrir o prompt: `usuario@Azure:~$`

**Teste rápido — execute estes comandos:**

```bash
# Confirmar autenticação
az account show --query "{nome:name, id:id}" -o table

# Confirmar ferramentas que usaremos
terraform -version
bicep --version
python3 --version
git --version
```

Se todos os comandos respondem com versões, **você está pronto para a Aula 1**.

### ☐ 3. (Opcional) Vídeo introdutório — 10 min

Se você não tem nenhum contato prévio com cloud, assista:

- [Azure Fundamentals — What is Cloud Computing?](https://learn.microsoft.com/training/modules/describe-cloud-compute/) (módulo gratuito Microsoft Learn — ~15 min)

Quem já tem familiaridade com cloud, pode pular.

### ☐ 4. (Opcional) Trilha AZ-900 — para quem quer ir além

Microsoft Learn tem trilha gratuita de Azure Fundamentals que prepara para a certificação AZ-900:

- https://learn.microsoft.com/training/paths/azure-fundamentals/

Não é obrigatório, mas se você está começando do zero, vale a pena fazer ao longo da disciplina.

---

## O que NÃO fazer antes da aula

- Não tente instalar Terraform, Azure CLI, Python ou Visual Studio Code no seu computador
- Não crie Resource Groups, VMs ou outros recursos antes da aula (vai bagunçar os exemplos)
- Não compartilhe sua senha FIAP com colegas (mesmo para "ajudar")

---

## Se a pré-aula travou em algum ponto

**Não bloqueie o seu progresso!** Vá em frente até onde conseguir e:

1. Tire um print da tela onde travou
2. Mande no chat da disciplina (Teams / WhatsApp / canal da turma) com:
   - Em qual passo travou
   - Mensagem de erro (se houver)
   - Print da tela
3. O professor ou um colega responderá antes da aula

---

## Confirmação

Ao final, você deve ter:

- ✅ Conta Azure ativada com $100 de crédito
- ✅ Cloud Shell aberto e funcional
- ✅ `terraform`, `bicep`, `az`, `python3`, `git` respondendo no Cloud Shell

**Nos vemos na Aula 1!** Tenha em mãos:

- Navegador moderno
- Conexão estável
- E-mail FIAP logado
- Uma boa xícara de café
