package procesadores;

public class NodoHoja extends Nodo{

    public NodoHoja(String n, String v) {
       super.tipo = "hoja";
       super.elemento = n;
    }
}
