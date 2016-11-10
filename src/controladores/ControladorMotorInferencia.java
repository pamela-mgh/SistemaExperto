package controladores;

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
        motorInferencia.reset();
        motorInferencia.batch("bc/estrategia_militar.clp");
    }
    
    public void evaluar(String hecho) {
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
}
