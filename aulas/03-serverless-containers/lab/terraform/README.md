# Terraform — Aula 3

Código IaC para provisionar a **camada de compute** da Quantum Commerce:

- Azure Function App (Consumption Plan Y1, free, com Managed Identity SystemAssigned)
- Azure Container Registry (Basic SKU)
- Managed Identity user-assigned para o ACI
- Role assignments para ler blobs do Storage da Aula 2 (sem credenciais no código)
- Azure Container Instances (habilitado via flag `aci_enabled` após push da imagem)

## Pré-requisito

O Storage Account da Aula 2 precisa estar aplicado (contém o `produtos.csv` no container `catalogo`). Pegue os valores antes:

```bash
cd ~/aie-cloud/aulas/02-storage-bancos/lab/terraform
STORAGE_AULA2=$(terraform output -raw storage_account_name)
RG_AULA2=$(terraform output -raw resource_group_name)
echo "Storage: $STORAGE_AULA2 | RG: $RG_AULA2"
```

## Como usar (no Azure Cloud Shell)

### Phase 1 — Provisionar tudo exceto ACI (~3 min)

```bash
cd ~/aie-cloud/aulas/03-serverless-containers/lab/terraform

terraform init

terraform apply -auto-approve \
  -var="storage_account_aula2=$STORAGE_AULA2" \
  -var="resource_group_aula2=$RG_AULA2"
# aci_enabled fica em false (default) → não cria ACI ainda
```

Provisiona: Resource Group + Function App + ACR + UAI + role assignments.

### Phase 2 — Após pushar a imagem ao ACR, habilitar o ACI

```bash
# (depois de fazer 'az acr build' ou 'docker push' da imagem produtos-api:v1)

terraform apply -auto-approve \
  -var="storage_account_aula2=$STORAGE_AULA2" \
  -var="resource_group_aula2=$RG_AULA2" \
  -var="aci_enabled=true"
```

### Destroy (regra de ouro — custo zero ao final)

```bash
terraform destroy -auto-approve \
  -var="storage_account_aula2=$STORAGE_AULA2" \
  -var="resource_group_aula2=$RG_AULA2" \
  -var="aci_enabled=true"
```

> O Storage da Aula 2 NÃO é destruído por este Terraform — ele é referenciado como `data` source.

## Arquivos

| Arquivo | O que define |
|---------|--------------|
| [main.tf](main.tf) | Providers, RG, sufixo aleatório, locals, storage da Function, plan Y1, data source Aula 2 |
| [variables.tf](variables.tf) | `location`, `storage_account_aula2`, `resource_group_aula2`, `aci_enabled` |
| [outputs.tf](outputs.tf) | `function_app_name`, `function_app_default_hostname`, `acr_login_server`, `acr_name`, `aci_fqdn` |
| [function.tf](function.tf) | Function App + Managed Identity + role Blob Data Reader |
| [containers.tf](containers.tf) | ACR + UAI + role + ACI (count condicional) |

## Outputs disponíveis

```bash
terraform output -raw function_app_name
terraform output -raw function_app_default_hostname
terraform output -raw acr_login_server
terraform output -raw acr_name
terraform output -raw aci_fqdn   # só faz sentido com aci_enabled=true
```
