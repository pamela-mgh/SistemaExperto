; ######### TEMPLATES #########

; Mapa

(deftemplate ruta
    (slot estado (default DISPONIBLE))
    (slot inicio)
    (slot fin))

(deftemplate ubicacion
    (slot id)
    (slot nombre (type STRING))
    (slot estado (default DISPONIBLE))
    (slot visitado (default FALSE)))


; Carga

(deftemplate suministros
    "Tipo de carga personal militar seleccionada"
    (slot peso (type INTEGER)))

(deftemplate personal_militar
    "Tipo de carga personal militar seleccionada"
    (slot cantidad (type INTEGER)))


; Ubicacion de inicio, destino y actual

(deftemplate ubicacion_inicial
    "La ubicacion inicial del vuelo"
    (slot id))

(deftemplate ubicacion_destino
    "La ubicacion de destino del vuelo"
    (slot id))

(deftemplate ubicacion_actual
    "La ubicacion actual en el razonamiento"
    (slot id))

(deftemplate plan
    (multislot camino))

; ######### FACTS #########

; Ubicaciones

(assert (ubicacion (id bm_la_paz) (nombre "Base Militar La Paz")))
(assert (ubicacion (id bm_cbba) (nombre "Base Militar Cochabamba") (estado NO_DISPONIBLE)))
(assert (ubicacion (id bm_santa_cruz) (nombre "Base Militar Santa Cruz")))

; Rutas

(assert (ruta (inicio bm_santa_cruz) (fin bm_la_paz)))
(assert (ruta (inicio bm_la_paz) (fin bm_santa_cruz) (estado COMPROMETIDO)))

(assert (ruta (inicio bm_santa_cruz) (fin bm_cbba)))
(assert (ruta (inicio bm_cbba) (fin bm_santa_cruz) ))

(assert (ruta (inicio bm_la_paz) (fin bm_cbba)))
(assert (ruta (inicio bm_cbba) (fin bm_la_paz)))

(bind ?plan (assert (plan)))

; ######### REGLAS #########

; Verifica si el aeropuerto inicial no esta disponible

(defrule verificar_disponibilidad_de_aeropueto_inicial
    (ubicacion_inicial (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE})
    =>
    (assert (aeropuerto_inicial_no_disponible)))


; Verifica si el aeropuerto destino no esta disponible

(defrule verificar_disponibilidad_de_aeropueto_destino
    (ubicacion_destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE})
    =>
    (assert (aeropuerto_destino_no_disponible)))


; Establecer la ubicacion inicial como actual

(defrule ubicacion_actual_inicial
    (ubicacion_inicial (id ?uId))
    ?u <- (ubicacion {id == ?uId && visitado == FALSE})
    =>
    (modify ?u (visitado TRUE))
    (assert (ubicacion_actual (id ?uId)))
    (modify ?plan (camino ?plan.camino ?uId))
    (printout t "la ubicacion inicial y actual es: " ?uId crlf))


; Establecer la siguiente ubicacion actual

(defrule siguiente_ubicacion
    ?ubicacion_actual <- (ubicacion_actual (id ?uId))
    (ruta {inicio == ?uId && estado == DISPONIBLE} (inicio ?inicioId) (fin ?finId))
    ?inicio <- (ubicacion {id == ?inicioId})
    ?fin <- (ubicacion {id == ?finId && visitado == FALSE})
    =>
    (modify ?fin (visitado TRUE))
    (modify ?ubicacion_actual (id ?finId))
    (modify ?plan (camino ?plan.camino ?finId))
    (printout t "la ubicacion actual es: " ?ubicacion_actual.id crlf))
