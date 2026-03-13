--------------------------------------------------------
--  Arquivo criado - quarta-feira-março-11-2026   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure BLOQUEIA_CARTOES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "RDH"."BLOQUEIA_CARTOES" 
IS
/* ************************************************************************
   * AP900490 - Procedure para bloquear os cart?es                        *
   * Analista - Nancy                                                     *
   * Autor    - Norma (SPPR)                                              *
   * Data     - 17.02.1998                                                *
   *                                                                      *
   * Tabelas  - RDH_FUNCIONARIO_MES		-	INPUT                         *
   *            RDH_CARTAO			-	INPUT/OUTPUT                      *
   *            RDH_CARTAO_DETALHE		-	INPUT                         *
   *            RDH_FUNCIONARIO_FERIAS		-	INPUT                     *
   *            RDH_FUNCIONARIO_LICENCA		-	INPUT                     *
   *                                                                      *
   *                                                                      *
   ************************************************************************ */
-- Oshikava 21/05/2007
-- Alteracão do cursor para incluir o flag_aprovacao_supervisor para os projetos
-- que deverão ser aprovados pelo supervisor (horas projeto)

   v_check1                     rdh_cartao.rf_funcionario_id%type;
   v_check2                     rdh_cartao.data_cartao%type;
   
/* *************************************************************************/
/* *               TABELA DE HORAS EXTRAS DAS UNIDADES                     */
/* *************************************************************************/
    CURSOR unid_he IS
        SELECT unid_oper_unid_oper_id,
                sin_sindicato_id,
                tipo_extra,
                sequencia,
                inicio,
                fim
        FROM   rdh_unidade_hora_extra
        ORDER BY unid_oper_unid_oper_id, sin_sindicato_id, sequencia;

/* *************************************************************************/
/* *  CURSOR PARA OBTER O HORARIO DE SAIDA DAS UNIDADES                    */
/* *************************************************************************/
   CURSOR unid IS
      SELECT  unid_oper_unid_oper_id,
	      data_vigencia,
	      saida_flex_2
      FROM    rdh_unidade_hora_normal
      WHERE   tipo		= 'N'
      ORDER BY unid_oper_unid_oper_id, data_vigencia DESC;
      
/* *************************************************************************/
/* *  CURSOR PARA OBTER OS FUNCIONARIOS QUE TERÃO OS CARTÕES TRANSFERIDOS  */
/* *  PRA O RDHT                                                           */
/* *************************************************************************/
   CURSOR func IS
      SELECT
	      func.funcionario_id,
	      func.dp_departamento_id,
	      func.up_unid_oper_unid_oper_id,
	      func.data_demissao,
	      func.ft1_funcionario_tipo_id,
	      func.flag_aprov_automatica,
            func.sin_sindicato_id,
            sind.lim_prim_horas_extras
      FROM    rdh_funcionario       func,
              rdh_sindicato         sind
      WHERE   func.flag_rdht        = 'S'
      AND     sind.sindicato_id     = func.sin_sindicato_id
      --AND func.funcionario_id = '002331' --MPS 08/03/2023
      ORDER BY up_unid_oper_unid_oper_id, sin_sindicato_id;
      
/* *************************************************************************/
/* *  CURSOR PARA SELECIONAR OS CARTOES QUE SERAO TRANSFERIDOS             */
/* *************************************************************************/
   CURSOR valores (p_funcionario	VARCHAR2, p_data_demissao	DATE,
		   p_funcionario_tipo	VARCHAR2, p_aprov_automatica	VARCHAR2) IS
      SELECT  /*+ INDEX(B CRD_PK) */
	      a.rowid x1,
	      b.rowid x2,
	      a.rf_funcionario_id,
	      a.data_cartao,
	      NVL(a.saida_padrao, a.saida_almoco) saida_padrao,
              a.flag_batida_fora_horario,
	      a.flag_aprovacao_chefia,
	      a.funcionario_inclusao,
	      a.qtde_horas_extra_c,
	      a.qtde_horas_ad_extra,
	      DECODE(a.data_fim_periodico, NULL, 'N', 'P') tipo_cartao
      FROM    rdh_cartao a,
	      rdh_cartao_detalhe b
      WHERE   a.data_integracao    IS NULL
      --And a.data_cartao = '22/02/2023' -- MPS: 08/03/2023
      --And trunc(a.data_cartao) = '02/05/2022' -- MPS: 27/05/2022
      AND   (p_data_demissao     IS NULL OR
	       (p_data_demissao    IS NOT NULL AND
	       a.data_cartao       <= p_data_demissao))
      AND   a.flag_cartao_correto = 'S'
	  AND  (a.flag_lancto_medico  = 'N' OR
	      (a.flag_lancto_medico = 'S' AND
	       a.flag_aprovacao_rh  = 'S'))
      AND  (a.flag_ferias_gozadas  = 'N' OR
	      (a.flag_ferias_gozadas = 'S' AND
	       a.flag_aprovacao_rh  = 'S'))
	  AND  (p_funcionario_tipo    = '09'  OR
	      p_aprov_automatica    = 'S'   OR
	      ((a.flag_mudanca_horario = 'N' OR
		(a.flag_mudanca_horario = 'S' AND
		 a.flag_aprovacao_chefia = 'S'))	AND
	       (a.flag_lancto_permitidas = 'N' OR
		(a.flag_lancto_permitidas = 'S' AND
		 a.flag_aprovacao_chefia = 'S'))	AND
	       (a.flag_batidas_fora_padrao = 'N' OR
		(a.flag_batidas_fora_padrao = 'S' AND
		 a.flag_aprovacao_chefia = 'S'))	AND
	       (NVL(a.qtde_horas_extra_c, 0)  = 0 OR
		(NVL(a.qtde_horas_extra_c, 0) <> 0 AND
		 a.flag_aprovacao_chefia = 'S'))	AND
	       (NVL(a.qtde_horas_ad_extra, 0) = 0 OR
		(NVL(a.qtde_horas_ad_extra, 0) <> 0 AND
		 a.flag_aprovacao_chefia = 'S'))))
	  AND   a.rf_funcionario_id = b.crt_rf_funcionario_id(+)
	  AND   a.data_cartao    = b.crt_data_cartao(+)
	  AND   a.rf_funcionario_id = p_funcionario
      ORDER BY a.rf_funcionario_id, a.data_cartao
	  FOR UPDATE OF a.data_integracao, b.descricao NOWAIT;
    
/* *************************************************************************/
/* *  CURSOR PARA SELECIONAR OS LANCAMENTOS QUE NÃO TENHAM SIDO APROVADOS  */
/* *************************************************************************/

   CURSOR aprov_horas (p_funcionario_id VARCHAR2, p_data_cartao DATE) IS
      SELECT /*+ INDEX(RDH_CARTAO_DETALHE CRD_PK) */ 'N'
      FROM   rdh_cartao_detalhe
      WHERE  crt_rf_funcionario_id = p_funcionario_id
      AND    crt_data_cartao       = p_data_cartao
      AND    ( flag_aprovacao_horas  = 'N' or flag_aprovacao_supervisor ='N' );

/* *************************************************************************/
/* *   CURSOR PARA VERIFICAR SE O FUNCIONARIO ESTA EM PERIODO DE FERIAS    */
/* *************************************************************************/
  CURSOR ferias (p_funcionario VARCHAR2, p_data DATE) IS
     SELECT 'X'
     FROM   rdh_funcionario_ferias
     WHERE  rf_funcionario_id     = p_funcionario
     AND    data_inicio          <= p_data
     AND    data_termino         >= p_data;
/* *************************************************************************/
/* *   CURSOR PARA VERIFICAR SE O FUNCIONARIO ESTA EM PERIODO DE LICENCA   */
/* *************************************************************************/
  CURSOR licenca (p_funcionario VARCHAR2, p_data DATE) IS
     SELECT 'x'
     FROM   rdh_funcionario_licenca
     WHERE  rf_funcionario_id     = p_funcionario
     AND    data_inicio          <= p_data
     AND    data_termino         >= p_data;
/* *************************************************************************/
/* *   CURSOR PARA OBTER O MES A PARTIR DO QUAL SERA FEITA A CONSULTA DO   */
/* *   BANCO DE HORAS                                                      */
/* *************************************************************************/
   CURSOR dt_banco IS
     SELECT ADD_MONTHS(mes, 1)
     FROM   rdh_banco_horas
     WHERE  data_compensacao IS NOT NULL
     ORDER BY mes DESC;
/* *************************************************************************/
/* *  CURSOR PARA VERIFICAR SE EXISTEM CARTOES COM LANCAMENTO INCONSISTENTE*/
/* *************************************************************************/
    CURSOR cart_incor (p_funcionario VARCHAR2, p_data DATE) IS
        SELECT  'X'
        FROM    RDH_CARTAO
        WHERE   rf_funcionario_id = p_funcionario 
        AND     data_cartao = p_data
        AND     (nvl(QTDE_HORAS_NORMAIS_C,0) + nvl(QTDE_HORAS_FALTA_C,0)
                  + nvl(QTDE_HORAS_EXTRA_C,0)+
                    nvl(QTDE_HORAS_AD_NORMAL,0) + nvl(QTDE_HORAS_AD_EXTRA,0)) <>
             (SELECT (sum(nvl(HORAS_NORMAIS_I,0)) + sum(nvl(HORAS_EXTRAS_I,0)))
              FROM   rdh_cartao_detalhe
              WHERE  crt_rf_funcionario_id = rf_funcionario_id 
              AND   crt_data_cartao = data_cartao
        GROUP  BY crt_rf_funcionario_id ,crt_data_cartao); 
              
/* *************************************************************************/
/* *  TABELA COM OS HORARIOS DE SAIDA DA UNIDADES                          */
/* *************************************************************************/
   TYPE unidade_table_type		IS TABLE OF	rdh_unidade_hora_normal.unid_oper_unid_oper_id%TYPE
	INDEX BY BINARY_INTEGER;
   TYPE dt_vigencia_table_type		IS TABLE OF	rdh_unidade_hora_normal.data_vigencia%TYPE
	INDEX BY BINARY_INTEGER;
   TYPE saida_table_type		IS TABLE OF	rdh_unidade_hora_normal.saida_flex_2%TYPE
	INDEX BY BINARY_INTEGER;
   tbl_unidade			UNIDADE_TABLE_TYPE;
   tbl_dt_vigencia		DT_VIGENCIA_TABLE_TYPE;
   tbl_saida			SAIDA_TABLE_TYPE;
/* *************************************************************************/
/* *               TABELA DE HORAS EXTRAS DAS UNIDADES                     */
/* *************************************************************************/
  TYPE unidade_he_table_type		IS TABLE OF  rdh_unidade_hora_extra.unid_oper_unid_oper_id%TYPE
	INDEX BY BINARY_INTEGER;
  TYPE sindicato_table_type		IS TABLE OF  rdh_unidade_hora_extra.sin_sindicato_id%TYPE
	INDEX BY BINARY_INTEGER;
  TYPE horario_table_type		IS TABLE OF  rdh_unidade_hora_extra.inicio%TYPE
	INDEX BY BINARY_INTEGER;
  TYPE tipo_extra_table_type		IS TABLE OF  rdh_unidade_hora_extra.tipo_extra%TYPE
	INDEX BY BINARY_INTEGER;
  tbl_unid_he				UNIDADE_HE_TABLE_TYPE;
  tbl_sind_he               SINDICATO_TABLE_TYPE;
  tbl_horario_1				HORARIO_TABLE_TYPE;
  tbl_horario_2				HORARIO_TABLE_TYPE;
  tbl_horario_3				HORARIO_TABLE_TYPE;
  tbl_horario_4				HORARIO_TABLE_TYPE;
  tbl_tipo_extra		    TIPO_EXTRA_TABLE_TYPE;
/* ---------------------------------------------------------------------- */
/*                        DEFINICAO DE VARIAVEIS                          */
/* ---------------------------------------------------------------------- */
  v_unid_he_ant				rdh_unidade_hora_extra.unid_oper_unid_oper_id%TYPE := NULL;
  v_sind_ant                rdh_unidade_hora_extra.sin_sindicato_id%TYPE;
  v_horario_1				rdh_unidade_hora_extra.inicio%TYPE := NULL;
  v_horario_2				rdh_unidade_hora_extra.inicio%TYPE := NULL;
  v_horario_3				rdh_unidade_hora_extra.inicio%TYPE := NULL;
  v_horario_4				rdh_unidade_hora_extra.inicio%TYPE := NULL;
  v_ind_unid				NUMBER(4) := 0;
  v_tipo_extra				rdh_unidade_hora_extra.tipo_extra%TYPE := NULL;
  v_saida				    rdh_unidade_hora_normal.saida_flex_2%TYPE;
  v_dt_vigencia				rdh_unidade_hora_normal.data_vigencia%TYPE;
  v_ind					    NUMBER(4) := 0;
  v_unid				    rdh_unidade_hora_normal.unid_oper_unid_oper_id%TYPE := ' ';
  v_data_inicio				DATE;
  v_mes_ano                 DATE;
  v_aprovacao_horas			VARCHAR2(1);
  v_dummy				    VARCHAR2(1);
  registro_locado			EXCEPTION;
  PRAGMA EXCEPTION_INIT(registro_locado, -0054);
  v_debug                   VARCHAR2(150);
  
BEGIN
    /*======== Carga da tabela auxiliar de horas extras das unidades =========*/
    v_debug := 'Carga da tabela auxiliar de horas extras das unidades';
    
    For r_unid_he In unid_he Loop
    
        If v_unid_he_ant Is Null Or
           v_unid_he_ant <> r_unid_he.unid_oper_unid_oper_id Or
            v_sind_ant <> r_unid_he.sin_sindicato_id Then
            
            v_ind_unid := v_ind_unid + 1;
            tbl_unid_he   (v_ind_unid) := r_unid_he.unid_oper_unid_oper_id;
            tbl_sind_he   (v_ind_unid) := r_unid_he.sin_sindicato_id;
            tbl_horario_1 (v_ind_unid) := r_unid_he.inicio;
            tbl_horario_2 (v_ind_unid) := 0;
            tbl_horario_3 (v_ind_unid) := 0;
            tbl_horario_4 (v_ind_unid) := 0;
            tbl_tipo_extra(v_ind_unid) := r_unid_he.tipo_extra;
            
            v_unid_he_ant := r_unid_he.unid_oper_unid_oper_id;
            v_sind_ant    := r_unid_he.sin_sindicato_id;
            
        ElsIf r_unid_he.sequencia = '2' Then
        
            tbl_horario_2 (v_ind_unid) := r_unid_he.inicio;
            tbl_horario_3 (v_ind_unid) := r_unid_he.fim;
            
        ElsIf r_unid_he.sequencia = '4' Then
        
            tbl_horario_4 (v_ind_unid) := r_unid_he.inicio;
            
        End If;
        
    End Loop;

    /* CARGA DA TABELA DE HORARIO DE SAIDA DAS UNIDADES            */
    v_debug := 'CARGA DA TABELA DE HORARIO DE SAIDA DAS UNIDADES ';
    
    For r_unid In unid Loop
   
      v_ind := v_ind + 1;
      tbl_unidade (v_ind) := r_unid.unid_oper_unid_oper_id;
      tbl_dt_vigencia (v_ind) := r_unid.data_vigencia;
      tbl_saida (v_ind) := r_unid.saida_flex_2;
      
    End Loop;
   
    v_check1 := ' ';
    v_check2 := NULL;
    v_unid_he_ant := NULL;
    
    -- DBMS_OUTPUT.PUT_LINE('/*  LEITURA DA TABELA DE FUNCIONARIOS   */');
    v_debug := 'LEITURA DA TABELA DE FUNCIONARIOS';
    
    For r_func In func LOOP
    Begin
    
        --DBMS_OUTPUT.PUT_LINE('/*  LEITURA DOS CARTOES DO FUNCIONARIO  */');
        For x In valores (r_func.funcionario_id, r_func.data_demissao,
			r_func.ft1_funcionario_tipo_id, r_func.flag_aprov_automatica) Loop
            If v_dt_vigencia Is Null Or (r_func.up_unid_oper_unid_oper_id <> v_unid Or x.data_cartao < v_dt_vigencia) Then
               
                For i In 1..v_ind Loop
                    
                    If r_func.up_unid_oper_unid_oper_id = tbl_unidade(i) And x.data_cartao >= tbl_dt_vigencia (i) Then
                        v_unid := tbl_unidade(i);
                        v_dt_vigencia := tbl_dt_vigencia(i);
                        v_saida	:= tbl_saida(i);
                        Exit;
                    End If;
                    
                End Loop;
               
            End If;
            
            IF (x.flag_batida_fora_horario = 'S' AND
                x.saida_padrao > TO_DATE(TO_CHAR(x.data_cartao, 'ddmmyyyy') || LPAD(v_saida, 4, '0'), 'ddmmyyyyhh24mi') AND
                x.flag_aprovacao_chefia = 'N' AND r_func.ft1_funcionario_tipo_id <> '09' AND 
                r_func.flag_aprov_automatica = 'N') THEN
                GOTO continua_loop;
            END IF;
            
            /*    DESPREZAR E ATUALIZAR O CARTAO SE O HOUVER INCONSISTENCIA DE LANCAMENTO */
            OPEN cart_incor (x.rf_funcionario_id, x.data_cartao);
            FETCH cart_incor INTO v_dummy;
            IF cart_incor%FOUND THEN
                CLOSE cart_incor;
                UPDATE rdh_cartao
                SET flag_cartao_correto = 'N'
                WHERE rowid = x.x1;
                GOTO continua_loop;
            END IF;
            CLOSE cart_incor;
            
            /*    DESPREZAR O CARTAO SE O FUNCIONARIO ESTIVER EM PERIODO DE FERIAS   */
            IF x.funcionario_inclusao <> 'AUTFERIA' THEN
                OPEN ferias (x.rf_funcionario_id, x.data_cartao);
                FETCH ferias INTO v_dummy;
                IF ferias%FOUND THEN
                    CLOSE ferias;
                    GOTO continua_loop;
                END IF;
                CLOSE ferias;
            END IF;
            
            /*  DESPREZAR O CARTAO SE O FUNCIONARIO ESTIVER EM PERIODO DE LICENCA   */
            IF x.funcionario_inclusao <> 'AUTLICEN' THEN
                OPEN licenca (x.rf_funcionario_id, x.data_cartao);
                FETCH licenca INTO v_dummy;
                IF licenca%FOUND THEN
                    CLOSE licenca;
                    GOTO continua_loop;
                END IF;
                CLOSE licenca;
            END IF;
            
            /*  DESPREZAR O CARTAO SE HOUVER ALGUM LANCAMENTO SEM APROVACAO DE HORAS */
            IF v_check1 <> x.rf_funcionario_id OR v_check2 <> x.data_cartao THEN
                v_aprovacao_horas := 'S';
                OPEN aprov_horas (x.rf_funcionario_id, x.data_cartao);
                FETCH aprov_horas INTO v_aprovacao_horas;
                    IF X.rf_funcionario_id  = 'SP006100' THEN
                       DBMS_OUTPUT.PUT_LINE('APRO '||v_aprovacao_horas);
                    END IF;
                CLOSE aprov_horas;
                IF v_aprovacao_horas = 'N' THEN
                   GOTO continua_loop;
                END IF;
             ELSIF v_aprovacao_horas = 'N' THEN
                GOTO continua_loop;
             END IF;
            
            /*  === obter as horas extras da unidade ao qual o funcionario esta alocado === */
            IF v_unid_he_ant IS NULL OR
               v_unid_he_ant <> r_func.up_unid_oper_unid_oper_id OR
               v_sind_ant    <> r_func.sin_sindicato_id          THEN
               
                v_horario_1 := 0;
                v_horario_2 := 0;
                v_horario_3 := 0;
                v_horario_4 := 0;
               
                FOR i IN 1..v_ind_unid LOOP
               
                    IF r_func.up_unid_oper_unid_oper_id = tbl_unid_he (i) AND
                      (tbl_sind_he (i) = '00' OR r_func.sin_sindicato_id = tbl_sind_he (i)) THEN
                      
                        v_horario_1  := tbl_horario_1 (i);
                        v_horario_2  := tbl_horario_2 (i);
                        v_horario_3  := tbl_horario_3 (i);
                        v_horario_4  := tbl_horario_4 (i);
                        v_tipo_extra := tbl_tipo_extra(i);
                        EXIT;
                        
                    END IF;
                  
                END LOOP;
                
                v_unid_he_ant := r_func.up_unid_oper_unid_oper_id;
                v_sind_ant    := r_func.sin_sindicato_id;
                
            END IF;
            
            /*  DISTRIBUICÃO DE HORAS EXTRAS    */
            IF r_func.ft1_funcionario_tipo_id NOT IN ('02', '05', '09') AND
               (x.qtde_horas_extra_c > 0 OR x.qtde_horas_ad_extra > 0) THEN
               
                distribui_extras_bloqueado
                    (x.rf_funcionario_id,              x.data_cartao,
                    x.tipo_cartao,                    r_func.up_unid_oper_unid_oper_id,
                    r_func.sin_sindicato_id,          r_func.lim_prim_horas_extras,
                    v_horario_1,                      v_horario_2,
                    v_horario_3,                      v_horario_4,
                    v_tipo_extra);
                    
            END IF;
            
            UPDATE rdh_cartao
            SET data_integracao = SYSDATE
            WHERE  rowid = x.x1;

            <<continua_loop>>
             
            v_check1 := x.rf_funcionario_id;
            v_check2 := x.data_cartao;
     
        END LOOP;
        
        COMMIT;
    
    EXCEPTION
        WHEN registro_locado  THEN
            dbms_output.put_line('REGISTRO_LOCADO ' ||SQLERRM);   
            v_debug := 'REGISTRO_LOCADO';
            ROLLBACK;
    END;
    
    END LOOP;
    
    v_debug := 'Open dt_banco';
    OPEN dt_banco;
    FETCH dt_banco INTO v_mes_ano;
    CLOSE dt_banco;
    
    v_debug := 'pack_consulta_saldo_horas.inclui_tabela_consulta';
    pack_consulta_saldo_horas.inclui_tabela_consulta('GERAL', v_mes_ano, 'EMPRESA');
    
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);   
      dbms_output.put_line(v_debug);   
      
END bloqueia_cartoes ;

/
