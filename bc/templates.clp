
; MAPA

(deftemplate ruta
    (slot estado (default DISPONIBLE))
    (slot inicio)
    (slot fin))

(deftemplate ubicacion
    (slot id)
    (slot nombre (type STRING) )
    (slot estado (default LIBRE) ))

; CARGA

(deftemplate suministros
    "Tipo de carga personal militar seleccionada"
    (slot peso (type INTEGER) ))

(deftemplate personal_militar
    "Tipo de carga personal militar seleccionada"
    (slot cantidad (type INTEGER) ))


; UBICACIÓN DE INICO Y UBICACIÓN DE DESTINO

(deftemplate ubicacion-inicial
    "La ubicación inicial del vuelo"
    (slot nombre))

(deftemplate ubicacion-destino
    "La ubicación de destino del vuelo"
    (slot nombre))
