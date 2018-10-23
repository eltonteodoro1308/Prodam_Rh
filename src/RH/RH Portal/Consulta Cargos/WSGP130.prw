
// Ponto de Entrada executado pela rotina de Descritivo de Cargos no Portal GCH,
// permitindo a passagem de filtro em SQL sobre o Cargo, utilizando obrigatoriamente
// somente campos da tabela SQ3, pois o retorno sera acrescentado no WHERE sobre a SQ3

User Function WSGP130()
Return(" Q3_XCATIVO = '1' ")