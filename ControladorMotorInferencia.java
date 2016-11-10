package controladores;

import java.util.Iterator;
import jess.Fact;
import jess.JessException;
import jess.Rete;

public class ControladorMotorInferencia {
    
    private final Rete motorInferencia;
    
    /*
    public ControladorMotorInferencia() throws JessException {
        motorInferencia = new Rete();
        motorInferencia.batch("bc/templates.clp");
        motorInferencia.batch("bc/hechos.clp");
        motorInferencia.batch("bc/reglas.clp");
    }
    */
    
    
public ControladorMotorInferencia() throws JessException {
         motorInferencia = new Rete();
         motorInferencia.reset();
         motorInferencia.batch("bc/estrategia_militar.clp");
     }
     
     public void ejecutar() throws JessException {
     	//cbba a santa cruz: disponible
        motorInferencia.assertString("(ubicacion_inicial (id bm_cbba))");
    	motorInferencia.assertString("(ubicacion_destino (id bm_santa_cruz))");
        motorInferencia.run();
        System.out.println("\n\n");
        //sucre a potosi: comprometido
        motorInferencia.assertString("(ubicacion_inicial (id bm_sucre))");
    	motorInferencia.assertString("(ubicacion_destino (id bm_potosi))");
        motorInferencia.run();
         int i = 1;
         Iterator<Fact> it = motorInferencia.listFacts();
         System.out.println("\nLISTA DE HECHOS ");
        while (it.hasNext()) {
            Fact hecho = (Fact) it.next();
            System.out.println(i + ") " + hecho);
            i++;
        }
    }
}
