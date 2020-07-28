# language: es

@manual @mvp
Característica: Flujo completo via telegram

  """
  Estos escenarios son para ejecución manual de todo el flujo y por ello no son gherkin estricto
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
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Cuando envio "/registracion NoExiste, Miriam Perez"
    Entonces recibo "Registración fallida, verifique que el plan exista. Ej: /registracion PlanJuventud, Miriam Perez"
    
  Escenario: TELE4 - Registración exitosa de afiliado de 18 años, sin hijos, sin conyuge a plan juventud
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
    Cuando envio "/registracion PlanJuventud, Miriam Perez, 18"
    Entonces recibo "Registración exitosa"

  Escenario: TELE9 - Registración exitosa de afiliado de 28 años, sin hijos, sin conyuge a plan 310
      Dado el plan con nombre "Plan310" con costo unitario $1000
      Y restricciones edad min 21, edad max 99, hijos max 0, admite conyuge "no"
      Cuando envio "/registracion Plan310, Miriam Perez, 28"
      Entonces recibo "Registración exitosa"

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

  Escenario: TELE16.3 - Consulta completa de resumen
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud" con costo $5000
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 01/01/2020
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 10/01/2020
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 20/01/2020
    Cuando envío "/resumen"
    Entonces recibo:
    """
    Nombre: Lionel Messi
    Plan: PlanJuventud
    Costo plan: $ 5000
    Saldo adicional: $ 1200
    Total a pagar: $6200

    Fecha      | Concepto                        | Costo
    01/01/2020 | Traumatología - Hospital Alemán | $0
    10/01/2020 | Traumatología - Hospital Alemán | $0
    20/01/2020 | Traumatología - Hospital Alemán | $1200
    """

  Escenario: TELE16.3 - Consulta de resumen no afiliado
    Dado un usuario que no se afilió a ningún plan
    Cuando envío "/resumen"
    Entonces recibo un error explicando que no estoy afiliado

  Escenario: TELE17-DIAG1.1 - Diagnostico con temperatura no sospechosa de covid
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
    Cuando envia "/diagnostico covid"
    Entonces recibo "Cuál es tu temperatura corporal?" con opciones
    """
    - 35 o menos
    - 36
    - 37
    - 38 o más
    """
    Cuando elijo "37"
    Entonces recibo "Gracias por realizar el diagnóstico"

  Escenario: TELE18-DIAG2.1 - Diagnostico con temperatura sospechosa de covid
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
    Cuando envia "/diagnostico covid"
    Entonces recibo "Cuál es tu temperatura corporal?" con opciones
    """
    - 35 o menos
    - 36
    - 37
    - 38 o más
    """
    Cuando elijo "38 o más"
    Entonces recibo "Sos un caso sospechoso de COVID. Acércate a un centro médico"
    Y mi diagnostico es informado a la institución

  Escenario: TELE17-DIAG1.2 - Diagnostico sin covid
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
    Cuando envia "/diagnostico covid"
    Entonces recibo "Cuál es tu temperatura corporal?" con opciones
    """
    - 35 o menos
    - 36
    - 37
    - 38 o más
    """
    Cuando elijo "37"
    Entonces recibo "Percibiste una marcada pérdida de olfato de manera repentina?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "No"
    Entonces recibo "Percibiste una marcada pérdida del gusto de manera repentina?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "No"
    Entonces recibo "Tenés tos?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "No"
    Entonces recibo "Tenés dolor de garganta?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "No"
    Entonces recibo "Tenés dificultad respiratoria?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "No"
    Entonces recibo en formato de opciones
    """
    - Convivo con alguien que tiene COVID
    - En los últimos 14 días estuve cerca de alguien con COVID
    - Estoy embarazada
    - Tengo/tuve cancer
    - Tengo diabetes
    - Tengo enfermedad hepática
    - Tengo enfermedad renal crónica
    - Tengo alguna enfermedad respiratoria
    - Tengo alguna enfermedad cardiológica
    - Ninguna
    """
    Y elijo "Ninguna"
    Entonces recibo "Gracias por realizar el diagnóstico"

  Escenario: TELE18-DIAG2.2 - Diagnostico sospechoso de covid
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
    Cuando envia "/diagnostico covid
    Entonces recibo "Cuál es tu temperatura corporal?" con opciones
    """
    - 35 o menos
    - 36
    - 37
    - 38 o más
    """
    Cuando elijo 37
    Entonces recibo "Percibiste una marcada pérdida de olfato de manera repentina?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "No"
    Entonces recibo "Percibiste una marcada pérdida del gusto de manera repentina?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "No"
    Entonces recibo "Tenés tos?" con opciones
    """
    - Sí
    - No
    """
    Y elijo "Si"
    Entonces recibo "Sos un caso sospechoso de COVID. Acercate a un centro médico"
    Y mi diagnostico es informado a la institución

  Escenario: TELE20 - Consulta de resumen con medicamentos
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud" con costo $5000
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 01/01/2020
    Y que se registró una compra de medicamentos por $1000 el dia 20/01/2020
    Y que se registró una compra de medicamentos por $1000 el dia 21/01/2020
    Cuando envío "/resumen"
    Entonces recibo:
    """
    Nombre: Lionel Messi
    Plan: PlanJuventud
    Costo plan: $ 5000
    Saldo adicional: $1600
    Total a pagar: $6600

    Fecha      | Concepto                        | Costo
    01/01/2020 | Traumatología - Hospital Alemán | $0
    20/01/2020 | Medicamentos                    | $800
    21/01/2020 | Medicamentos                    | $800
    """

