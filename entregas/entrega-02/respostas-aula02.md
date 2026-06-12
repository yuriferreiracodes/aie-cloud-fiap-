# Respostas — Aula 2 (Storage & Bancos de Dados)

> **Grupo:** _(preencher: nomes dos integrantes)_
> **Distribuição do trabalho:** _(preencher: quem fez o quê)_

---

## 🟢 Nível 1

### 1.1 — Tipos de Storage

| Cenário | Tipo | Justificativa |
|---------|------|---------------|
| Imagens de produtos (5M SKUs) | **Object** | Muitos arquivos, acessados via HTTP, não precisa de sistema de arquivos. |
| Disco do SO de uma VM de banco | **Block** | Precisa de baixa latência e fica colado a uma única VM. |
| Pasta compartilhada entre 10 VMs | **File** | Pode ser montada em várias VMs ao mesmo tempo (`/mnt/dados`). |
| Backup mensal (retenção 7 anos) | **Object (Archive)** | Acesso raro, prioridade é custo baixo. |
| Modelos `.pkl` para serving | **Object** | Download via HTTP e dá pra versionar por blob. |
| Logs diários para análise futura | **Object (lifecycle Hot→Cool→Archive)** | Esfria com o tempo e dá pra consultar com analytics serverless. |

### 1.2 — Tiers de acesso (cálculo)

2 TB = 2.048 GB.

- **a) Tudo em Hot:** 2.048 × $0,018 = **$36,86/mês** (~$442/ano)
- **b) Com lifecycle (30 dias Hot + Archive depois):**
  - Hot: 2.048 × (30/365) × $0,018 ≈ $3,03/mês
  - Archive: 2.048 × (335/365) × $0,002 ≈ $3,76/mês
  - **Total ≈ $6,79/mês**
- **c) Economia anual:** (36,86 − 6,79) × 12 ≈ **$360/ano**

Em volumes reais da QC (centenas de TB) isso vira economia de seis dígitos por ano.

### 1.3 — Relacional vs NoSQL

| Caso de uso | Escolha | Justificativa |
|-------------|---------|---------------|
| Carrinho ativo | Cosmos (NoSQL doc) | Schema variável, leitura rápida e expira sozinho (TTL). |
| Catálogo de produtos | Azure SQL | Schema fixo, joins com categorias e integridade de estoque. |
| Reviews (texto livre) | Cosmos (NoSQL doc) | Texto sem schema rígido, volume alto. |
| "Produtos similares" | AI Search (Vector) | É busca por similaridade semântica, não por igualdade. |
| Histórico de pedidos | Azure SQL | Faturamento exige ACID e garantias transacionais. |
| Sessão do usuário (expira 30min) | Redis ou Cosmos com TTL | Chave-valor com expiração; Redis é o ideal, Cosmos com TTL resolve. |
| Logs de navegação | NoSQL ou Object + Synapse | Volume gigante; depende se o uso é analítico (aí Object + Synapse). |

### 1.4 — Key Vault e RBAC (menor privilégio)

| Perfil | Role | Justificativa |
|--------|------|---------------|
| Você (dev + ops) | **Key Vault Secrets Officer** | CRUD em segredos sem precisar ser Owner. |
| Function lendo connection string | **Key Vault Secrets User** | Só leitura no plano de dados, via Managed Identity. |
| Engenheiro de segurança (audita) | **Key Vault Reader** | Lê metadados, não os valores dos segredos. |
| CI/CD injetando segredos | **Key Vault Secrets Officer** (service principal dedicado) | Precisa criar segredos, mas com identidade própria e escopo limitado. |
| FinOps (ver custo) | **Reader no Resource Group** | Vê custo no Cost Management sem acessar o Vault. |

---

## 🟡 Nível 2

### 2.1 — Matriz de dados da QC

| Domínio | Serviço Azure | SKU/Config | Justificativa |
|---------|---------------|------------|---------------|
| Produtos (5M SKUs) | Azure SQL | Geral, com réplica de leitura | Schema fixo, joins com categoria/estoque, integridade. |
| Clientes (~50M) | Azure SQL | Geral + particionamento | Dados estruturados e relacionais; LGPD exige controle forte. |
| Pedidos (~10M/mês) | Azure SQL | Business Critical | Alta criticidade transacional, precisa de ACID. |
| Carrinhos (~500k, expiram 24h) | Cosmos DB | TTL 24h | Schema variável, leitura rápida, expira sozinho. |
| Reviews (~30M, texto livre) | Cosmos DB | Partição por `produto_id` | Texto sem schema rígido, alimenta análise de sentimento. |
| Busca de produtos | Azure AI Search | Standard + vector | Busca semântica para agentes e frontend. |
| Sessões (~1M ativas) | Redis (ou Cosmos TTL) | Cache | Chave-valor de baixa latência com expiração. |
| Histórico de navegação (bilhões) | Object Storage + Synapse | Blob + serverless | Volume enorme, uso analítico, sem precisar de banco quente. |
| Modelos de ML | Object Storage | Blob versionado | Arquivos baixados via HTTP, versionados por blob. |

> **Diagrama:** _(desenhar a camada de dados no Excalidraw/draw.io e salvar em `diagramas/arquitetura-qc-aula02.png`)_

### 2.2 — Plano de migração (12 meses)

**a) Os 6 Rs por repositório:**
- Oracle on-premise (8 TB) → **Replatform** (vai pra Azure SQL / PostgreSQL gerenciado, sem reescrever a aplicação inteira).
- 50 TB de imagens no NAS → **Rehost** (sobe pro Blob Storage como está).
- 200 TB de logs em fita (compliance) → **Retain/Archive** (vai direto pro Archive tier, acesso raro).

**b) Serviços Azure por repositório:**
- Oracle → Azure SQL (ou Azure Database for PostgreSQL).
- Imagens → Blob Storage (Hot/Cool conforme acesso).
- Logs históricos → Blob Archive tier.

**c) Migração sem downtime:**
- Banco: **Azure Database Migration Service** em modo online (replicação contínua até o cut-over).
- Imagens e arquivos: **AzCopy** em paralelo, com sincronização final antes de virar a chave.

**d) Custo de egress dos 50 TB:**
- Egress é cobrado na *saída* dos dados. Região **Brazil South (América do Sul)** é a mais cara. Pela tabela de bandwidth da Azure (1 TB = 1.000 GB, então 50 TB = 50.000 GB):
  - Primeiros 100 GB: grátis
  - Próximos 10.000 GB × $0,181 = $1.810
  - Restantes 39.900 GB × $0,175 = $6.982,50
  - **Total ≈ $8.793** (custo único da migração)
- Como é caro, mitiga com **Azure Data Box** (envio físico do disco) em vez de mandar tudo pela rede.

**e) Compliance LGPD:**
- Dados de brasileiros ficam em **região Brazil South**, com criptografia em repouso e em trânsito, e segredos no Key Vault. Acesso por RBAC de menor privilégio.

### 2.3 — Particionamento no Cosmos DB

**a) Por que NÃO usar como partition key:**
- `id` da review: cada review vira uma partição (cardinalidade altíssima), impossível agrupar reviews de um produto, e consultas viram cross-partition.
- `score` (1-5): só 5 valores possíveis → partições gigantes e desbalanceadas (hot partition).
- `data_da_review`: as reviews de hoje caem todas na mesma partição → hot partition no "agora" e desperdício nas datas antigas.

**b) Por que `produto_id` funciona, mas tem ressalva:**
Distribui bem na média, mas um **produto best-seller** com muitas reviews vira uma **hot partition** (concentra leitura/escrita e pode estourar a quota de 20 GB).

**c) Otimizar para "reviews de um cliente":**
Usar **hierarchical partition keys** (ex.: `produto_id` + `cliente_id`), assim dá pra consultar tanto por produto quanto por cliente sem espalhar pela base toda.

**d) Tamanho da partição (estimativa):**
O documento de review do lab tem ~5 campos (`id`, `produto_id`, `score`, `texto`, `cliente`) e pesa **~0,3–0,5 KB** com os campos internos do Cosmos. Em produção, com texto livre maior, fica em torno de **1–2 KB**. Para 50.000 reviews de um produto:
- Cenário lab (~0,5 KB): 50.000 × 0,5 KB ≈ **25 MB** → ~0,12% da quota
- Cenário produção (~2 KB): 50.000 × 2 KB ≈ **100 MB** → ~0,5% da quota

Em qualquer cenário fica **muito abaixo** da quota de 20 GB por partição lógica — folgadíssimo.

---

## 💭 Reflexão coletiva

Segregar segredos no Key Vault muda o modelo de segurança porque tira credenciais do código e dos arquivos de config e centraliza o controle em RBAC + Managed Identity. Numa plataforma com agentes (que acessam vários serviços de forma autônoma), isso é crítico: cada agente/serviço recebe só a permissão mínima (ex.: Secrets User só de leitura), os acessos ficam auditáveis, e dá pra rotacionar segredos sem mexer no código. Sem isso, um agente comprometido teria acesso amplo; com isso, o estrago fica contido ao escopo daquela identidade.

---

> _N3 (vector search, Synapse, benchmark) é bônus e exige rodar os labs no Azure — não incluído nesta versão._
