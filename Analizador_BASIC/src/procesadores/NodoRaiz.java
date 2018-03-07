package procesadores;

import java.util.ArrayList;

public class NodoRaiz extends Nodo{
	
    public NodoRaiz() {
        super.tipo = "Programa";
        super.elemento = "";
        super.numHijos = 0;
        super.hijos = new ArrayList<>();
    }
}
