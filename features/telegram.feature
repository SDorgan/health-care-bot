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
  @wip
  Escenario: TELE2 - Consulta de un plan existente
        Dado que existe el plan "PlanJuventud"
        Cuando envio "/plan PlanJuventud"
        Entonces recibo la información del "PlanJuventud"
  @wip
  Escenario: TELE3 - Consulta de plan PlanJuventud cuando no está cargado
      Cuando envío "/plan PlanJuventud"
      Entonces recibo "El plan ingresado no existe"

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

  Escenario: TELE5 - Registración fallida de afiliado de 28 años, sin hijos, sin conyuge a plan juventud
        Dado el plan con nombre "PlanJuventud" con costo unitario $500
        Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
        Cuando envio "/registracion PlanJuventud, Miriam Perez, 28"
        Entonces recibo "Registración fallida: supera el límite máximo de edad"

  Escenario: TELE6 - Registración fallida de afiliado de 8 años, sin hijos, sin conyuge a plan juventud
      Dado el plan con nombre "PlanJuventud" con costo unitario $500
      Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
      Cuando envio "/registracion PlanJuventud, Miriam Perez, 8"
      Entonces recibo "Registración fallida: no alcanza el límite mínimo de edad"

  Escenario: TELE10 - Registración exitosa de afiliado de 28 años, con hijos, sin conyuge a plan familiar
      Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
      Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
      Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28, hijos-1"
      Entonces recibo "Registración exitosa"

  Escenario: TELE11 - Registración exitosa de afiliado de 28 años, con hijos, con conyuge a plan familiar
      Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
      Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
      Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28, hijos-1, conyuge"
      Entonces recibo "Registración exitosa"
  
  Escenario: TELE17 - Registración exitosa de afiliado de 28 años, sin hijos, con conyuge a plan pareja
      Dado el plan con nombre "PlanPareja" con costo unitario $1800
      Y restricciones edad min 15, edad max 99, hijos max 0, requiere conyuge "si"
      Cuando envio "/registracion PlanPareja, Miriam Perez, 28, conyuge"
      Entonces recibo "Registración exitosa"

  Escenario: TELE7 - Registración fallida de afiliado de 18 años, con hijos, sin conyuge a plan juventud
        Dado el plan con nombre "PlanJuventud" con costo unitario $500
        Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
        Cuando envio "/registracion PlanJuventud, Miriam Perez, 18, hijos-1"
        Entonces recibo "Registración fallida: este plan no admite hijos"

  Escenario: TELE8 - Registración fallida de afiliado de 18 años, sin hijos, con conyuge a plan juventud
      Dado el plan con nombre "PlanJuventud" con costo unitario $500
      Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
      Cuando envio "/registracion PlanJuventud, Miriam Perez, 18, conyuge"
      Entonces recibo "Registración fallida: este plan no admite conyuge"

  Escenario: TELE12 - Registración fallida de afiliado de 28 años, sin hijos, sin conyuge a plan familiar
      Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
      Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
      Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28"
      Entonces recibo "Registración fallida: este plan requiere tener hijos"

  Escenario: TELE13 - Registración fallida de afiliado de 28 años, sin hijos, con conyuge a plan familiar
      Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
      Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
      Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28, conyuge"
      Entonces recibo "Registración fallida: este plan requiere tener hijos"

  Escenario: TELE14 - Consulta exitosa de Centro por prestación
      Dado el centro con nombre "Hospital Alemán" con coordenadas "(-37.30, -58.97)"
      Y el centro tiene la prestación "Traumatología"
      Cuando envio "/consulta traumatologia"
      Entonces recibo "Hospital Alemán - Coordenadas (-37.30, -58.97)"

  Escenario: TELE15 - Consulta sin respuestas de Centro por prestación
      Dado el centro con nombre "Hospital Alemán" con coordenadas "(-37.30, -58.97)"
      Y el centro tiene la prestación "Traumatología"
      Cuando envio "/consulta cirujia"
      Entonces recibo "No hay hospitales disponibles"


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

  Escenario: TELE18 - Registración fallida de afiliado de 28 años, con hijos, con conyuge a plan pareja
      Dado el plan con nombre "PlanPareja" con costo unitario $1800
      Y restricciones edad min 15, edad max 99, hijos max 0, requiere conyuge "si"
      Cuando envio "/registracion PlanPareja, Miriam Perez, 28, hijos-1, conyuge"
      Entonces recibo "Registración fallida: este plan no admite hijos"

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

  @mvp
  Escenario: TELE18-DIAG3 - Diagnostico covid tira error por persona no afiliada
      Dado que el usuario "locomalo" no está afiliado
      Cuando envia "/diagnostico covid"
      Entonces recibe "Disculple, esta funcionalidad solo está disponible para afiliados."

  Escenario: TELE19 - Registración fallida de afiliado de 28 años, con hijos, sin conyuge a plan pareja
      Dado el plan con nombre "PlanPareja" con costo unitario $1800
      Y restricciones edad min 15, edad max 99, hijos max 0, requiere conyuge "si"
      Cuando envio "/registracion PlanPareja, Miriam Perez, 28, hijos-1"
      Entonces recibo "Registración fallida: este plan no admite hijos"

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

