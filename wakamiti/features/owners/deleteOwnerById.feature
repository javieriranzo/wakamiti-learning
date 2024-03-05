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
    Escenario: Eliminar owner por id indicando id correcto
        # Comprobar existencia del registro en base de datos
        Dado que los siguientes registros existen en la tabla de BBDD owners:
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

    @deleteOwnerById-2
    Escenario: Eliminar owner por id indicando id negativo
        # Identificar el registro 
        Dado el parámetro de ruta 'id' con el valor '-3'
        # Eliminar el registro
        Cuando se elimina el owner
        # En este caso la petición está devolviendo el código 404 indicando que no existe el owner con id -3. No se está controlando desde el backend que los ids tienen que ser > 0
        Entonces el código de respuesta HTTP es 404

    @deleteOwnerById-3
    Escenario: Eliminar owner por id indicando id con formato incorrecto
        # Identificar el registro
        Dado el parámetro de ruta 'id' con el valor 'abcd'
        # Eliminar el registro
        Cuando se elimina el owner
        # La petición está devolviendo el código 400. El parámetro está definido como Integer y se está proporcionando un String
        Entonces el código de respuesta HTTP es 400

    @deleteOwnerById-4
    Escenario: Eliminar owner por id indicando id no existente
        # Comprobar que el owner no existe en base de datos
        Dado que el siguiente registro no existe en la tabla de BBDD owners: 
        | id |
        | 99 |
        # Identificar el registro
        Y el parámetro de ruta 'id' con el valor '99'
        # Eliminar el registro  
        Cuando se elimina el owner
        # Comprobar la respuesta de la petición
        Entonces el código de respuesta HTTP es 404

# Escenarios outline

    @deleteOwnerById-5
    Esquema del escenario: Eliminar owner por id - Prueba con varios tipos de datos en el campo id
        # Identificar el registro
        Dado el parámetro de ruta 'id' con el valor '<idValue>'
        # Eliminar el registro
        Cuando se elimina el owner
        # Comprobar la respuesta de la petición
        Entonces el código de respuesta HTTP es <responseCode>
        Ejemplos: 
        | idValue | responseCode | 
        | -3      | 404          |
        | abcd    | 400          |
        | 99      | 404          |
