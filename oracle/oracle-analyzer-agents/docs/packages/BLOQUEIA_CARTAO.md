# Procedure RDH.BLOQUEIA_CARTOES

## Descrição

Procedure para bloqueio e transferência de cartões ao RDHT, com checagens de férias, licença, regras de aprovação e consistência de horas.

## Objetivos

- Selecionar cartões elegíveis para integração (flag_cartao_correto, ferias, licença, etc)
- Verificar aprovações (chefia/RH) e filtros de tipo de funcionário
- Verificar consistência de horas (aprovação de lançamentos não consistentes)
- Controlar transferência de cartões para RDHT

## Cursors / Extrações

- unid_he (horas extras por unidade)
- unid (horário normal de saída por unidade)
- func (funcionários RDHT)
- valores (cartões por funcionário)
- aprov_horas (lancamentos não aprovados)
- ferias / licenca
- dt_banco
- cart_incor (cartões inconsistentes)

## Tabelas utilizadas

- RDH_CARTAO
- RDH_CARTAO_DETALHE
- RDH_FUNCIONARIO_MES
- RDH_FUNCIONARIO_FERIAS
- RDH_FUNCIONARIO_LICENCA
- RDH_UNIDADE_HORA_NORMAL
- RDH_UNIDADE_HORA_EXTRA
- RDH_SINDICATO
- RDH_BANCO_HORAS

## Dependências

- RDH_CARTAO → RDH_CARTAO_DETALHE
- RDH_CARTAO → RDH_FUNCIONARIO_MES
- RDH_CARTAO → RDH_FUNCIONARIO_FERIAS
- RDH_CARTAO → RDH_FUNCIONARIO_LICENCA
- RDH_CARTAO → RDH_UNIDADE_HORA_* (calculo funcionamento)
