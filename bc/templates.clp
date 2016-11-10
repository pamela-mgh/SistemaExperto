
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


; UBICACIÓN DE INICO Y UBICACIÓN DE DESTINO

(deftemplate ubicacion_inicial
    "La ubicación inicial del vuelo"
    (slot id))

(deftemplate ubicacion_destino
    "La ubicación de destino del vuelo"
    (slot id))
