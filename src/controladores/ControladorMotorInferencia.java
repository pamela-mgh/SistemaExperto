package controladores;

import java.util.Iterator;
import jess.Fact;
import jess.JessException;
import jess.Rete;

public class ControladorMotorInferencia {
    
    private final Rete motorInferencia;
    
    public ControladorMotorInferencia() throws JessException {
        motorInferencia = new Rete();
        motorInferencia.batch("bc/templates.clp");
        motorInferencia.batch("bc/hechos.clp");
        motorInferencia.batch("bc/reglas.clp");
    }
    
    public void ejecutar() throws JessException {
        motorInferencia.assertString("(ubicacion_inicial (id bm_cbba))");
        motorInferencia.run();
        Iterator it = motorInferencia.listFacts();
        while (it.hasNext()) {
            Fact hecho = (Fact) it.next();
            System.out.println(hecho);
        }
    }
}
