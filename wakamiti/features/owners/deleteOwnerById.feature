#language: es
#modules: database-steps, rest-steps
@deleteOwnerById
Característica: PETCLINIC - DELETE - /petclinic/api/owners
    Como: Usuario registrado
    Quiero: Conocer el ID de un owner
    Para: Eliminar el registro

    Antecedentes:
        # Cuando finaliza la ejecución de los escenarios, se ejecuta la sentencia SQL
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

    @deleteOwnerById-1 
    Escenario: Eliminar owner por id
        # Comprobar existencia del registro en base de datos
        Y que los siguientes registros existen en la tabla de BBDD owners:
        | id | first_name | last_name    | address     | city     | telephone |
        | 11 | TestName   | TestLastName | 99 Test St. | TestCity | 666000444 |
        # Eliminar registro
        Y el parámetro de ruta 'id' con el valor '11'
        # Realizar la petición DELETE
        Cuando se elimina el owner
        # Comprobar respuesta de la petición
        Entonces el código de respuesta HTTP es 204
        # Comprobar en base de datos que el registro no existe
        Y que los siguientes registros no existen en la tabla de BBDD owners:
        | id | first_name | last_name    | address     | city     | telephone |
        | 11 | TestName   | TestLastName | 99 Test St. | TestCity | 666000444 |


