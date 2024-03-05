#language: es
#modules: database-steps, rest-steps

Característica: PETCLINIC - ACTUALIZAR OWNER - PUT - /petclinic/api/owners
    Como: Usuario registrado
    Quiero: Identificar a un owner por su id y modificar sus datos
    Para: Actualizar su información

    Antecedentes:
        * Al finalizar, se ejecuta el siguiente script SQL: 
        """
        DELETE FROM owners WHERE id > 10; 
        """
        # Definir servicio REST
        Dado el servicio REST '/owners/{id}'
        # Insertar nuevo registro en base de datos. En caso de no tener base de datos dedicada no se deben modificar / eliminar registros existentes (por buenas prácticas)
        Y que se ejecuta el siguiente script SQL: 
        """
        INSERT INTO petclinic.owners (id, first_name, last_name, address, city, telephone) VALUES('11', 'TestName', 'TestLastName', '99 Test St.', 'TestCity', '666000444');
        """

# Escenarios

    @updateOwner-1 
    Escenario: Actualizar información de un owner
        # Comprobar existencia del registro en base de datos
        Dado que los siguientes registros existen en la tabla de BBDD owners:
        | id | first_name | last_name    | address     | city     | telephone |
        | 11 | TestName   | TestLastName | 99 Test St. | TestCity | 666000444 |
        Y el parámetro de ruta 'id' con el valor '11'
        Cuando se reemplaza el usuario con los siguientes datos:
        """
        {
            "address": "address_modified",
            "city": "city_modified",
            "firstName": "firstName_modified",
            "id": 0,
            "lastName": "lastName_modified",
            "pets": [],
            "telephone": "999333000"
        }
        """
        # Comprobar respuesta de la petición
        Entonces el código de respuesta HTTP es 204
        Y los siguientes registros existen en la tabla de BBDD owners:
        | id | first_name         | last_name         | address          | city          | telephone |
        | 11 | firstName_modified | lastName_modified | address_modified | city_modified | 999333000 |