; ********************
; PLANTILLAS DE HECHOS
; ********************

(deftemplate ubicacion
    "Una ubicacion en el mapa de planificacion"
    (slot id)
    (slot nombre (type STRING))
    (slot estado (default DISPONIBLE)) ; DISPONIBLE | NO_DISPONIBLE
    (slot visitado (default FALSE))
    (slot razon (type STRING)))

(deftemplate ruta
    "Una ruta une dos ubicaciones"
    (slot estado (default DISPONIBLE))
    (slot inicio) ;<inicio> es la ubicacion donde empieza la ruta
    (slot fin) ;<fin> es la ubicacion donde termina la ruta
    (slot distancia))

(deftemplate carga
    "La carga que se desea transportar"
    (slot tipo) ;<tipo> puede ser ( personal-militar | suministros | vehiculos )
    (slot cantidad (type INTEGER)))

(deftemplate ubicacion-inicial
    "La ubicacion inicial del vuelo"
    (slot id)) ;<id> es el identificador de la ubicacion inicio

(deftemplate ubicacion-destino
    "La ubicacion de destino del vuelo"
    (slot id)) ;<id> es el identificador de la ubicacion destino

(deftemplate transporte
    (slot id) ;<id> es el identificador del transporte
    (slot tipo) ;<tipo> puede ser ( avion | helicoptero )
    (slot capacidad (type INTEGER));la capacidad maxima de carga
    (slot combustible (type INTEGER))
    (slot ubicacion (default base-militar)))

(deftemplate transporte-disponible
    (slot id))

; ********************
; DEFINICION DE HECHOS
; ********************

(deffacts escenario "Definicion del escenario"
    (ubicacion (id bm_la_paz) (nombre "Base Militar La Paz"))
	(ubicacion (id bm_cbba) (nombre "Base Militar Cochabamba") (estado NO_DISPONIBLE) (razon "conflicto armado"))
	(ubicacion (id bm_santa_cruz) (nombre "Base Militar Santa Cruz"))
	(ubicacion (id bm_sucre) (nombre "Base Militar Sucre"))
    (ubicacion (id bm_potosi) (nombre "Base Militar Potosi"))
    (ruta (inicio bm_santa_cruz) (fin bm_la_paz))
	(ruta (inicio bm_la_paz) (fin bm_santa_cruz) (estado COMPROMETIDO))
	(ruta (inicio bm_santa_cruz) (fin bm_cbba))
	(ruta (inicio bm_cbba) (fin bm_santa_cruz))
	(ruta (inicio bm_la_paz) (fin bm_cbba))
	(ruta (inicio bm_cbba) (fin bm_la_paz))
    (ruta (inicio bm_sucre) (fin bm_potosi) (estado COMPROMETIDO))
    (ruta (inicio bm_potosi) (fin bm_sucre))
	(transporte (id A0X-1) (tipo avion) (capacidad 500) (combustible 100) (ubicacion bm_la_paz))
	(transporte (id A0X-3) (tipo avion) (capacidad 200) (combustible 100) (ubicacion bm_cbba))
	(transporte (id A0X-5) (tipo helicoptero) (capacidad 100) (combustible 80) (ubicacion bm_santa_cruz)))

; ******
; REGLAS
; ******

; REGLAS DE TRANSPORTE

(defrule verificacion-disponibilidad-transporte
    (carga (cantidad ?cantidad))
    (ubicacion-inicial (id ?ubicacionId))
    ?transporte <- (transporte {ubicacion == ?ubicacionId && capacidad >= ?cantidad} (id ?transporteId))
    =>
    (printout t "Existe transporte disponible" crlf)
    (assert (transporte-disponible (id ?transporteId))))

; REGLAS DE TIPO DE AVION
(defrule tipo-avion
    (carga (tipo ?tipo))
    (transporte-disponible (id ?transporteId))
    (transporte {id == ?transporteId && tipo == avion} (capacidad ?capacidad))
    =>
    (printout t "El avion que debe utilizar es el " ?transporteId "con capacidad maxima para " ?tipo " de " ?capacidad  crlf)
    (assert (tipo-transporte avion)))


; REGLAS DE DESCARGA

(defrule personal-militar-desciende-en-paracaidas
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "conflicto armado"})
    (transporte-disponible (id ?transporteId))
    (transporte {id == ?transporteId && tipo == avion})
    (carga (tipo personal-militar))
    =>
    (printout t "Ordenar al personal militar que descienda en paracaidas" crlf)
    (assert (personal-militar-desciende-en-paracaidas)))

(defrule soltar-carga-en-paracaidas
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "conflicto armado"})
    (transporte-disponible (id ?transporteId))
    (transporte {id == ?transporteId && tipo == avion})
    (carga (tipo suministros))
    =>
    (printout t "Soltar carga en paracaidas" crlf)
    (assert (soltar-carga-en-paracaidas)))

(defrule aterrizar-en-ubicacion-cercana
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "conflicto armado"})
    (transporte-disponible (id ?transporteId))
    (transporte {id == ?transporteId && tipo == helicoptero})
    =>
    (printout t "Aterrizar en punto cercano" crlf)
    (assert (aterrizar-en-punto-cercano)))

(defrule aterrizar-normalmente-avion
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == DISPONIBLE})
    (transporte-disponible (id ?transporteId))
    (transporte {id == ?transporteId && tipo == avion})
    =>
    (printout t "El destino esta disponbible para que el avion aterrize" crlf)
    (assert (avion-puede-aterrizar-normalmente)))

(defrule aterrizar-normalmente-helicoptero
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == DISPONIBLE})
    (transporte-disponible (id ?transporteId))
    (transporte {id == ?transporteId && tipo == helicoptero})
    =>
    (printout t "El destino esta disponbible para que el helicoptero aterrize" crlf)
    (assert (helicoptero-puede-aterrizar-normalmente)))

; REGLAS DE DISPONIBILIDAD DE AEROPUERTO

(defrule aeropuerto-inicial-no-disponible
    "Verifica si el aeropuerto inicial no esta disponible"
    (ubicacion-inicial (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE} (razon ?razon))
    =>
    (printout t "Aeropuerto inicial no disponible para despegar por " ?razon "." crlf))

(defrule aeropuerto-destino-no-disponible
    "Verifica si el aeropuerto destino no esta disponible"
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE} (razon ?razon))
    =>
    (printout t "Aeropuerto destino no disponible para aterrizar por " ?razon "." crlf))
(reset)