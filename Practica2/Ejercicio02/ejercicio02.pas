{
    TIPO DE EJERCICIO : CORTE DE CONTROL

Este programa implementa un algoritmo que permite presentar la información de un archivo
en forma organizada de acuerdo a la estructura del archivo origen.
}

Program ejercicio02;

uses sysutils;

Type 

    regMae =   Record
        codAutor:   string;
        nombreAutor:   string;
        nombreDisco:   string;
        genero:   string;
        cantidad:   integer;
    End;

    maestro =   file Of regMae;

Procedure leer(var m:maestro;var rm:regMae;var fin:boolean);
Begin
    If (Not eof(m))Then
        Begin
            read(m,rm);
        End
    Else
        Begin
            fin := true;
        End;
End;


Var 

    origen :   maestro;
    informe :   text;
    auxRegMae :   regMae;
    codAutorAct :   string;
    generoAct:   string;
    cantDiscos:   integer;
    fin: boolean;

Begin

    assign(origen,'cds.dat');
    reset(origen);

    assign(informe,'informe.txt');
    rewrite(informe);

    cantDiscos := 0;

    fin := false;
   
    leer(origen,auxRegMae,fin);
    While (not fin) Do
        Begin
            codAutorAct :=   auxRegMae.codAutor;
            writeln(informe,'');
            writeln(informe,'Autor: '+auxRegMae.nombreAutor);
            While ((Not fin)And(codAutorAct = auxRegMae.codAutor)) Do
                Begin
                    cantDiscos := cantDiscos + 1;
                    generoAct := auxRegMae.genero;
                    writeln(informe,'Genero: '+generoAct);
                    While (not fin)And(codAutorAct = auxRegMae.codAutor)And(generoAct = auxRegMae.genero) Do
                        Begin
                            writeln(informe,'Nombre del disco: '+auxRegMae.nombreDisco+', cantidad vendida: '+IntToStr(auxRegMae.cantidad));
                            leer(origen,auxRegMae,fin);
                        End;
                End;
        End;
    
    close(informe);
    close(origen);

End.
