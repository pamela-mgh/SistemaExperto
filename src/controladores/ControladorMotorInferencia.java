package controladores;

import java.util.Iterator;
import jess.Fact;
import jess.JessException;
import jess.Rete;

public class ControladorMotorInferencia {
    
    private final Rete motorInferencia;
    
    public ControladorMotorInferencia() throws JessException {
        motorInferencia = new Rete();
        motorInferencia.batch("bc/estrategia_militar.clp");
    }
    
    public void ejecutar() throws JessException {
    	motorInferencia.assertString("(ubicacion_inicial (id bm_cochabamba))");
        motorInferencia.run();
        Iterator<Fact> it = motorInferencia.listFacts();
        while (it.hasNext()) {
            Fact hecho = it.next();
            System.out.println(hecho);
        }
    }
}
