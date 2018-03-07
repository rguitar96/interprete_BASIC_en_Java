 package procesadores;

import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.io.*;
import java_cup.runtime.*;

class Yytoken {
	public int contador;
    public String token;
    public String tipo;
    public int linea;
    public int columna;
    
    Yytoken (int contador,String token, String tipo, int linea, int columna){
        this.contador = contador;
        this.token = new String(token);
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }
    
    public String toString() {
        if (tipo == "error"){
            return "Se ha detectado un error lexico, no se reconoce la palabra: " + token + " en la linea: " + (linea+1) + ". ";
        }
        if (tipo == "constante" || tipo == "variable" || tipo == "entrada"){
            return tipo + "(" + token + ")";
        }
        else{
            return token;
}}}


//Bloque de configuracion analizador
%%
%integer
%7bit
%line
%column
%full
%class Lexico
%cup

%init{
	System.out.println("****************COMIENZO DEL PROGRAMA****************");
%init}

%eof{
		this.writeOutputFile(); 
		this.escribirErrores();
		System.exit(0);

%eof}

//Bloque de java
%{

private ArrayList<Yytoken> tokenList = new ArrayList<Yytoken>();
private ArrayList<Yytoken> errorList = new ArrayList<Yytoken>();
int cont = 0;
int contErr = 0;
boolean banderaReservada = true;
public int getErr(){
	return contErr;
}



public void imprimir() throws IOException {
	this.writeOutputFile();
	this.escribirErrores();
}

private void writeOutputFile() throws IOException {
	System.out.println("****************FIN DEL ANALIZADOR LEXICO****************");
	System.out.println("Lista de tokens almacenados con exito: ");
	System.out.print("[");
	int separador = 0;
	for (Yytoken t : this.tokenList) {
		separador++;
		if (separador>4) {
			System.out.println();
			separador = 0;
			}
		System.out.print(t.toString() + ",");
	}
	System.out.print("]");
	System.out.println("\n\n");
}

private void escribirErrores() {
		if(contErr>0){
            System.out.println("\n\nHemos encontrado " + contErr + " errores lexicos.");
            System.out.print ("\n[");
            for(Yytoken t: this.errorList){
                System.out.print(t.toString());
            }
            System.out.print("]");
        }
        else{
            System.out.println("\n No hay errores lexicos.");
        }
}

public static void main(String[] args) {
		String entrada = "";
        System.out.println("\n*** Procesando archivo ***\n");
        entrada = "entrada.txt";
        BufferedReader bf = null;
        try {
            bf = new BufferedReader(new FileReader(entrada));
            Lexico a = new Lexico(bf);
            Symbol token = null;
            do {
                token = a.next_token();
            } while (token != null);
        } catch (Exception ex) {
            Logger.getLogger(Lexico.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                bf.close();
            } catch (IOException ex) {
                Logger.getLogger(Lexico.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        System.out.println("\n*** Ejecucion finalizada ***\n");
	}

%}

//Macros
Letra = [a-zA-Z]
Digito = [0-9]
Car_Cadena = "\"" | {Car_Cad_Delimitado}
Car_Cad_Delimitado = \! | # | \$ | % | & | "\'" | \| | \* | , | \/ | : | ; | < | = | > | \? | \* | \^ | _ | {Car_No_Delimitado}
Car_No_Delimitado = " " | {Car_Cadena_Simple}
Car_Cadena_Simple = \+ | - | \. | {Digito} | {Letra}
Cad_REM = {Car_Cadena}*
Cad_Delimitada = "\""{Car_Cad_Delimitado}*"\""
Cad_No_Delimitada = {Car_Cadena_Simple} | ({Car_Cadena_Simple} {Car_No_Delimitada} {Car_Cadena_Simple})



Identificador = [A-Z] | [A-Z]\$


ErrorIde = [a-zA-Z] [a-zA-Z0-9]+



Constante = {ConsNum} | {ConsCad} | {ConsNumDec} | {ConsNumEsc}

ConsNum = {Digito}+ 
ConsCad = {Cad_Delimitada} 
ConsNumDec = {Digito}+ \. {Digito}+
ConsNumEsc = {ConsNum}E{ConsNum} | {ConsNumDec}E{ConsNum} 



Espacio = " " | \t | \f | \r
Salto= \n | \r | \r\n


Entrada = [\n\r]({Digito})+

FNX = FN[A-Z]

REM = REM[^\n\r\r\n]*

%%
	//PALABRAS RESERVADAS Y FUNCIONES
	"DATA"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.data, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.data, yyline, yycolumn, yytext());
		}
		}
	"DEF"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.def, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.def, yyline, yycolumn, yytext());
		}
		}
	"DIM"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.dim, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.dim, yyline, yycolumn, yytext());
		}
		}
	"END"			{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.end, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.end, yyline, yycolumn, yytext());
		}
		}
	"FOR"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.t_for, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.t_for, yyline, yycolumn, yytext());
		}
		}
	"GOSUB"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.gosub, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.gosub, yyline, yycolumn, yytext());
		}
		}
	"GOTO"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.t_goto, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.t_goto, yyline, yycolumn, yytext());
		}
		}
	"IF"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.t_if, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.t_if, yyline, yycolumn, yytext());
		}
		}
	"INPUT"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.input, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.input, yyline, yycolumn, yytext());
		}
		}
	"LET"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.let, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.let, yyline, yycolumn, yytext());
		}
		}
	"NEXT"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.next, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.next, yyline, yycolumn, yytext());
		}
		}
	"ON"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.on, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.on, yyline, yycolumn, yytext());
		}
		}
	"PRINT"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.print, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.print, yyline, yycolumn, yytext());
		}
		}
	"READ"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.read, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.read, yyline, yycolumn, yytext());
		}
		}
	{REM}			{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.rem, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.rem, yyline, yycolumn, yytext());
		}
		}
	"STEP"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.step, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.step, yyline, yycolumn, yytext());
		}
		}
	"STOP"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.stop, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.stop, yyline, yycolumn, yytext());
		}
		}
	"THEN"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.then, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.then, yyline, yycolumn, yytext());
		}
		}
	"TO"[" "\n]	{
		if (banderaReservada) {
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.to, yyline, yycolumn, yytext());
		} else {
			System.err.println("La palabra reservada "+yytext()+" debe estar entre espacios.");
			cont++; 
			this.tokenList.add(new Yytoken(cont, yytext(), "reservada", yyline, yycolumn)); 
			return new Symbol(SintacticoSym.to, yyline, yycolumn, yytext());
		}
		}
	"ABS"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.abs, yyline, yycolumn, yytext());
		}
	"ATN"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.atn, yyline, yycolumn, yytext());
		}
	"COS"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.cos, yyline, yycolumn, yytext());
		}		
	"EXP"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.exp, yyline, yycolumn, yytext());
		}
	"INT"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.t_int, yyline, yycolumn, yytext());
		}
	"LOG"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.log, yyline, yycolumn, yytext());
		}
	"RND"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.rnd, yyline, yycolumn, yytext());
		}
	"SGN"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.sgn, yyline, yycolumn, yytext());
		}
	"SIN"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.sin, yyline, yycolumn, yytext());
		}
	"SQR"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.sqr, yyline, yycolumn, yytext());
		}
	"TAN"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.tan, yyline, yycolumn, yytext());
		}
	"RESTORE"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.restore, yyline, yycolumn, yytext());
		}
	"RETURN"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.t_return, yyline, yycolumn, yytext());
		}	
	"RANDOMIZE"	{
		cont++; 
		banderaReservada = false;
		this.tokenList.add(new Yytoken(cont, yytext(), "funcion", yyline, yycolumn)); 
		return new Symbol(SintacticoSym.randomize, yyline, yycolumn, yytext());
		}

    //SIGNOS DE PUNTUACION 
    ","	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "coma", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.coma, yyline, yycolumn, yytext());
    	}
    "("	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "parentesis_izq", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.parentesis_izq, yyline, yycolumn, yytext());
    	}
    ")"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "parentesis_dch", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.parentesis_dch, yyline, yycolumn, yytext());
    	}
    "+"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "suma", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.suma, yyline, yycolumn, yytext());
    	}
    "-"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "resta", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.resta, yyline, yycolumn, yytext());
    	}
    ">"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "mayor", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.mayor, yyline, yycolumn, yytext());
    	}
    "*"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "multiplicacion", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.multiplicacion, yyline, yycolumn, yytext());
    	}
    "/"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "division", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.division, yyline, yycolumn, yytext());
    	}
    ";"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "punto_coma", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.punto_coma, yyline, yycolumn, yytext());
    	}
    "<"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "menor", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.menor, yyline, yycolumn, yytext());
    	}
    ">="	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "mayor_igual", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.mayor_igual, yyline, yycolumn, yytext());
    	}
    "<="	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "menor_igual", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.menor_igual, yyline, yycolumn, yytext());
    	}
    "<>"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "no_igual", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.no_igual, yyline, yycolumn, yytext());
    	}
    "="		{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "igual", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.igual, yyline, yycolumn, yytext());
    	}
    "^"	{
    	cont++; 
    	banderaReservada = false;
    	this.tokenList.add(new Yytoken(cont, "potencia", "puntuacion", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.potencia, yyline, yycolumn, yytext());
    	}
    

    //DEFINICIONES LEXICAS

    {Constante}	{
    	banderaReservada = false;
    	if (cont>0) {
    		this.tokenList.add(new Yytoken(cont, yytext(), "constante", yyline, yycolumn)); 
    		return new Symbol(SintacticoSym.constante, yyline, yycolumn, yytext());
    		} 
    	else {
    		this.tokenList.add(new Yytoken(cont, yytext(), "entrada", yyline, yycolumn)); 
    		return new Symbol(SintacticoSym.entrada, yyline, yycolumn, yytext());
    		}
    	}
    {Entrada}	{
    	cont++; 
    	banderaReservada = false;
    	String entrada = yytext();
    	entrada = entrada.replace("\n", "");
    	this.tokenList.add(new Yytoken(cont, entrada, "entrada", yyline, yycolumn)); 
    	return new Symbol(SintacticoSym.entrada, yyline, yycolumn, yytext());
    	}
    	    
    {Identificador}	{
    	cont++;
    	banderaReservada = false;
    	Yytoken t = new Yytoken(cont, yytext(), "variable", yyline, yycolumn);
    	this.tokenList.add(t); 
    	return new Symbol(SintacticoSym.variable, yyline, yycolumn, yytext());
    	}
    	
    {FNX}	{
    	cont++;
    	banderaReservada = false;
    	Yytoken t = new Yytoken(cont, yytext(), "variable", yyline, yycolumn);
    	this.tokenList.add(t); 
    	return new Symbol(SintacticoSym.fnx, yyline, yycolumn, yytext());
    	}
    
    {ErrorIde}	{
    	contErr++; 
    	banderaReservada = false;
    	Yytoken t = new Yytoken(cont, yytext(), "error", yyline, yycolumn);
    	this.errorList.add(t);
    	}
    {Espacio}	{
    	banderaReservada = true;
    	}
 	

	<<EOF>>         {
		this.writeOutputFile(); 
		this.escribirErrores();
		return new Symbol(SintacticoSym.eof, yyline, yycolumn, yytext());
	}
	
	.	{
		contErr++; 
		errorList.add(new Yytoken(contErr, yytext(), "error", yyline, yycolumn));
		}