#language: es
#modules: database-steps, rest-steps

#language: es
#modules: database-steps, rest-steps

Característica: PETCLINIC - GET - api/owners/*/lastname/{lastName}
    Como: Usuario registrado
    Quiero: Recuperar los datos de un owner identificado por su lastName
    Para: Consultar su información

    Antecedentes:
        Dado el servicio REST 'owners/*/lastname/{lastName}'

# Escenarios

    @getOwnerByLastName-1 
    Escenario: Recuperar owner por lastName
         # Se indica el ID en la ruta de la petición
        Dado el parámetro de ruta 'lastName' con el valor 'Franklin'
        # Realiza la petición GET
        Cuando se realiza la búsqueda de owner por id
        # Comprobar la respuesta de la petición
        Entonces el código de respuesta HTTP es 200
        # Evaluar respuesta de la petición almacenada en un fichero .json
        Y la respuesta es parcialmente el contenido del fichero 'data/getOwnerByLastName-1-response.json'
        # Evaluar campos de la respuesta (json) individualmente
        Y el entero del fragmento de la respuesta '[0].id' es 1
        Y el texto del fragmento de la respuesta '[0].firstName' es 'George'
        Y el texto del fragmento de la respuesta '[0].lastName' es 'Franklin'
        Y el texto del fragmento de la respuesta '[0].address' es '110 W. Liberty St.'
        Y el texto del fragmento de la respuesta '[0].city' es 'Madison'
        Y el texto del fragmento de la respuesta '[0].telephone' es '6085551023'
        Y el entero del fragmento de la respuesta '[0].pets[0].id' es 1
        Y el texto del fragmento de la respuesta '[0].pets[0].name' es 'Leo'
        Y el texto del fragmento de la respuesta '[0].pets[0].birthDate' es '2000/09/07'
        Y el entero del fragmento de la respuesta '[0].pets[0].type.id' es 1
        Y el texto del fragmento de la respuesta '[0].pets[0].type.name' es 'cat'
        Y el entero del fragmento de la respuesta '[0].pets[0].owner' es 1

    @getOwnerByLastName-2
    Escenario: Recuperar owner creado vía base de datos por id
        # Borrar los IDs superiores a 10 para en este caso se eliminen los posibles registros creados previamente
        Dado que se ejecuta el siguiente script SQL: 
        """
        DELETE FROM owners WHERE id > 10; 
        """
        # Crear nuevo registro vía base de datos
        Y que se ejecuta el siguiente script SQL: 
        """
        INSERT INTO petclinic.owners (id, first_name, last_name, address, city, telephone) VALUES('11', 'TestName', 'TestLastName', '99 Test St.', 'TestCity', '666000444');
        """
        # Se indica el ID en la ruta de la petición
        Y el parámetro de ruta 'lastName' con el valor 'TestLastName'
        # Realizar la petición GET
        Cuando se realiza la búsqueda de owner por id
        # Comprobar la respuesta de la petición
        Entonces el código de respuesta HTTP es 200
        # Evaluar respuesta de la petición almacenada en un fichero .json
        Y la respuesta es parcialmente el contenido del fichero 'data/getOwnerByLastName-2-response.json'
        # Evaluar campos de la respuesta (json) individualmente
        Y el texto del fragmento de la respuesta '[0].firstName' es 'TestName'
        Y el texto del fragmento de la respuesta '[0].lastName' es 'TestLastName'
        Y el texto del fragmento de la respuesta '[0].address' es '99 Test St.'
        Y el texto del fragmento de la respuesta '[0].city' es 'TestCity'
        Y el texto del fragmento de la respuesta '[0].telephone' es '666000444'