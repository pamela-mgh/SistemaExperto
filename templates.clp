
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
    (slot peso (type INTEGER))
    (slot id-avion (type STRING)))

(deftemplate personal_militar
    "Tipo de carga personal militar seleccionada"
    (slot cantidad (type INTEGER))
    (slot id-avion (type STRING)))


; UBICACION DE INICO Y UBICACION DE DESTINO

(deftemplate ubicacion_inicial
    "La ubicacion inicial del vuelo"
    (slot id))

(deftemplate ubicacion_destino
    "La ubicacion de destino del vuelo"
    (slot id))

; INFO DE UN AVION

(deftemplate avion
    "Informacion del avion"
    (slot id-avion (type STRING))
    (slot capacidadMax (type INTEGER)))
    