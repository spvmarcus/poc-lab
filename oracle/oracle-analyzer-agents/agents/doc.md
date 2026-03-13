# Documentos Gerados pelo Analisador de Sistema Oracle — Versão V4

Este documento descreve todos os artefatos que podem ser extraídos automaticamente pelo **Analisador de Sistema Oracle V4**, desenvolvido para realizar engenharia reversa de sistemas baseados em Oracle Forms, PL/SQL e banco de dados Oracle.

Cada documento gerado possui três descrições:

1. **Documento** – Nome do artefato produzido
2. **Objetivo** – Para que o documento serve
3. **Como é feita a extração** – Método técnico utilizado pelo analisador

---

# 1. Documento de Arquitetura do Sistema

## Objetivo

Fornecer uma visão geral da arquitetura do sistema analisado, identificando os principais componentes:

* Forms
* Packages
* Tabelas
* Dependências principais

Este documento serve como **ponto de entrada para entendimento do sistema**.

## Como é feita a extração

1. O analisador percorre todos os arquivos:

   * XML exportados do Oracle Forms
   * Arquivos PL/SQL (`.sql`)
2. O parser identifica:

   * nomes de forms
   * packages utilizados
   * tabelas acessadas
3. Essas informações são agregadas no **SystemModel**.
4. O **ArchitectureGenerator** gera o arquivo:

```
docs/architecture.md
```

---

# 2. Documento Técnico de Forms

## Objetivo

Documentar a estrutura interna de cada **Oracle Form**, incluindo:

* Blocks
* Items
* Triggers
* Navegação entre forms

Esse documento permite compreender **a interface do sistema e sua lógica associada**.

## Como é feita a extração

1. Os Forms são exportados para **XML**.
2. O módulo:

```
forms_parser.py
```

analisa os elementos:

```
Block
Item
Trigger
```

3. O conteúdo é estruturado em memória.
4. O **FormsDocGenerator** gera arquivos individuais:

```
docs/forms/NOME_FORM.md
```

---

# 3. Documento Técnico de Packages

## Objetivo

Documentar cada **package PL/SQL**, identificando:

* Procedures
* Functions
* Tabelas utilizadas
* Chamadas para outros packages

Esse documento permite compreender **a camada de lógica de negócio do sistema**.

## Como é feita a extração

1. O analisador lê os arquivos `.sql` no diretório:

```
input/plsql/packages
```

2. O parser:

```
plsql_ast_parser.py
```

identifica através de expressões regulares:

```
PROCEDURE
FUNCTION
FROM
JOIN
PACKAGE.PROCEDURE
```

3. É criado um **AST simplificado** do código.

4. O **PackageDocGenerator** gera os arquivos:

```
docs/packages/NOME_PACKAGE.md
```

---

# 4. Documento de Estrutura do Banco de Dados

## Objetivo

Listar todas as tabelas utilizadas pelo sistema.

Este documento ajuda a compreender **o modelo de dados efetivamente utilizado pela aplicação**.

## Como é feita a extração

Durante o parsing de PL/SQL são identificadas instruções SQL como:

```
SELECT
INSERT
UPDATE
DELETE
JOIN
```

O parser extrai as tabelas presentes em:

```
FROM
JOIN
INTO
UPDATE
```

Essas tabelas são registradas no **SystemModel**.

O **DatabaseDocGenerator** produz:

```
docs/database/tables.md
```

---

# 5. Diagrama de Navegação entre Forms

## Objetivo

Identificar o fluxo de navegação da aplicação.

Exemplo:

```
FORM_CLIENTE → FORM_PEDIDO → FORM_FATURA
```

Esse diagrama ajuda a entender **o fluxo funcional do sistema**.

## Como é feita a extração

O parser analisa triggers em busca de chamadas como:

```
CALL_FORM
OPEN_FORM
NEW_FORM
```

Essas chamadas são capturadas e armazenadas como:

```
form_origem → form_destino
```

O gerador cria o diagrama PlantUML:

```
docs/diagrams/navigation.puml
```

---

# 6. Diagrama de Call Graph de Packages

## Objetivo

Identificar dependências entre packages e procedures.

Exemplo:

```
PKG_FINANCEIRO → PKG_CLIENTE.BUSCAR_CLIENTE
```

Isso permite visualizar **acoplamento entre módulos do sistema**.

## Como é feita a extração

O parser procura padrões de chamada:

```
PACKAGE.PROCEDURE(
PACKAGE.FUNCTION(
```

Cada ocorrência gera um relacionamento:

```
caller → callee
```

O **diagram_generator** cria:

```
docs/diagrams/call_graph.puml
```

---

# 7. Diagrama ERD (Entidade Relacionamento)

## Objetivo

Reconstruir automaticamente o **modelo relacional do banco**.

O diagrama mostra:

* tabelas
* chaves estrangeiras
* relacionamentos

## Como é feita a extração

O analisador procura padrões em scripts SQL ou DDL:

```
FOREIGN KEY (...) REFERENCES TABELA
```

Essas relações são convertidas em relações ERD.

O resultado é exportado em PlantUML:

```
docs/diagrams/erd.puml
```

---

# 8. Documento de Regras de Negócio

## Objetivo

Extrair regras de negócio embutidas no código PL/SQL.

Exemplos de regras detectadas:

```
IF dias_atraso > 30 THEN bloquear_cartao
IF salario > 10000 THEN aplicar_imposto
```

Esse documento é extremamente útil para **engenharia reversa funcional**.

## Como é feita a extração

O parser analisa estruturas condicionais:

```
IF ... THEN
ELSIF ... THEN
CASE WHEN
```

As condições são extraídas e armazenadas como **Business Rules**.

O gerador cria:

```
docs/business_rules.md
```

---

# 9. Manual Funcional Automático

## Objetivo

Gerar um documento consolidado que descreve:

* fluxos do sistema
* regras de negócio
* navegação
* componentes principais

Esse manual serve como **documentação funcional do sistema legado**.

## Como é feita a extração

O manual é montado combinando dados extraídos de:

* Forms
* Packages
* Tabelas
* Regras de negócio
* Fluxos de navegação

O módulo:

```
manual_generator.py
```

produz:

```
docs/manual_funcional.md
```

---

# 10. Diagrama de Arquitetura do Sistema

## Objetivo

Apresentar a arquitetura geral do sistema em forma de diagrama.

Exemplo de relacionamento:

```
FORM → PACKAGE → TABLE
```

Esse diagrama facilita **entendimento estrutural do sistema**.

## Como é feita a extração

O analisador cria um **grafo do sistema** contendo:

* Forms
* Packages
* Tables

As dependências detectadas são convertidas em um diagrama PlantUML:

```
docs/diagrams/architecture.puml
```

---

# Resumo dos Artefatos Gerados

Estrutura final gerada pelo analisador V4:

```
docs
│
├ architecture.md
│
├ forms
│   └ FORM_NAME.md
│
├ packages
│   └ PACKAGE_NAME.md
│
├ database
│   └ tables.md
│
├ diagrams
│   ├ navigation.puml
│   ├ call_graph.puml
│   ├ erd.puml
│   └ architecture.puml
│
├ business_rules.md
│
└ manual_funcional.md
```

---

# Conclusão

O Analisador V4 permite realizar **engenharia reversa automatizada de sistemas Oracle**, gerando documentação técnica e funcional a partir do código fonte.

Entre os principais benefícios:

* Redução do esforço de documentação manual
* Identificação de dependências do sistema
* Reconstrução da arquitetura
* Extração automática de regras de negócio
* Apoio à modernização de sistemas legados

---
