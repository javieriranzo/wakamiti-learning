#language: es
#modules: database-steps, rest-steps

#language: es
#modules: database-steps, rest-steps

Característica: PETCLINIC - GET - api/owners/*/lastname/{lastName}
    Como: Usuario registrado
    Quiero: Recuperar los datos de un owner identificado por su lastName
    Para: Consultar su información

# Escenarios

    @getOwnerById-1 
    Escenario: Recuperar owner por lastName