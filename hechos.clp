; UBICACIONES

(assert (ubicacion (id bm_la_paz) (nombre "Base Militar La Paz")))
(assert (ubicacion (id bm_cbba) (nombre "Base Militar Cochabamba") (estado NO_DISPONIBLE)))
(assert (ubicacion (id bm_santa_cruz) (nombre "Base Militar Santa Cruz")))
(assert (ubicacion (id bm_sucre) (nombre "Base Militar Sucre")))
(assert (ubicacion (id bm_potosi) (nombre "Base Militar Potosi")))

; RUTAS

(assert (ruta (inicio bm_santa_cruz) (fin bm_la_paz)))
(assert (ruta (inicio bm_la_paz) (fin bm_santa_cruz) (estado COMPROMETIDO)))

(assert (ruta (inicio bm_santa_cruz) (fin bm_cbba)))
(assert (ruta (inicio bm_cbba) (fin bm_santa_cruz) ))

(assert (ruta (inicio bm_la_paz) (fin bm_cbba)))
(assert (ruta (inicio bm_cbba) (fin bm_la_paz)))

(assert (ruta (inicio bm_sucre) (fin bm_potosi) (estado COMPROMETIDO)))
(assert (ruta (inicio bm_potosi) (fin bm_sucre)))

; TIPOS DE CARGAS

(assert (suministros (peso 100) (id-avion "AX-01")))
(assert (suministros (peso 200) (id-avion "AX-05")))
(assert (personal_militar (cantidad 40) (id-avion "AX-03"))) 
(assert (personal_militar (cantidad 60) (id-avion "AX-06"))) 

; AVIONES

(assert (avion (id-avion "AX-01") (capacidadMax 100)))
(assert (avion (id-avion "AX-03") (capacidadMax 240)))
(assert (avion (id-avion "AX-05") (capacidadMax 300)))
(assert (avion (id-avion "AX-06") (capacidadMax 200)))

