{
Asumo que la información en el txt va a estar ordenada como:

codigoExcursion CantidadTotalVendida
nombre
descripcion


NO LO TERMINE
}

program parcial6;


type

    regisotroMaestro = record
        codigoExcursion : integer;
        cantidadTotalVendida : integer;
        nombre : string;
        descripcion : string;
    end;

    maestro = file of registroMaestro;


var

    t : text;
    m : maestro;
    aux,rM : registroMaestro;
    codActual : integer;

begin

    assign(t,'detalle.txt');
    reset(t);
    assign(m,'maestro.dat');
    rewrite(m);

    readln(t,aux.codigoExcursion,aux.cantidadTotalVendida);
    readln(t,aux.nombre);
    readln(t,aux.descripcion);
    while(not eof(t))do
    begin

        rM := aux;
        rM.cantidadTotalVendida := 0;
        codActual := aux.codigoExcursion;

        while(not eof(t))and(codActual = aux.codigoExcursion)do
        begin

            rM.cantidadTotalVendida := rM.cantidadTotalVentida + aux.cantidadTotalVendida;
            readln(t,aux.codigoExcursion,aux.cantidadTotalVendida);
            readln(t,aux.nombre);
            readln(t,aux.descripcion);    

        end;

        write(m,rM);
    end;

    close(t);
    close(m);

end.