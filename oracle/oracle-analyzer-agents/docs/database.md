# Estrutura do Banco

## Tabelas Detectadas

- RDH_CARTAO
- RDH_CARTAO_DETALHE
- RDH_FUNCIONARIO
- RDH_DEPARTAMENTO
- RDH_ATIVIDADE
- RDH_PROJETO_AREA
- RDH_PROJETO
- RDH_REGIME_TRABALHO
- RDH_FUNCIONARIO_MES
- RDH_FUNCIONARIO_FERIAS
- RDH_FUNCIONARIO_LICENCA
- RDH_UNIDADE_HORA_NORMAL
- RDH_UNIDADE_HORA_EXTRA
- RDH_CALENDARIO
- RDH_SINDICATO
- RDH_BANCO_HORAS

## Observações

- RDH_CARTAO / RDH_CARTAO_DETALHE: núcleo de lançamento de horários, com dependência mestre/detalhe.
- RDH_FUNCIONARIO_MES: controle de histórico laboral, horas e condições do funcionário por mês.
- RDH_CALENDARIO + RDH_UNIDADE_HORA_*: regras de período e jornada aplicadas no cálculo de horas.
- RDH_SINDICATO: parametrização de limite de horas extras e perícia sindical.
- RDH_BANCO_HORAS: controle de compensação para bloqueio de cartões com as datas.
