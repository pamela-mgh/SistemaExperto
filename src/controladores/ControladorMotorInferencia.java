package controladores;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jess.Fact;
import jess.JessException;
import jess.Rete;
import jess.Value;
import jess.ValueVector;

public class ControladorMotorInferencia {
    
    private final Rete motorInferencia;
    
    public ControladorMotorInferencia() throws JessException {
        motorInferencia = new Rete();
        motorInferencia.batch("bc/estrategia_militar.clp");
        motorInferencia.reset();
    }
    
    public void insertarHecho(String hecho) {
        try {
            motorInferencia.assertString(hecho);
        } catch (JessException ex) {
            Logger.getLogger(ControladorMotorInferencia.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void ejecutar() throws JessException {
        motorInferencia.run();
    }
    
    public ValueVector getCamino() throws JessException {
        Iterator<Fact> it = motorInferencia.listFacts();
        while (it.hasNext()) {
            Fact hecho = it.next();
            if (hecho.getName().equals("MAIN::plan")) {
                Value camino = hecho.getSlotValue("camino");
                ValueVector caminoVector = camino.listValue(null);
                System.out.println(caminoVector);
                return caminoVector;
            }
        }
        throw new JessException("No hay un plan", "No hay respuesta", "No hay respuesta");
    }

    public List<String> getPlan() throws JessException {
        List<String> plan = new ArrayList<>();
        Iterator<Fact> it = motorInferencia.listFacts();
        while (it.hasNext()) {
            Fact hecho = it.next();
            String nombreHecho = hecho.getName();
            System.out.println(hecho);
            switch(nombreHecho) {
                case "MAIN::ubicacion-inicial-igual-a-destino":
                    plan.add("No es necesario planificar un vuelo ya que la ubicacion inicial y final son iguales.");
                    break;
                case "MAIN::aeropuerto-inicial-no-disponible":
                    String razonInicio = hecho.getSlotValue("razon").toString();
                    plan.add("El aeropuerto inicial no esta disponible por " + razonInicio.substring(1, razonInicio.length()-1));
                    break;
                case "MAIN::aeropuerto-destino-no-disponible":
                    String razonDestino = hecho.getSlotValue("razon").toString();
                    System.out.println(razonDestino);
                    plan.add("El aeropuerto destino no esta disponible por " + razonDestino.substring(1, razonDestino.length()-1));
                    break;
                case "MAIN::transporte-disponible":
                    String tipo = hecho.getSlotValue("tipo").toString();
                    String id = hecho.getSlotValue("id").toString();
                    plan.add("Usar el " + tipo + " " + id + ".");
                    break;
                case "MAIN::transporte-no-disponible":
                    plan.add("No he podido realizar un plan debido a que no existe transporte con capacidad para la cantidad de carga introducida.");
                    break;
                case "MAIN::accion":
                    String texto = hecho.getSlotValue("texto").toString();
                    plan.add(texto.substring(1, texto.length()-1));
                    break;
            }
        }
        return plan;
    }
}
