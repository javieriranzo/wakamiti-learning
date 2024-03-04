#language: es
#modules: database-steps, rest-steps
@addOwner
Característica: PETCLINIC - POST - /petclinic/api/owners
    Como: Usuario registrado
    Quiero: Completar la información obligatoria del owner 
    Para: Añadir un nuevo registro

    Antecedentes: 
        # Cuando finaliza la ejecución de los escenarios, se ejecuta la sentencia SQL
        * Al finalizar, se ejecuta el siguiente script SQL: 
        """
        DELETE FROM owners WHERE first_name = "TestName"; 
        """
        # Definir servicio REST
        Dado el servicio REST '/owners'

# Escenarios

    @addNewOwner-1 
    Escenario: Crear un nuevo owner 
        # Comprobar que el usuario no existe previamente
        Dado que el siguiente registro no existe en la tabla de BBDD owners:
        | first_name | last_name    | address        | city     | telephone |
        | TestName   | TestLastName | Test Street 27 | TestCity | 666333999 |
        # Enviar al servicio los datos de creación del nuevo usuario - Realizar la petición POST
        Cuando se crea un owner con los siguientes datos: 
        """
        {
            "address": "Test Street 27",
            "city": "TestCity",
            "firstName": "TestName",
            "id": 99,
            "lastName": "TestLastName",
            "pets": [],
            "telephone": "666333999"
        }
        """
        # Comprobar que la petición ha funcionado correctamente. La respuesta es 201 en este caso porque sigue los estándares
        Entonces el código de respuesta HTTP es 201
        # Comprobar que el owner creado, existe como nuevo registro en la base de datos
        Y los siguientes registros existen en la tabla de BBDD owners:
        | first_name | last_name    | address        | city     | telephone |
        | TestName   | TestLastName | Test Street 27 | TestCity | 666333999 |
