#language: es
#modules: database-steps, rest-steps

Característica: PETCLINIC - GET - /petclinic/api/owners
    Como: Usuario registrado
    Quiero: Recuperar la lista completa de owners
    Para: Consultar su información

# Escenarios

    @getAllOwners-1 
    Escenario: Recuperar la lista completa de usuarios
        
        # Se define el servicio REST
        Dado el servicio REST '/owners'
        # Como se trata de recuperar todos los owners, no se necesitan parámetros, por lo tanto se ejecuta la petición GET
        Cuando se realiza la búsqueda de owners
        # Se comprueba que la petición ha funcionado correctamente y que la respuesta es 200 - OK
        Entonces el código de respuesta HTTP es 200