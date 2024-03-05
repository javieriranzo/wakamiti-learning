#language: es
#modules: database-steps, rest-steps
@getAllOwners
Característica: PETCLINIC - RECUPERAR LISTA COMPLETA DE OWNERS - GET - /petclinic/api/owners
    Como: Usuario registrado
    Quiero: Recuperar la lista completa de owners
    Para: Consultar su información

    Antecedentes:
        Dado el servicio REST '/owners'

# Escenarios

    @getAllOwners-1 
    Escenario: Recuperar la lista completa de usuarios
        # Como se trata de recuperar todos los owners, no se necesitan parámetros, por lo tanto se ejecuta la petición GET
        Cuando se realiza la búsqueda de owners
        # Se comprueba que la petición ha funcionado correctamente y que la respuesta es 200 - OK
        Entonces el código de respuesta HTTP es 200
        # Evaluar respuesta de la petición almacenada en un fichero .json
        Y la respuesta es parcialmente el contenido del fichero 'data/getAllOwners-1-response.json'