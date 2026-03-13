# Arquitetura do Sistema

## Visão Geral

Sistema Oracle legado de gestão de cartões de ponto (AP20030) integrado com mecanismos de cálculo e validação de horários. A aplicação é baseada em Oracle Forms + PL/SQL e dá suporte a operações de inclusão, atualização, cálculo, validação e envio para RDHT.

## Forms

- AP20030 (Digitacao Cartao)
- Referências de navegação para AP20020, AP20031, AP20033, AP20034

## Packages/Procedures

- RDH.BLOQUEIA_CARTOES (proc)

## Tabelas

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

## Dependências Principais

Form AP20030 → Form AP20020
Form AP20030 → Form AP20031
Form AP20030 → Form AP20033
Form AP20030 → Form AP20034

Procedure RDH.BLOQUEIA_CARTOES → tabelas: RDH_CARTAO, RDH_CARTAO_DETALHE, RDH_FUNCIONARIO_MES, RDH_FUNCIONARIO_FERIAS, RDH_FUNCIONARIO_LICENCA, RDH_UNIDADE_HORA_NORMAL, RDH_UNIDADE_HORA_EXTRA, RDH_SINDICATO, RDH_BANCO_HORAS

Form AP20030 → Über módulo (FORMSUP) para navegação e integração com forms auxiliares

## Camadas do Sistema

- Interface: Oracle Forms AP20030 + item/trigger/UI
- Lógica de Negócio: Triggers PL/SQL no forms + Procedures (BLOQUEIA_CARTOES)
- Persistência: tabelas RDH_* e DML diretas em triggers/cursors
