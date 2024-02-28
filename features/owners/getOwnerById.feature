#language: es
#modules: database-steps, rest-steps

Característica: PETCLINIC - GET - /petclinic/api/owners/{id}
    Como: Usuario registrado
    Quiero: Recuperar los datos de un owner identificado por su id
    Para: Consultar su información

# Escenarios

    @getOwnerById-1 
    Escenario: Recuperar owner por id
