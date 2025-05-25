program parcial2;

const ValorAlto = 9999;

type

    registroDetalle = record
        añoVenta : integer;
        mesVenta : integer;
        diaVenta : integer;
        codigoMarca : integer;
        codigoModelo : integer;
        nombreMarca : string;
        nombreModelo : string;
        color : string;
        dni : string;
        montoOperacion : real;
    end;

    registroMaestro = record
        año : integer;
        mes : integer;
        montoTotal : real;
        cantidadTotal : integer;
    end;

    detalle = file of registroDetalle;
    maestro = file of registroMaestro;

    arrayDetalle = array[1..20]of detalle;
    arrayCabecerasDetalle = array[1..20]of registroDetalle;


procedure leer(var d:detalle;var rD:registroDetalle);
begin
    if(not eof(d))then
    begin
        read(d,rD);
    end
    else
    begin
    // CHEQUEAR QUE ONDA 
        rD.año := valorAlto;
    end;
end;

procedure minimo(var aD:arrayDetalle;var aCD:arrayCabecerasDetalle;var rDmin:registroDetalle);
var
    posMin,i : integer;
    aux : registroDetalle;
begin
    posMin := 1;
    rDmin := aCD[posMin];
    for i:= 2 to 20 do
    begin
        aux := aCD[i];
        if(aux.año < rDmin.año)then
        begin
            rDmin := aux;
            posMin := i;
        end
        else
        begin
            if(aux.año = rDmin.año)then
            begin
                if(aux.mes < rDmin.mes)then
                begin
                    rDmin := aux;
                    posMin := i;
                end
                else
                begin
                    if(aux.mes = rDmin.mes)then
                    begin
                        if(aux.dia < rDmin.dia)then
                        begin
                            rDmin := aux;
                            posMin := i;
                        end
                        else
                        begin
                            if(aux.dia = rDmin.dia)then
                            begin
                                if(aux.codigoMarca < rDmin.codigoMarca)then
                                begin
                                    rDmin := aux;
                                    posMin := i;
                                end
                                else
                                begin
                                    if(aux.codigoMarca = rDmin.codigoMarca)then
                                    begin
                                        if(aux.codigoModelo < rDmin.codigoModelo)then
                                        begin
                                            rDmin := aux;
                                            posMin := i;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end
        end;
    end;
    leer(aD[posMin],aCD[posMin]);
end;


procedure iniciarArchivos(var t:text;var m:maestro;var aD:arrayDetalle;var aCD:arrayCabecerasDetalle);
var
    i : integer;
begin
    assign(t,'informe.txt');
    rewrite(t);
    assign(m,'maestro.dat');
    rewrite(m);
    for i:= 1 to 20 do
    begin
        assign(aD[i],'detalle'+Str(i)+'.dat');
        reset(aD[i]);
        leer(aD[i],aCD[i]);
    end;
end;

procedure cerrarArchivos(var t:text;var m:maestro;var aD:arrayDetalle;var aCD:arrayCabecerasDetalle);
var
    i : integer;
begin
    close(m);
    close(t);
    for i:= 1 to 20 do
    begin
        close(aD[i]);
    end;
end;

var

    t : text;
    m : maestro;
    aD : arrayDetalle;
    aCD : arrayCabecerasDetalle;
    
    rDmin,auxD : registroDetalle;
    auxM : registroMaestro;

    añoActual,mesActual,diaActual,codigoModelo,codigoMarca : integer;
    marcaActual, modeloActual,nombreMenosVendido,nombreMasVendido : string;

    montoTotal : real;
    cantidadTotal,auxVendido,cantMenosVendido,cantMasVendido : integer;
    
begin

    iniciarArchivos(t,m,aD,aCD);

    minimo(aD,aCD,rDmin);

    while(rDmin.año <> ValorAlto)do
    begin

        añoActual := rDmin.año;

        while(rDmin.año = añoActual)do
        begin

            mesActual := rDmin.mes;
            montoTotal := 0;
            cantidadTotal := 0;

            while(rDmin.mes = mesActual)and(rDmin.año = añoActual)do
            begin

                diaActual := rDmin.dia;

                while(rDmin.dia = diaActual)and(rDmin.mes = mesActual)and(rDmin.año = añoActual)do
                begin

                    marcaActual := rDmin.nombreMarca;
                    codMarcaActual := rDmin.codigoMarca;
                    
                    cantMasVendido := -9999;
                    cantMenosVendido := 9999;

                    while(rDmin.nombreMarca = codMarcaActual)and(rDmin.dia = diaActual)and(rDmin.mes = mesActual)and(rDmin.año = añoActual)do
                    begin

                        modeloActual := rDmin.nombreModelo;
                        codModeloActual := rDmin.codigoModelo;
                        auxVendido := 0;

                        while(rDmin.nombreModelo = codModeloActual)and(rDmin.nombreMarca = codMarcaActual)and(rDmin.dia = diaActual)and(rDmin.mes = mesActual)and(rDmin.año = añoActual)do
                        begin
                            montoTotal := montoTotal + rDmin.montoOperacion;
                            cantidadTotal := cantidadTotal + 1;
                            auxVendido := auxVendido + 1;
                            minimo(aD,aCD,rDmin);
                        end;

                        if(auxVendido > cantMasVendido)then
                        begin
                            cantMasVendidos := auxVendido;
                            nombreMasVendido := modeloActual;
                        end;
                        if(auxVendido < cantMenosVendido)then
                        begin
                            cantMenosVendido := auxVendido;
                            nombreMenosVendido := modeloActual;
                        end;    

                    end;

                    writeln(t,'Marca: '+marcaActual);
                    writeln(t,'Mas vendido: ',nombreMasVendido,', unidades: ',cantMasVendido);
                    writeln(t,'Menos vendido: ',nombreMenosVendido,', unidades: ',cantMenosVendido);

                end;
            end;

            auxM.año := añoActual;
            auxM.mes := mesActual;
            auxM.montoTotal := montoTotal;
            auxM.cantidadTotal := cantidadTotal;
            write(m,auxM);

        end;
    end;

    cerrarArchivos(t,m,aD);

end.
