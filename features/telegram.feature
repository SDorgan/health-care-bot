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

    Escenario: TELE4.1 - Registración exitosa de usuario a plan
        Dado el plan con nombre "PlanJuventud" con costo unitario $500
        Cuando envio "/registracion PlanJuventud, Miriam Perez"
        Entonces recibo "Registración exitosa"

    Escenario: TELE4.1.b - Registración fallida de usuario a plan no existente
        Dado el plan con nombre "NoExiste" con costo unitario $500
        Cuando envio "/registracion NoExiste, Miriam Perez"
        Entonces recibo "Registración fallida, verifique que el plan exista. Ej: /registracion PlanJuventud, Miriam Perez"

        Escenario: TELE16.1 - Consulta de resumen vacio
        Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud" con costo $5000
        Cuando envío "/resumen"
        Entonces recibo:
        """
        Nombre: Lionel Messi
        Plan: PlanJuventud
        Costo plan: $ 5000
        Saldo adicional: $ 0
        Total a pagar: $5000
        """
    Escenario: TELE16.2 - Consulta de resumen con gastos
        Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud" con costo $5000
        Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán"
        Cuando envío "/resumen"
        Entonces recibo:
        """
        Nombre: Lionel Messi
        Plan: PlanJuventud
        Costo plan: $ 5000
        Saldo adicional: $ 1200
        Total a pagar: $6200
        """

    @wip
    Escenario: TELE17-DIAG1.1 - Diagnostico con temperatura no sospechosa de covid
        Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
        Cuando envia "/diagnostico covid"
        Entonces recibo "Cuál es tu temperatura corporal?"
        Cuando envío 37
        Entonces recibo "Gracias por realizar el diagnóstico"
    @wip
    Escenario: TELE18-DIAG2.1 - Diagnostico con temperatura sospechosa de covid
        Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
        Cuando envia "/diagnostico covid"
        Entonces recibo "Cuál es tu temperatura corporal?"
        Cuando envío 38 o más
        Entonces recibo "Sos un caso sospechoso de COVID. Acércate a un centro médico"
        Y mi diagnostico es informado a la institución


