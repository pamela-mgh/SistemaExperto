; ******************
; VARIABLES GLOBALES
; ******************

(defglobal ?*kmporltAVION* = 100)
(defglobal ?*kmporltHELICPOTERO* = 50)

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
    (slot distancia (type INTEGER)))

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
    (slot id)
    (slot tipo)
    (slot capacidad)
    (slot ubicacion)
    (slot combustible)
    (slot distancia-maxima))

(deftemplate accion
    (slot texto (type STRING)))

(deftemplate aeropuerto-inicial-no-disponible
    (slot razon (type STRING)))

; ********************
; DEFINICION DE HECHOS
; ********************

(deffacts escenario "Definicion del escenario"
    (ubicacion (id bm_la_paz) (nombre "Base Militar La Paz"))
	(ubicacion (id bm_cbba) (nombre "Base Militar Cochabamba") (estado NO_DISPONIBLE) (razon "conflicto armado"))
	(ubicacion (id bm_santa_cruz) (nombre "Base Militar Santa Cruz"))
	(ubicacion (id bm_sucre) (nombre "Base Militar Sucre"))
    (ubicacion (id bm_potosi) (nombre "Base Militar Potosi") (estado NO_DISPONIBLE) (razon "causas naturales"))
    (ruta (inicio bm_santa_cruz) (fin bm_la_paz) (distancia 4506))
	(ruta (inicio bm_santa_cruz) (fin bm_cbba) (distancia 4506))
    (ruta (inicio bm_santa_cruz) (fin bm_sucre) (distancia 806))
    (ruta (inicio bm_santa_cruz) (fin bm_potosi) (distancia 468))
    (ruta (inicio bm_la_paz) (fin bm_santa_cruz) (distancia 5516) (estado COMPROMETIDO))
    (ruta (inicio bm_la_paz) (fin bm_cbba) (distancia 3438))
    (ruta (inicio bm_la_paz) (fin bm_sucre) (distancia 436))
    (ruta (inicio bm_la_paz) (fin bm_potosi) (distancia 1416))
	(ruta (inicio bm_cbba) (fin bm_santa_cruz) (distancia 426))
	(ruta (inicio bm_cbba) (fin bm_la_paz) (distancia 2406))
    (ruta (inicio bm_cbba) (fin bm_sucre) (distancia 3883))
    (ruta (inicio bm_cbba) (fin bm_potosi) (distancia 8848))
    (ruta (inicio bm_sucre) (fin bm_potosi) (distancia 348) (estado COMPROMETIDO))
    (ruta (inicio bm_sucre) (fin bm_la_paz) (distancia 1684))
    (ruta (inicio bm_sucre) (fin bm_cbba) (distancia 3538))
    (ruta (inicio bm_sucre) (fin bm_santa_cruz) (distancia 3184))
    (ruta (inicio bm_potosi) (fin bm_sucre) (distancia 8433))
    (ruta (inicio bm_potosi) (fin bm_la_paz) (distancia 572))
    (ruta (inicio bm_potosi) (fin bm_cbba) (distancia 9983))
    (ruta (inicio bm_potosi) (fin bm_santa_cruz) (distancia 5656))
	(transporte (id A0X-1) (tipo avion) (capacidad 500) (combustible 15) (ubicacion bm_la_paz))
	(transporte (id A0X-3) (tipo avion) (capacidad 200) (combustible 6) (ubicacion bm_cbba))
	(transporte (id H0X-2) (tipo helicoptero) (capacidad 100) (combustible 15) (ubicacion bm_santa_cruz))
	(transporte (id A0X-2) (tipo avion) (capacidad 200) (combustible 12) (ubicacion bm_sucre))
	(transporte (id H0X-4) (tipo helicoptero) (capacidad 100) (combustible 10) (ubicacion bm_potosi)))

; ***********************
; DEFINICION DE FUNCIONES
; ***********************

(deffunction MaxDistancia (?combustible)
      (* ?*kmporltAVION* ?combustible))

; ******
; REGLAS
; ******

; REGLAS DE TRANSPORTE

(defrule si-capacidad-transporte-es-mayor-o-igual-a-cantidad-carga-entonces-transporte-disponible
    (aeropuerto-inicial-disponible)
    (carga (cantidad ?cantidad))
    (ubicacion-inicial (id ?ubicacionId))
    ?transporte <- (transporte {ubicacion == ?ubicacionId && capacidad >= ?cantidad} (id ?transporteId) (tipo ?tipo) (capacidad ?capacidad) (combustible ?combustible))
    =>
    (assert (transporte-disponible (id ?transporteId) (tipo ?tipo) (capacidad ?capacidad) (ubicacion ?ubicacionId) (combustible ?combustible))))

(defrule si-capacidad-transporte-es-menor-a-cantidad-carga-entonces-transporte-no-disponible
    (aeropuerto-inicial-disponible)
    (carga (cantidad ?cantidad))
    (ubicacion-inicial (id ?ubicacionId))
    ?transporte <- (transporte {ubicacion == ?ubicacionId && capacidad < ?cantidad})
    =>
    (assert (transporte-no-disponible)))

(defrule distancia-maxima-de-transporte-disponible
    ?transporte-disponible <- (transporte-disponible (id ?transporteId) (combustible ?combustible))
    =>
    (modify ?transporte-disponible (distancia-maxima (MaxDistancia ?combustible))))

(defrule combustible-suficiente
    (ubicacion-inicial (id ?idIni))
    (ubicacion-destino (id ?idDes))
    (ruta {inicio == ?idIni && fin == ?idDes} (distancia ?distancia-ruta))
    (transporte-disponible {distancia-maxima != nil && distancia-maxima >= ?distancia-ruta})
    =>
    (assert (accion (texto "El combustible es suficiente para el vuelo."))))

(defrule combustible-insuficiente
    (ubicacion-inicial (id ?idIni))
    (ubicacion-destino (id ?idDes))
    (ruta {inicio == ?idIni && fin == ?idDes} (distancia ?distancia-ruta))
    (transporte-disponible {distancia-maxima != nil && distancia-maxima < ?distancia-ruta})
    =>
    (assert (accion (texto "Hacer escala para recargar combustible."))))

; REGLAS DE DESCARGA

(defrule personal-militar-desciende-en-paracaidas
    (transporte-disponible)
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "conflicto armado"})
    (transporte-disponible {tipo == avion})
    (carga (tipo personal-militar))
    =>
    (assert (accion (texto "El personal militar debe descender en paracaidas.") )))

(defrule soltar-carga-en-paracaidas
    (transporte-disponible)
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "conflicto armado"})
    (transporte-disponible {tipo == avion})
    (carga (tipo suministros))
    =>
    (assert (accion (texto "Soltar la carga en paracaidas."))))

(defrule aterrizar-helicoptero-en-punto-cercano
    (transporte-disponible)
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "conflicto armado"})
    (transporte-disponible {tipo == helicoptero})
    =>
    (assert (accion (texto "Aterrizar el helicoptero en un punto cercano."))))

(defrule aterrizar-avion-normalmente
    (transporte-disponible)
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == DISPONIBLE})
    (transporte-disponible {tipo == avion})
    =>
    (assert (accion (texto "Aterrizar el avion normalmente."))))

(defrule aterrizar-helicoptero-normalmente
    (transporte-disponible)
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == DISPONIBLE})
    (transporte-disponible (id ?transporteId))
    (transporte {id == ?transporteId && tipo == helicoptero})
    =>
    (assert (accion (texto "Aterrizar el helicoptero normalmente."))))

; REGLAS DE DISPONIBILIDAD DE AEROPUERTO

(defrule aeropuerto-inicial-disponible
    (ubicacion-inicial (id ?uId))
    (ubicacion {id == ?uId && estado == DISPONIBLE})
    =>
    (assert (accion (texto "El aeropuerto inicial esta disponible.")))
    (assert (aeropuerto-inicial-disponible)))

(defrule aeropuerto-inicial-no-disponible
    "Verifica si el aeropuerto inicial no esta disponible"
    (ubicacion-inicial (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE} (razon ?razon))
    =>
    (assert (aeropuerto-inicial-no-disponible (razon ?razon))))

(defrule aeropuerto-destino-no-disponible
    "Verifica si el aeropuerto destino no esta disponible"
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE} (razon ?razon))
    =>
    (assert (aeropuerto-destino-no-disponible)))

(defrule aeropuerto-destino-no-disponible-por-cuasas-naturales
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "causas naturales"})
    =>
    (assert (accion (texto "El destino no esta disponbible por causas naturales."))))

(defrule aeropuerto-destino-no-disponible-por-bombardeo
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "bombardeo"})
    =>
    (assert (accion (texto "El destino no esta disponbible por bombardeo."))))

(defrule aeropuerto-destino-no-disponible-por-mal-pistas
    (ubicacion-destino (id ?uId))
    (ubicacion {id == ?uId && estado == NO_DISPONIBLE && razon == "pista en mal estado"})
    =>
    (assert (accion (texto "El destino no esta disponbible por pista en mal estado."))))

