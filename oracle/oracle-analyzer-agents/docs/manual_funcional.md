# Manual Funcional

## Visão Geral

O sistema AP20030 é um módulo de lançamento e validação de cartões de ponto associado ao módulo RDHT. Inclui cadastro de horários, controle de entrada/saída, cálculos de horas trabalhadas/extras e workflows de aprovação.

## Fluxos Principais

1. Usuário abre AP20030 e pesquisa cartões por funcionário/data.
2. Insere/atualiza registros (CRT7 mapeia RDH_CARTAO / CRD8 mapeia RDH_CARTAO_DETALHE).
3. Valida regras de negócio: férias/licença, calendário, jornada, aprovações.
4. Calcula horários (funções de calculo_de_horas, calcula_horas_periodico etc.).
5. Salva ou exclui registros com validações adicionais (bloqueios por integração).
6. Chama subforms: AP20020 (lancto padrão), AP20031 (relatório), AP20033 (serviço extra), AP20034 (saldo horas).
7. Procedimento RDH.BLOQUEIA_CARTOES prepara integração ao RDHT.

## Regras de Negócio

- Bloquear cartão se funcionário está sub.global.
- Bloquear se cartão no mês já fechado / ferias/licenca.
- Permitir somente aprovação ou edição se flags de aprovação estiverem ok.
- Validar consistência de horas e conciliação entre cartão e detalhe.
- Garantir formato e intervalos válidos nas datas/hora.

## Componentes do Sistema

- Forms: AP20030
- Procedures: RDH.BLOQUEIA_CARTOES
- Tabelas: RDH_CARTAO, RDH_CARTAO_DETALHE, RDH_FUNCIONARIO_MES, RDH_CALENDARIO, etc.
