
; REGLAS

(defrule verificar_disponibilidad_de_aeropueto_inicial
    "Si existe una ubicacion inicial, verificar si el aeropuerto esta libre"
    (ubicacion_inicial (id ?uId))
    ?ubicacion <- (ubicacion {id == ?uId && estado == DISPONIBLE})
    =>
    (assert (aeropuerto_inicial_disponible)))

(defrule verificar_disponibilidad_de_aeropueto_inicial
    "Si existe una ubicacion inicial, verificar si el aeropuerto esta libre"
    (ubicacion_inicial (id ?uId))
    ?ubicacion <- (ubicacion {id == ?uId && estado == NO_DISPONIBLE})
    =>
    (assert (aeropuerto_inicial_no_disponible)))

(defrule verificar_ruta
    "Si la ruta esta comprometida por enemigos, entonces cambiar de destino"
    ?ruta <- (ruta {estado == COMPROMETIDO})
    =>
    (assert (cambiar_de_destino)))




