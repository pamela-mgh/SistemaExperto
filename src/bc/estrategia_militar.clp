; ######### TEMPLATES #########

; MAPA

(deftemplate ruta
    (slot estado (default DISPONIBLE))
    (slot inicio)
    (slot fin))

(deftemplate ubicacion
    (slot id)
    (slot nombre (type STRING))
    (slot estado (default DISPONIBLE)))

; CARGA

(deftemplate suministros
    "Tipo de carga personal militar seleccionada"
    (slot peso (type INTEGER)))

(deftemplate personal_militar
    "Tipo de carga personal militar seleccionada"
    (slot cantidad (type INTEGER)))


; UBICACION DE INICO Y UBICACION DE DESTINO

(deftemplate ubicacion_inicial
    "La ubicacion inicial del vuelo"
    (slot id))

(deftemplate ubicacion_destino
    "La ubicacion de destino del vuelo"
    (slot id))


; ######### FACTS #########

; UBICACIONES

(assert (ubicacion (id bm_la_paz) (nombre "Base Militar La Paz")))
(assert (ubicacion (id bm_cbba) (nombre "Base Militar Cochabamba") (estado NO_DISPONIBLE)))
(assert (ubicacion (id bm_santa_cruz) (nombre "Base Militar Santa Cruz")))

; RUTAS

(assert (ruta (inicio bm_santa_cruz) (fin bm_la_paz)))
(assert (ruta (inicio bm_la_paz) (fin bm_santa_cruz) (estado COMPROMETIDO)))

(assert (ruta (inicio bm_santa_cruz) (fin bm_cbba)))
(assert (ruta (inicio bm_cbba) (fin bm_santa_cruz) ))

(assert (ruta (inicio bm_la_paz) (fin bm_cbba)))
(assert (ruta (inicio bm_cbba) (fin bm_la_paz)))

; ######### REGLAS #########

(defrule verificar_disponibilidad_de_aeropueto_inicial
    "Si existe una ubicacion inicial, verificar si el aeropuerto esta libre"
    (ubicacion_inicial (id ?uId))
    ?ubicacion <- (ubicacion {id == ?uId && estado == NO_DISPONIBLE})
    =>
    (assert (aeropuerto_inicial_no_disponible)))