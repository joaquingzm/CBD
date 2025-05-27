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
    t : text;

    auxM : registroMaestro;
    rDmin : registroDetalle;
    aux,cantVV,cantTotalVV,cantTotalVV,cantVB,cantTotalVB,cantVA,cantTotalVA : integer;
begin

    iniciarArchivos(m,aD,aCD);
    assign(t,'cantidad_votos_04_07_2023.txt');
    rewrite(t);

    minimo(aD,aCD,rDmin);
    auxM.codProvincia := valorAlto;
    cantTotalVV :=0;
    cantTotalVB :=0;
    cantTotalVA :=0;

    while(rDmin.codProvincia <> valorAlto)do
    begin

        aux := rDmin.codProvincia;
        cantVV :=0;
        cantVB :=0;
        cantVA :=0;

        while(rDmin.codProvincia := aux)do
        begin
            cantVV := cantVV + rDmin.cantidadVotosValidos;
            cantVB := cantVB + rDmin.cantidadVotosBlanco;
            cantVA := cantVA + rDmin.cantidadVotosAnulados;
            minimo(aD,aCD,rDmin);
        end;

        while(auxM.codProvincia <> aux)do
        begin
            read(m,auxM);
        end;
        
        auxM.cantTotalVotosValidos := auxM.cantTotalVotosValidos + cantVV;
        auxM.cantTotalVotosBlanco := auxM.cantTotalVotosBlanco + cantVB;
        auxM.cantTotalVotosAnulados := auxM.cantTotalVotosAnulados + cantVA;

        cantTotalVV := cantTotalVV + cantVV;
        cantTotalVB := cantTotalVB + cantVB;
        cantTotalVA := cantTotalVA + cantVA;

        seek(m,filepos(m)-1);
        write(m,auxM);
    end;

    writeln(t,'Cantidad de archivos procesados: ',);
    writeln(t,'Cantidad total de votos: ',cantTotalVV + cantTotalVB + cantTotalVA);
    writeln(t,'Cantidad de votos válidos: ',canTotalVV);
    writeln(t,'Cantidad de votos anulados: ',cantTotalVA);
    writeln(t,'Cantidad de votos en blanco: ',cantTotalVB);

    close(t);
    cerrarArchivos(m,aD);
end.