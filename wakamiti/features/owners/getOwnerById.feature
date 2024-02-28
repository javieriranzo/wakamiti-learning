#language: es
#modules: database-steps, rest-steps
@getOwnerById
Característica: PETCLINIC - GET - /petclinic/api/owners/{id}
    Como: Usuario registrado
    Quiero: Recuperar los datos de un owner identificado por su id
    Para: Consultar su información

    Antecedentes:
        Dado el servicio REST '/owners/{id}'

# Escenarios

    @getOwnerById-1 
    Escenario: Recuperar owner por id
        Dado el parámetro de ruta 'id' con el valor '1'
        Cuando se realiza la búsqueda de owner por id
        Entonces el código de respuesta HTTP es 200

    @getOwnerById-2
    Escenario: Recuperar owner por id
        Dado el parámetro de ruta 'id' con el valor '2'
        Cuando se realiza la búsqueda de owner por id
        Entonces el código de respuesta HTTP es 200

    @getOwnerById-3 
    Escenario: Recuperar owner por id
        Dado el parámetro de ruta 'id' con el valor '3'
        Cuando se realiza la búsqueda de owner por id
        Entonces el código de respuesta HTTP es 200
