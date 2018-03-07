package procesadores;

import java.util.ArrayList;

public class NodoIntermedio extends Nodo{

    public NodoIntermedio(String elemento) {
        super.hijos = new ArrayList<>();
        super.tipo = "intermedio";
        super.elemento = elemento;
        super.numHijos = 0;
    }
}