# POC Lab

Repositório contendo Proofs of Concept (POCs) para experimentos de arquitetura,
engenharia de software, modelagem de dados e integrações.

## Objetivo

Centralizar experimentos técnicos independentes para avaliar:

- novas tecnologias
- arquiteturas
- integrações entre sistemas
- abordagens de modelagem de dados
- automações e agentes

Cada pasta contém uma POC isolada com documentação própria.

---

## Estrutura

| Área | Descrição |
|-----|-----|
| ai | Experimentos com IA e agentes |
| backend | APIs, serviços e integrações |
| frontend | Interfaces e dashboards |
| data-model | Modelagem de dados e ontologias |
| oracle | Experimentos com Oracle Forms / PL-SQL |

---

## Convenção de POCs

Cada POC deve conter:

1️⃣ Estrutura padrão de uma POC

Cada POC deve seguir um padrão simples.
```
nome-da-poc
│
├── README.md
├── src
├── examples
├── scripts
└── docker-compose.yml
```

2️⃣ README de cada POC

Exemplo:

```
backend/postgres-mcp-server/README.md
```

```markdown
# PostgreSQL MCP Server POC

POC para testar o uso do Model Context Protocol com PostgreSQL.

## Objetivo

Avaliar a viabilidade de usar MCP como camada de acesso ao banco de dados.

## Tecnologias

- Node.js
- PostgreSQL
- MCP Server

## Arquitetura

```

Client → MCP Server → PostgreSQL

```

## Execução

### 1 - subir banco

```

docker compose up -d

```

### 2 - iniciar servidor

```

npx @modelcontextprotocol/server-postgres

```

## Resultado esperado

O servidor MCP deve expor operações SQL para clientes MCP.

```

---

3️⃣ Convenção de nomes para POCs

Use sempre:

```
tecnologia-funcao-poc
```

Exemplos:

```
nextjs-dashboard-poc
postgres-mcp-server
forms-xml-parser
ifc-property-generator
multi-agent-forms-analyzer
```

---

4️⃣ .gitignore recomendado

```
node_modules
.env
dist
build
__pycache__
*.log
*.tmp
.DS_Store
```

---

## Observações

Este repositório contém apenas experimentos técnicos.  
Os projetos aqui não necessariamente representam código de produção.
```