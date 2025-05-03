{
    TIPO DE EJERCICIO : REGISTROS DE LONGITUD FIJA
                        A) BAJA LÓGICA Y COMPACTACIÓN 
                        B) BAJA FÍSICA (ya de por sí compacta)

Este programa implementa los algoritmos A y B que permiten dar de baja ciertas plantas
de un archivo maestro donde los registros son de longitud fija.
}

program ejercicio01;

const 
    codBorrado = '@';
    codFinIngreso = '100000';

type

    registroPlanta = record
        cod : string;
        nombreV : string;
        nombreC : string;
        alturaP : real;
        descripcion : string;
        zonaG : string;
    end;

    maestro = file of registroPlanta;


procedure leerPlantaABorrar(var codABorrar:string;var fin:boolean);
begin
    writeln('Ingrese el codigo de la planta a borrar (Ingrese '+codFinIngreso+' para finalizar): ');
    readln(codABorrar);
    if(codABorrar = codFinIngreso)then 
    begin
        fin := true;
    end
    else
    begin
        fin := false;
    end;
end;

procedure borrarPlantasA(var m:maestro);
var
    fin : boolean;
    codABorrar : string;
    auxRP : registroPlanta;
    nuevoM : maestro;
begin
    leerPlantaABorrar(codABorrar,fin);
    fin := false;
    seek(m,0);
    while(not fin)do
    begin
        // Algoritmo de baja lógica
        auxRP.cod := 'zzz';
        while(not eof(m))and(auxRP.cod <> codABorrar)do
        begin
            read(m,auxRP);
        end;
        if(not eof(m))then
        begin
            auxRP.cod := codBorrado;
            seek(m,filepos(m)-1);
            write(m,auxRP);
        end;
        // Fin de algoritmo de baja lógica
        seek(m,0);
        leerPlantaABorrar(codABorrar,fin);
    end;

    // Algoritmo de compactación para bajas lógicas
    assign(nuevoM,'nuevoMA.dat');
    rewrite(nuevoM);
    while(not eof(m))do
    begin
        read(m,auxRP);
        if(auxRP.cod <> codBorrado)then
        begin
            write(nuevoM,auxRP);
        end;
    end;
    close(nuevoM);
    // Fin de algoritmo de compactación para bajas lógicas
end;

procedure borrarPlantasB(var m:maestro);
var
    codABorrar : string;
    fin : boolean;
    auxRP : registroPlanta;
    pos : integer;
begin
    leerPlantaABorrar(codABorrar,fin);
    fin := false;
    seek(m,0);
    while(not fin)do
    begin
        // Algoritmo de baja física
        auxRP.cod := 'zzz';
        while(not eof(m))and(auxRP.cod <> codABorrar)do
        begin
            read(m,auxRP);
        end;
        if(not eof(m))then
        begin
            pos := filepos(m) - 1;
            seek(m,filesize(m) - 1);
            read(m,auxRP);
            seek(m,pos);
            write(m,auxRP);
            seek(m,filesize(m)-1);
            truncate(m);
        end;
        // Fin de algoritmo de baja física
        seek(m,0);
        leerPlantaABorrar(codABorrar,fin);
    end;
end;

begin
end.