program parcial8;

const valorAlto = 9999;

type

    registroDetalle = record
        codProvincia : integer;
        codLocalidad : integer;
        cantVotosValidos : integer;
        cantVotosBlanco : integer;
        cantVotosAnulados : integer;
    end;

    registroMaestro = record
        codProvincia : integer;
        nombreProvincia : integer;
        cantTotalVotosValidos : integer;
        cantTotalVotosBlanco : integer;
        cantTotalVotosAnulados : integer;
    end;

    detalle = file of registroDetalle;
    maestro = file of registroMaestro;

    arrayDetalles = array[1..500]of detalle;
    arrayCabecerasDetalles = array[1..500]of registroDetalle;


procedure leer(var d:detalle;var rD:registroDetalle);

begin
    if(not eof(d))then
    begin
        read(d,rD);
    end
    else
    begin
        rD.codProvincia := valorAlto;
    end;
end;

procedure minimo(var aD:arrayDetalles;var aCD:arrayCabecerasDetalles;rDmin:registroDetalle);
var
    i,posMin : integer;

begin
    rDmin := aD[1];
    posMin := 1;

    for i:=2 to 500 do 
    begin
        aux := aD[i];
        if(rDmin.codProvincia > aux.codProvincia)then
        begin

        end
        else
        begin
            if(rDmin.codProvincia = aux.codProvincia)then
            begin
                if(rDmin.codLocalidad > aux.codLocalidad)then
                begin
                    rDmin := aux;
                    posMin := i;
                end;
            end;
        end;
    end;

    leer(aD[posMin],aCD[posMin]);
end;


procedure iniciarArchivos(var m:maestro;var aD:arrayDetalles;var aCD:arrayCabecerasDetalles);
var
    i : integer;
    auxStr : string;
begin
    assign(m,'maestro.dat');
    reset(m);
    for i:=1 to 500 do 
    begin
        Str(i,auxStr);
        assign(aD[i],'detalle'+auxStr+'.dat');
        reset(aD[i]);
    end;
end;

procedure cerrarArchivos(var m:maestro;var aD:arrayDetalles);
var
    i : integer;
begin
    close(m);
    for i:=1 to 500 do
    begin
        close(aD[i]);
    end;
end;
var
    m : maestro;
    aD : arrayDetalles;
    aCD : arrayCabecerasDetalles;

    auxM : registroMaestro;
    rDmin : registroDetalle;
begin

    iniciarArchivos(m,aD,aCD);

    minimo(aD,aCD,rDmin);
    while(rDmin.codProvincia <> valorAlto)do
    begin
        read(m,auxM)
    end;

    cerrarArchivos(m,aD);
end.