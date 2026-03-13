# Consistência do processo BLOQUEIA_CARTOES

Arquivo de origem: `inputs/ddl/BLOQUEIA_CARTAO.sql`

## Objetivo do script

Procedure `RDH.BLOQUEIA_CARTOES` seleciona cartões de ponto aptos para transferência ao RDHT e aplica regras de bloqueio/proteção de integridade.

## Regras de consistência identificadas

1. Cartões somente com `a.data_integracao IS NULL` podem ser considerados (não integrais).
2. Cartões devem estar marcados `a.flag_cartao_correto = 'S'` para irem ao processo.
3. Se `a.flag_lancto_medico = 'S'`, exige `a.flag_aprovacao_rh = 'S'`.
4. Se `a.flag_ferias_gozadas = 'S'`, exige `a.flag_aprovacao_rh = 'S'`.

### Validação completa de candidato (cursor `valores`)

5. Para funcionários tipo 09 ou aprovacao_automatica = 'S' a aprovação chefia pode não ser exigida.
6. Para demais, são exigidas as seguintes condições de chefia:
    - `flag_mudanca_horario = 'N'` ou (`'S'` e `flag_aprovacao_chefia = 'S'`)
    - `flag_lancto_permitidas = 'N'` ou (`'S'` e `flag_aprovacao_chefia = 'S'`)
    - `flag_batidas_fora_padrao = 'N'` ou (`'S'` e `flag_aprovacao_chefia = 'S'`)
    - `qtde_horas_extra_c = 0` ou (`<>0` e `flag_aprovacao_chefia = 'S'`)
    - `qtde_horas_ad_extra = 0` ou (`<>0` e `flag_aprovacao_chefia = 'S'`)

## Regras de consistência transversais

7. Cursor `cart_incor`: bloqueia cartão em que soma de horas calculadas em `RDH_CARTAO` difere de somatório de `RDH_CARTAO_DETALHE` (`HORAS_NORMAIS_I + HORAS_EXTRAS_I`).
8. Cursor `aprov_horas`: indica cartões com `flag_aprovacao_horas = 'N'` ou `flag_aprovacao_supervisor = 'N'` em detalhes, impossibilitando envios.
9. Cursors `ferias` e `licenca`: se existir registro de férias/licença cobrindo data do cartão, o cartão deve ser bloqueado (não enviado) quando `flag_acesso_proibido = 'S'`.

## Dependências de tabelas

- RDH_CARTAO
- RDH_CARTAO_DETALHE
- RDH_FUNCIONARIO_MES
- RDH_FUNCIONARIO_FERIAS
- RDH_FUNCIONARIO_LICENCA
- RDH_UNIDADE_HORA_NORMAL
- RDH_UNIDADE_HORA_EXTRA
- RDH_SINDICATO
- RDH_BANCO_HORAS

## Observação final

A procedure faz pré-seleção de cartões em `cursor valores` e aplica regras de aprovação e consistência antes de gravar `data_integracao` em cartões e `RDH_CARTAO_DETALHE`.
