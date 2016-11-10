; CONDICIONES DEL AEROPUERTO DE INICIO

(defrule verificar_disponibilidad_de_aeropueto_inicial
    "Si existe una ubicacion inicial, verificar si el aeropuerto esta libre"
    (ubicacion-inicial {id ?uId})
    ?ubicacion <- (ubicacion {id == ?uId} && {estado == DISPONIBLE})
    =>
    (assert (aeropuerto_inicial_disponible)))