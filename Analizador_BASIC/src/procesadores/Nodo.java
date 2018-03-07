package procesadores;

import java.util.ArrayList;

public abstract class Nodo {
	    String elemento;
	    String tipo;
	    ArrayList<Nodo> hijos;
	    int numHijos;
	    
	    public int getNumHijos() {
	        return numHijos;
	    }
	    public void setNumHijos(int numHijos) {
	        this.numHijos = numHijos;
	    }
	    public String getElemento() {
	        return elemento;
	    }
	    public String getTipo() {
	        return tipo;
	    }
	    public void setElemento(String elemento) {
	        this.elemento = elemento;
	    }
	    public void setTipo(String tipo) {
	        this.tipo = tipo;
	    }
	    public void setHijos(ArrayList<Nodo> hijos) {
	        this.hijos = hijos;
	    }
	    public ArrayList<Nodo> getHijos() {
	        return hijos;
	    }
	    public void añadirHijo( Nodo n){
	        hijos.add(n);
	        numHijos++;
	    }
}
