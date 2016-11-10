
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