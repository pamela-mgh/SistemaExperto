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
            switch(hecho.getName()) {
                case "MAIN::transporte-disponible":
                    String accion = "";
                    String tipo = hecho.getSlotValue("tipo").toString();
                    String id = hecho.getSlotValue("id").toString();
                    accion += "Usar el " + tipo + " " + id;
                    plan.add(accion);
                    break;
            }
        }
        return plan;
    }
}
