{
    TIPO DE EJERCICIO : GENERACION DE ARCHIVOS-MERGE

Este programa implementa un algoritmo que permite generar un archivo resumiendo información
obtenido de múltiples archivos.
}

program ejercicio04;

uses sysutils;

const valorAlto = '9999';

type

    registroDetalle = record 
        cod : string;
        nombre : string;
        genero : string;
        director : string;
        duracion : integer;
        fecha : string;
        cantidadAsistentes : integer;
    end;

    detalle = file of registroDetalle;

    arrayDetalles = array[1..20]of detalle;
    arrayCabecerasDetalles = array[1..20]of registroDetalle;

procedure leer(var d:detalle;var rD:registroDetalle);
begin
    if(not eof(d))then
    begin
        read(d,rD);
    end
    else
    begin
        rD.cod := valorAlto;
    end;
end;

procedure minimo(var aD:arrayDetalles;var aCD:arrayCabecerasDetalles;var rDMin:registroDetalle);
var
    posMin,i : integer;
begin
    posMin := 1;
    rDMin := aCD[posMin];
    for i:=2 to 20 do
    begin
        if(rDMin.cod > aCD[i].cod)then
        begin
            posMin := i;
            rDMin := aCD[i];
        end;
    end;
    leer(aD[posMin],aCD[posMin]);
end;

procedure actualizar(var m:detalle;var aD:arrayDetalles;var aCD:arrayCabecerasDetalles);
var
    rDMin:registroDetalle;
    rM:registroDetalle;
begin
    minimo(aD,aCD,rDMin);
    while(rDMin.cod <> valorAlto)do
    begin
        //Parte donde asigno los datos caracteristicos de la peli
        rM.cod := rDMin.cod;
        rM.nombre := rDMin.nombre;
        rM.genero := rDMin.genero;
        rM.director := rDMin.director;
        rM.duracion := rDMin.duracion;
        {
         Cada funcion puede tener alguna fecha distinta pero como no me especifican nada 
         lo dejo asi
        }
        rM.fecha := rDMin.fecha;
        rM.cantidadAsistentes := rDMin.cantidadAsistentes;
        // ----
        minimo(aD,aCD,rDMin);
        while(rM.cod = rDMin.cod)do
        begin
            rM.cantidadAsistentes := rM.cantidadAsistentes + rDMin.cantidadAsistentes;
            minimo(aD,aCD,rDMin);
        end;
        write(m,rM);
    end;
end;

procedure iniciarArchivos(var m:detalle;var aD:arrayDetalles;var aCD:arrayCabecerasDetalles);
var
    i:integer;
begin
    assign(m,'archivoMaestroDeLaSemana.dat');
    rewrite(m);
    for i:=1 to 20 do
    begin
        assign(aD[i],'archivoDetalle'+IntToStr(i)+'.dat');
        reset(aD[i]);
        leer(aD[i],aCD[i]);
    end;
end;

procedure cerrarArchivos(var m:detalle;var aD:arrayDetalles);
var
    i:integer;
begin
    close(m);
    for i:=1 to 20 do
    begin
        close(aD[i]);
    end;
end;

var
    m : detalle;
    aD : arrayDetalles;
    aCD : arrayCabecerasDetalles;

begin
    iniciarArchivos(m,aD,aCD);
    actualizar(m,aD,aCD);
    cerrarArchivos(m,aD);
end.