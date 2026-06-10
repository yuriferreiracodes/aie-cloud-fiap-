# Troubleshooting — Problemas comuns

> Esta página será preenchida ao longo das aulas, com base nos erros que aparecerem em sala. Se você encontrar um erro novo, abra uma issue ou avise o professor.

---

## Azure Cloud Shell

### "Você não tem acesso a este recurso"

Provavelmente sua assinatura Azure for Students ainda não foi ativada. Volte ao [SETUP.md](../SETUP.md) e conclua a ativação.

### Cloud Shell não abre / fica em loop

- Limpe o cache do navegador para `shell.azure.com`.
- Tente em janela anônima.
- Tente outro navegador (Chrome ou Edge funcionam melhor).

---

## Terraform

### `Error: Insufficient credentials`

Rode `az login` dentro do Cloud Shell (mesmo já estando logado no portal — o `az` precisa de sessão própria).

### `Error: A resource with the ID "..." already exists`

Você está tentando criar um recurso que já existe. Importe-o com `terraform import` ou destrua o existente primeiro com `terraform destroy`.

---

## Azure CLI (`az`)

### `command not found: az`

Você não está no Cloud Shell. Abra [shell.azure.com](https://shell.azure.com) — o `az` vem pré-instalado lá.

---

> Mais conteúdo a ser adicionado durante a disciplina.
