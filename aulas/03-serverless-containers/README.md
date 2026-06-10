# Aula 3 — Compute Avançado: Serverless, VMs e Containers

## Objetivos de aprendizagem

Ao final desta aula, você será capaz de:

- Comparar os 3 modelos de compute: VMs, Containers e Serverless (Functions).
- Decidir qual modelo usar para cada tipo de workload da QC.
- Provisionar uma **Azure Function App** (Consumption Plan Y1, free) via Terraform e fazer deploy com `func`.
- Acessar recursos do Azure **sem credenciais no código** usando **Managed Identity** (System-assigned e User-assigned).
- Empacotar uma aplicação Python (FastAPI) em **container Docker**, publicar no **Azure Container Registry** e rodar no **Azure Container Instances**.
- Entender o papel do Kubernetes/AKS e quando ele **não** é a melhor escolha.

---

## Por que esta aula importa para um AI Engineer

A camada de **compute** é onde os agentes da QC vão **rodar** (Functions chamadas pelos modelos como tools) e onde as **APIs** que eles consomem ficam expostas. Function HTTP + Managed Identity é o padrão para tornar um endpoint **utilizável por um agente** sem vazar credenciais.

---

## Conexão com o Quantum Commerce

Nesta aula você implanta a **API de catálogo** da Quantum Commerce — primeira **tool** que os agentes da QC vão chamar. Dois sabores:

1. **Function HTTP (Python)** — pay-per-call, scale automático, free tier de 1M execuções/mês.
2. **Container (FastAPI + ACI)** — mesma lógica de negócio empacotada em container, com Managed Identity user-assigned.

Ambas leem `produtos.csv` do Blob Storage da Aula 2 — **sem credenciais hardcoded**, via Managed Identity.

---

## Material da aula

| Arquivo | Quando usar |
|---------|-------------|
| [lab/guia-lab.md](lab/guia-lab.md) | Durante a aula — 3 atividades intercaladas |
| [lab/terraform/](lab/terraform/) | Código IaC: Function App + ACR + ACI + identidades + roles |
| [lab/function/v1-mock/](lab/function/v1-mock/) | Versão 1 da Function (mock data) — L₁ |
| [lab/function/v2-blob/](lab/function/v2-blob/) | Versão 2 da Function (Blob + MI) — L₂ |
| [lab/docker/](lab/docker/) | Versão FastAPI containerizada — L₃ |
| [exercicios.md](exercicios.md) | Após a aula — exercícios em 3 níveis (🟢/🟡/🔴) |

## Entrega de grupo

Esta aula gera a **3ª entrega de grupo** (10% da nota): instruções em [entregas/entrega-03/](../../entregas/entrega-03/). Rubrica em [entregas/rubrica.md](../../entregas/rubrica.md).

---

## Pré-requisitos

- ✅ Aulas 1 e 2 concluídas
- ✅ **Storage da Aula 2 aplicado** (com `produtos.csv` no container `catalogo`) — se você destruiu, re-aplique antes:

  ```bash
  cd ~/aie-cloud/aulas/02-storage-bancos/lab/terraform
  terraform apply -auto-approve -var="sql_admin_password=$(openssl rand -base64 24)"
  ```

  Depois faça upload do CSV (Atividade 1 do guia da Aula 2) se ainda não tiver.
