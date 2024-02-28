#language: es
#modules: database-steps, rest-steps
@getAllOwners
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
        Y la respuesta es parcialmente el contenido del fichero 'data/getAllOwners-1-response.json'


    @getAllOwners-2
    Escenario: Recuperar la lista completa de owners - Fallo 404 por error en la URL 
        # Se define el servicio REST
        Dado el servicio REST '/owners-not-exist'
        # Recuperar lista de owners
        Cuando se realiza la búsqueda de owners
        # Comprobar respuesta de petición
        Entonces el código de respuesta HTTP es 404