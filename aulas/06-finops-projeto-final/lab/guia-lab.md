# Guia de Laboratório — Aula 6

**Tema:** FinOps + Trabalho no Projeto Integrado
**Plataforma:** Portal Azure + Pricing Calculator (tudo no browser)

---

## Visão geral do lab

```
Atividade 1 — Cost Management + Azure Advisor + Budget Alert      ~25 min  (L₁)
Atividade 2 — Pricing Calculator: TCO da arquitetura QC           ~30 min  (L₂)
Trabalho assistido em grupo — projeto integrado final             ~1h40
```

**Sem destroy hoje** — o trabalho desta aula é principalmente **analítico** (consultas no Cost Management, estimativas no Pricing Calculator), não provisionamento. Os recursos da QC podem estar todos destruídos das aulas anteriores ou não — o lab funciona dos dois jeitos.

---

## Preparação (3 min — antes do L₁)

```bash
# Confirmar autenticação no Portal
az account show --query "{nome:name, id:id}" -o table

# Garantir acesso ao Cost Management
az consumption usage list --top 1 -o table 2>/dev/null && echo "Acesso OK" || echo "Sem acesso ao Cost Management — verificar tenant"
```

Abra estas 3 abas no navegador:

1. [Portal Azure](https://portal.azure.com)
2. [Pricing Calculator](https://azure.microsoft.com/pricing/calculator)
3. [Azure Advisor](https://portal.azure.com/#blade/Microsoft_Azure_Expert/AdvisorMenuBlade)

---

## Atividade 1 — Cost Management + Advisor + Budget Alert

**Objetivo:** Aplicar o **Inform** + **Optimize** do FinOps na sua própria assinatura Azure for Students. Identificar onde foi gasto crédito até hoje e configurar um budget alert para o restante.

### Passo 1 — Análise de custo da assinatura

1. Portal → busque **"Cost Management"** → **Cost analysis**
2. Filtros recomendados:
   - **Date range:** Last 30 days (ou desde o início da disciplina)
   - **Granularity:** Daily
   - **Group by:** **Service name** (ou tente "Resource type")
3. **Identifique seu top 3 maiores gastadores** dos últimos 30 dias

> **Para a maioria dos alunos**, o gasto deve ser pequeno (Free tiers + lifecycle bem aplicado). Se algum item está alto, é um aprendizado real.

### Passo 2 — Explore a aba "Tag"

1. Na mesma view, mude **Group by** para **Tag**
2. Use a tag `aula` que vocês colocaram desde a Aula 1
3. Veja gastos por aula — qual aula consumiu mais?

### Passo 3 — Azure Advisor (Optimize)

1. Portal → busque **"Advisor"**
2. Aba **Cost**
3. Leia as recomendações (mesmo se a lista estiver vazia)

Recomendações comuns que aparecem:

- VMs idle (right-sizing)
- Reserved Instances aplicáveis
- Endpoints orphans (provisioned but unused)
- Storage tiers — blob frio em hot tier

Anote nas suas notas para a seção `finops/analise-otimizacao.md` do projeto final quais recomendações apareceram para sua assinatura.

### Passo 4 — Budget Alert

1. Portal → Cost Management → **Budgets** → **+ Add**
2. Configure:
   - Name: `budget-aula06`
   - Amount: **$5** (ou o que restar do seu crédito)
   - Reset period: Monthly
   - **Alert conditions:** 50%, 80%, 100% do budget
   - Alert recipients: seu e-mail
3. Salvar

### Passo 5 — Discussão (5 min)

Conversa em grupo:

- Algum membro do grupo já passou dos $50 de crédito? Em quê?
- O que vocês fariam diferente se começassem a disciplina de novo?
- Como esse aprendizado se aplica à arquitetura QC em escala?

**✅ Checkpoint L₁:** Você identificou seus top 3 gastadores + tem um Budget Alert ativo?

---

## Atividade 2 — Pricing Calculator: TCO da QC

**Objetivo:** Estimar o **custo mensal** da arquitetura completa da Quantum Commerce em **escala real** (não free tier). Este resultado entra no projeto integrado final (seção `finops/`).

### Cenário da QC

Você é arquiteto cloud apresentando à diretoria da QC. Estime o TCO mensal considerando:

| Componente | Volume mensal esperado |
|------------|------------------------|
| **Blob Storage** | 10 TB (5 TB Hot + 3 TB Cool + 2 TB Archive) — imagens + logs |
| **Azure SQL Database** | Hyperscale 4 vCores + 100 GB (não free para escala real) |
| **Cosmos DB** | 4.000 RU/s + 50 GB |
| **Azure AI Search** | Standard S1 (3 réplicas, 12 partitions) |
| **Function App** | Premium EP1 (sempre warm — 5M req/mês) |
| **Azure AI Services** | Multi-service S0: 1M chamadas Language + 5.000h Speech + 500k chamadas Vision |
| **Azure ML** | Workspace + Compute B2s ocasional + 1 Online Endpoint Standard_DS3_v2 (24/7) |
| **Application Insights** | 5 GB de logs/mês |
| **Egress** | 500 GB/mês saindo para CDN externa |

### Passo 1 — Adicionar cada serviço

1. Em https://azure.microsoft.com/pricing/calculator, **adicione um por um** todos os 9 itens acima
2. Configure **East US 2** como região para tudo (padrão da disciplina)
3. Preencha os volumes da tabela

### Passo 2 — Calcular o total

1. Role até o final — total mensal em USD
2. Converta para BRL (cotação atual ~5,3)
3. Anote os 3 itens mais caros

### Passo 3 — Otimização hipotética

Para cada item dos top 3, proponha uma otimização:

| Item caro | Otimização proposta | Economia estimada |
|-----------|---------------------|-------------------|
| | | |
| | | |
| | | |

Exemplos comuns:

- **AI Services Language:** trocar Sentiment por GPT-4o-mini (mais barato em escala se usado smart)
- **ML Endpoint 24/7:** scale-to-zero ou batch endpoint (drops 95% do custo)
- **Egress:** Azure Front Door reduz custos vs CDN externa
- **Function Premium EP1:** ficar em Consumption Y1 se cold start aceitável (volta de $146/mês para $0)

### Passo 4 — Exportar

1. Clique em **"Export"** → **Excel**
2. Salvar como `finops/estimativa-qc.xlsx` no repo privado do grupo
3. Clique em **"Share"** → copiar link
4. Guardar o link no `finops/pricing-calculator-link.md` do projeto final

### Passo 5 — Comparar com Reserved Instances

Para os itens 24/7 (SQL, Search, Function Premium se mantido, ML Endpoint):

1. Reabrir a estimativa
2. Em cada item 24/7, mudar para **1 year reserved** ou **3 year reserved**
3. Comparar economia

**Reflexão (escrever em `finops/analise-otimizacao.md` do projeto final):**

a) Qual o TCO mensal estimado em USD da arquitetura QC sem otimização?
b) Qual o TCO otimizado (com suas 3 propostas aplicadas)?
c) Qual a economia % com Reserved Instances de 1 ano?
d) **Como você apresentaria esses números ao CFO da QC** (em 1 parágrafo)?

**✅ Checkpoint L₂:** Você tem estimativa exportada (.xlsx) + análise de 3 otimizações + cenário Reserved?

---

## Trabalho assistido em grupo (1h40)

**Esta é a parte mais valiosa da Aula 6.** O professor está disponível em tempo real para ajudar.

### Checklist do projeto integrado final

Use este checklist como guia para garantir que o ZIP final está completo:

#### Documentação

- [ ] `README.md` com visão geral da arquitetura, links de cada componente, instruções de execução
- [ ] `arquitetura/diagrama-final.png` exportado do Excalidraw/draw.io
- [ ] `arquitetura/decisoes-tecnicas.md` com ADRs (mínimo 5 decisões)
- [ ] `reflexao-estrategica.md` com roadmap de 12 meses para evolução da arquitetura QC
- [ ] `distribuicao-do-trabalho.md` com rastreio de quem fez o quê em cada aula + no projeto final

#### Infraestrutura

- [ ] `terraform/main.tf` consolidado provisionando TODA a infra QC (RG, Storage, SQL, Cosmos, AI Search, Function, AI Services, ML Workspace)
- [ ] `terraform/variables.tf` + `terraform/outputs.tf`
- [ ] `terraform plan` rodando sem erros (validado durante a aula)

#### Função e tools

- [ ] `function/function_app.py` com as 5 tools: `/produtos`, `/transcrever`, `/analisar-reviews`, `/analisar-imagem`, `/recomendar`
- [ ] `function/requirements.txt` atualizado
- [ ] `tools-spec.md` com JSON Schema das 5 tools (estilo OpenAI function calling)

#### FinOps

- [ ] `finops/estimativa-qc.xlsx` exportado do Pricing Calculator (gerado nesta aula)
- [ ] `finops/analise-otimizacao.md` com top 3 itens caros + propostas de otimização + comparação com Reserved Instances
- [ ] `finops/pricing-calculator-link.md` com o link compartilhável da estimativa

> Detalhes completos do entregável final: [entregas/projeto-final/INSTRUCOES.md](../../../entregas/projeto-final/INSTRUCOES.md).

### Conversas comuns que você terá com o professor

- "Nosso Terraform não consolida porque cada aula virou pasta separada — como mesclar?"
- "Como documentar as 5 tools sem virar um documento de 100 páginas?"
- "Em FinOps, qual a maior otimização possível na arquitetura QC?"
- "Faltou X da Aula Y, dá tempo de fazer agora?"
- "Como ligar o componente A com o componente B no diagrama?"

### Tópicos que podem precisar de mini-revisão (sob demanda)

- Terraform com módulos (consolidação de várias aulas em um projeto)
- Managed Identity (vários recursos compartilhando padrão)
- Pricing de Azure OpenAI vs Language API
- Como provisionar Azure ML Workspace de forma idempotente

---

## Encerramento da Aula 6

- Confirmar **prazo final**: 1 semana após esta aula
- Local de entrega: **Portal FIAP**, tarefa "Projeto Integrado Final"
- Tamanho do ZIP: **< 20 MB** (sem `terraform.tfstate`, sem áudios, sem imagens binárias grandes)
- Rubrica final em [entregas/rubrica.md](../../../entregas/rubrica.md)
- Detalhes da entrega em [entregas/projeto-final/INSTRUCOES.md](../../../entregas/projeto-final/INSTRUCOES.md)

---

## Troubleshooting

| Problema | Solução |
|----------|---------|
| Cost Management vazio | Conta nova ou sem gasto — OK, foque no L₂ que é com cenário hipotético |
| Pricing Calculator não tem East US 2 para algum serviço | Usar outra região permitida (ex.: East US, West US 2) e mencionar isso na análise FinOps |
| Estimativa total muito alta (>$5k/mês) | Revisar volumes — provavelmente Speech ou ML Endpoint dispararam |
| Estimativa total muito baixa (<$200/mês) | Revisar volumes — provavelmente esqueceu de mudar de free tier para escala |
| Não sei como consolidar 5 Terraforms em 1 | Pedir ajuda ao professor durante o trabalho de grupo — pode demorar 15-20 min juntos |
| Falta tempo para terminar tudo na aula | Lembrar: tem 1 semana após a aula para finalizar; aula é para tirar dúvidas, não para fechar tudo |

---

## Referências

- [Azure Cost Management Documentation](https://learn.microsoft.com/azure/cost-management-billing/)
- [Azure Advisor](https://learn.microsoft.com/azure/advisor/)
- [Pricing Calculator](https://azure.microsoft.com/pricing/calculator)
- [FinOps Foundation Framework](https://www.finops.org/framework/)
- [Reserved Instances guidance](https://learn.microsoft.com/azure/cost-management-billing/reservations/save-compute-costs-reservations)
- [Azure OpenAI Pricing](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service/)
