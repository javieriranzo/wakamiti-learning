#language: es
#modules: database-steps, rest-steps

Característica: PETCLINIC - DELETE - /petclinic/api/owners
    Como: Usuario registrado
    Quiero: Conocer el ID de un owner
    Para: Eliminar el registro

# Escenarios 

    @deleteOwnerById-1 
    Escenario: Eliminar owner por id