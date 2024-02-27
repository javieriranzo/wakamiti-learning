#language: es
#modules: database-steps, rest-steps

Característica: PETCLINIC - POST - /petclinic/api/owners
    Como: Usuario registrado
    Quiero: Completar la información obligatoria del owner 
    Para: Añadir un nuevo registro

     Antecedentes: 
        Dado el servicio REST '/owners'

# Escenarios

    @addNewOwner-1 
    Escenario: Crear un nuevo owner

        # Se define el servicio REST
        Dado el servicio REST '/owners'
        # Se envía al servicio los datos de creación del nuevo usuario
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
        # Se comprueba que la petición ha funcionado correctamente y que la respuesta es 200 - OK
        Entonces el código de respuesta HTTP es 200
        # Se comprueba que el owner creado, existe como nuevo registro en la base de datos
        Y los siguientes registros existen en la tabla de BBDD:
        | first_name | last_name    | address        | city     | telephone |
        | TestName   | TestLastName | Test Street 27 | TestCity | 666333999 |
        # Se elimina el registro creado. ¿Por qué se elimina? Se hace como método de buenas prácticas. Con las pruebas se debe afectar lo más mínimo el modelo de datos y no crear muchos registros de test
        Y se ejecuta el siguiente script SQL:
        """
        DELETE FROM owners WHERE firts_name = "TestName"; 
        """
        # Se comprueba que el registro creado no existe en la base de datos
        Y el siguiente registro no existe en la tabla de BBDD:
        | first_name | last_name    | address        | city     | telephone |
        | TestName   | TestLastName | Test Street 27 | TestCity | 666333999 |
