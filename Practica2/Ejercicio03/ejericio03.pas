{
    TIPO DE EJERCICIO : ACTUALIZACIÓN DE ARCHIVOS-MAESTRO/DETALLE

Este programa implementa un algoritmo que permite actualizar la información de un 
archivo maestro a partir de múltiples detalles. 
}

program ejercicio03;

Uses sysutils;

const valorAlto = '9999';


// Definicion de tipos
type

    registroDetalle = record 
        codCalzado : string;
        numeroCalzado : string;
        cantVendida : integer;
    end;

    registroMaestro = record
        codCalzado : string;
        numeroCalzado : string;
        descripcion : string;
        precio : real;
        color : string;
        stock : integer;
        stockMinimo : integer;
    end;

    detalle = file of registroDetalle;
    maestro = file of registroMaestro;
    informeCalzadosSinStock = text;

    arrayDetalle = array[1..20]of detalle;
    arrayCabecerasDetalle = array[1..20]of registroDetalle;

// Método de lectura, si se llega al final de alguno de los archivos detalle
// se pone a sus registro cabecera en valorAlto para marcarlo
procedure leer(var d:detalle;var rD:registroDetalle);
begin
    if(not eof(d))then 
    begin 
        read(d,rD);
    end
    else
    begin
        rD.codCalzado := valorAlto;
    end;
end;


// Al estar los archivos detalle y maestro ordenados, para procesar todos los detalles
// en orden tomamos del array de registros cabecera al registro de menor codigo, se reemplaza
// el registro cabecera por el siguiente dato de su archivo correspondiente (utilizando el método leer())
procedure minimo(var aD:arrayDetalle;var aCD:arrayCabecerasDetalle;var rDMin:registroDetalle);
var
    posMin,i:integer;
begin
    posMin := 1;
    rDMin := aCD[1];
    for i:=1 to 20 do
    begin
        if(aCD[i].codCalzado < rDMin.codCalzado)then
        begin
            rDMin := aCD[i];
            posMin := i;
        end;
    end;
    leer(aD[posMin],aCD[posMin]);
end;

// Inicio de archivos
procedure iniciarArchivos(var m:maestro;var aD:arrayDetalle;var aCD:arrayCabecerasDetalle);
var
    i:integer;
begin
    assign(m,'archivoMaestro.dat');
    reset(m);

    for i:=1 to 20 do
    begin
        assign(aD[i],'archivoDetalle'+IntToStr(i)+'.dat');
        reset(aD[i]);
        leer(aD[i],aCD[i]);
    end;
end;

// Cierre de archivos
procedure cerrarArchivos(var m:maestro;var aD:arrayDetalle;var aCD:arrayCabecerasDetalle);
var
    i:integer;
begin
    close(m);
    for i:=1 to 20 do
    begin
        close(aD[i]);
    end;
end;

// En esta logica de actualizacion del archivo maestro en base a los 20 archivos detalle
// no diferencio entre calzados de mismo codigo y distinto talle, asumo no se va a tomar en cuenta
// el talle en el archivo maestro y detalles, me dio paja
procedure actualizarMaestroConDetalles(var m:maestro;var arrayD:arrayDetalle;var arrayCD:arrayCabecerasDetalle;var informe:informeCalzadosSinStock);
var
    regDMin : registroDetalle;
    auxRM : registroMaestro;

    seRealizoUnaVentaValida : boolean;
begin
    
    minimo(arrayD,arrayCD,regDMin);

    // Le pongo valor alto al codCalzado para que entre al while en caso de que
    // los archivos detalles no estén vacíos
    auxRM.codCalzado := valorAlto;
    while(regDMin.codCalzado <> valorAlto) do
    begin

        while(not eof(m))and(auxRM.codCalzado <> regDMin.codCalzado) do
        begin
            // Leo primer calzado de archivo maestro
            read(m,auxRM);
            // Busco que si hay algun calzado del mismo codigo en los archivos detalle
            if (auxRM.codCalzado <> regDMin.codCalzado)then
            begin
                // Si no hay ningun calzado del mismo codigo en los archivos detalle,
                // informo que no ha habido ventas
                writeln('Calzado sin ventas cod:'+auxRM.codCalzado);
            end;
        end;
        if(not eof(m))then
        begin
            // Puede haber varias actualizaciones de los distintos detalles para un
            // mismo codigo de calzado, si la primera de ellas registra una cantidad 
            // de ventas mayor al stock, la descarto, pero puede que la siguiente sí
            // tenga una venta valida, por lo que esta vareable boolean sirve para 
            // determinar que en ninguno archivo se realizaron ventas/ventas validas
            seRealizoUnaVentaValida := false;
            // Mientras los siguientes redDMin sean del mismo codigo de calzado, 
            // sigo actualizando el auxRM
            while (auxRM.codCalzado = regDMin.codCalzado) do
            begin
                if(auxRM.stock - regDMin.cantVendida >= 0)then
                begin
                    if(not seRealizoUnaVentaValida)then seRealizoUnaVentaValida := true;
                    auxRM.stock := auxRM.stock - regDMin.cantVendida;
                    minimo(arrayD,arrayCD,regDMin);
                end;
            end;
            if(not seRealizoUnaVentaValida)then
            begin
                writeln('Calzado cod:'+auxRM.codCalzado+' no tuvo una venta válida');
            end;
            // Si se paso por debajo del stock minimo, lo informo
            if (auxRM.stock < auxRM.stockMinimo)then
            begin
                writeln(informe,'Calzado cod:'+auxRM.codCalzado+' quedó por debajo del stock minimo');
            end;
            // Me posicionó en el calzado que acabo de procesar para actualizarlo
            seek(m,filepos(m)-1);
            write(m,auxRM);
        end;
    end;

end;

var
    m : maestro;
    // Archivo donde informar los calzados que tienen su stock por debajo del minimo
    calzadosSinStock : informeCalzadosSinStock;
    // Array que contiene los archivos detalle
    arrayD:arrayDetalle;
    // Array que contiene los registros de cabecera de los archivos detalle
    arrayCD:arrayCabecerasDetalle;

begin
    assign(calzadosSinStock,'calzadossinstock.txt');
    rewrite(calzadosSinStock);
    iniciarArchivos(m,arrayD,arrayCD);
    actualizarMaestroConDetalles(m,arrayD,arrayCD,calzadosSinStock);
    cerrarArchivos(m,arrayD,arrayCD);
    close(calzadosSinStock);
end.