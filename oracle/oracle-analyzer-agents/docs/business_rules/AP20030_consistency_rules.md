# Regras de Consistência — Form AP20030

## Visão Geral

As regras de negócio são extraídas dos triggers e programas do form AP20030 e da procedure RDH.BLOQUEIA_CARTOES. Envolvem validação de data, aprovação, cálculo de horas e controle de integração.

## Regras Identificadas

1. Se o funcionário for sub.global (ve_vinculo_id = 'G'), bloquear inclusão de cartão e exibir mensagem.
2. Se cartão estiver com data de fechamento em calendário <= sysdate, não permitir alteração nem desbloqueio.
3. Se cartão periódico, exige data_fim_periodico no mesmo mês e maior que data_cartao.
4. Se funcionário em férias/licença com flag_acesso_proibido='S', bloquear lançamento de cartão.
5. Se somatório das horas (normais+extras+... ) não corresponder ao total de detalhes, marcar cartão incorreto.
6. Se cartão com horas extras/adicional e flag_aprovacao_chefia != 'S', bloqueia integração.
7. Se cartão integrado (data_integracao não nulo), edição/exclusão restrita ao gerente (irrestrito='S').
8. Consistência de projeto/área/atividade com ver_projeto/ver_area/ver_atividade/valida_hora_extra.
9. Cálculo de horas periódicas via calcula_horas_periodico e validacoes de entrada/saída (limites de 1 dia, ordem cronológica).
10. Persistência: Habilita/desabilita edição de campos dependendo de flags de cartão e uso de consultas.

## Dependências entre regras

- blocking: se apenas 1 condição não satisfeita, cartão é invalidado.
- `consiste_lancamentos` → `cons_hor_lancto` / `VER_ATIVIDADE` / `VER_PROJETO`.

## Fluxo sugerido

1. Inserção/consulta no form AP20030
2. Valida funcionário no RDH_FUNCIONARIO_MES
3. Valida mês e calendário
4. Valida projeto, área e atividade
5. Calcula horas e valida extras
6. Atualiza flags e permite commit
7. Procedure BLOQUEIA_CARTOES executa antes de transferir para RDHT
