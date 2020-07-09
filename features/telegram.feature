# language: es

@wip
Característica: Flujo completo via telegram

"""
    Estos escenarios son para ejecucion manual de todo el flujo y por ello no son gherkin estricto

    """

    Escenario: TELE1 - Consulta de planes sin haber cargado ninguno
        Dado que no existe ningún plan cargado
        Cuando envio "/planes"
        Entonces recibo un mensaje diciendo que no hay planes cargados todavía

    Escenario: TELE1.5 - Consulta de planes en general
        Dado que existe el plan "PlanJuventud"
        Cuando envio "/planes"
        Entonces recibo listado de los planes dados de alta
