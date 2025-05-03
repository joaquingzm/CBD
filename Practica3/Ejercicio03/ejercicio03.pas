{
    TIPO DE EJERCICIO:
En este caso se implementaron varios algoritmos.


FORMA EN LA QUE VA A ESTAR ORDENADO EL TXT:
Línea 1: cod stock nombre
Línea 2: descripcion
}
program ejercicio03;

const
    marcaDeBorradoStock = -1;
    valorInvalidoCod = -1; 
    valorNoExistenRegistrosLibres = -1;

type

    registroIndumentaria = record
        cod : integer;
        stock : integer;
        nombre : string;
        descripcion : string;
    end;

    binario = file of registroIndumentaria;


// Generación de archivo binario a partir de txt
procedure a(var t:text; var b:binario);
var
    aux : registroIndumentaria;
begin
    reset(t);
    rewrite(b);
    while(not eof(t))do
    begin
        readln(t,aux.cod,aux.stock,aux.nombre);
        readln(t,aux.descripcion);
        write(b,aux);
    end;
end;

// Algoritmo de baja de registros sin listas invertidas
procedure b(var b:binario);
var
    codABorrar, nLibre : integer;
    aux : registroIndumentaria;
begin
    write('Ingrese codigo a borrar(-1 para finalizar): ');readln(codABorrar);
    while(codABorrar <> valorInvalidoCod)do
    begin
        seek(b,0);
        aux.cod := valorInvalidoCod -1;
        aux.stock := marcaDeBorradoStock -1;
        while(not eof(b))and(aux.cod <> codABorrar)do read(b,aux);
        if(aux.cod = codABorrar)then
        begin
            nLibre := filepos(b)-1;
            seek(b,nLibre);
            aux.cod := valorInvalidoCod;
            aux.stock := marcaDeBorradoStock;
            write(b,aux);
        end;
        write('Ingrese codigo a borrar(-1 para finalizar): ');readln(codABorrar);
    end;
end;

// Algoritmo de alta de registros sin listas invertidas
procedure c(var b:binario);
var
    nuevoR,aux : registroIndumentaria;
begin
    leerRegistroAIngresar(nuevoR);
    if(nuevoR.cod <> valorInvalidoCod)then
    begin
        seek(b,filesize(b));
        write(b,nuevoR);
    end
    else
    begin
        write('El valor del codigo ingresado no es valido');
    end;
end;

// Algoritmo de baja de registros utilizando técnica de listas invertidas
procedure d(var b:binario);
var
    encabezado,aux : registroIndumentaria;
    nLibre,codABorrar : integer;
begin
    write('Ingrese codigo a borrar(-1 para finalizar): ');readln(codABorrar);
    while(codABorrar <> valorInvalidoCod)do
    begin
        seek(b,0);
        read(b,encabezado);
        aux.cod := valorInvalidoCod -1;
        while(not eof(b))and(codABorrar <> aux.cod)do read(b,aux);
        if (codABorrar = aux.cod)then
        begin
            nLibre := filepos(b) -1;
            seek(b,nLibre);
            write(b,encabezado);
            seek(b,0);
            aux.cod := valorInvalidoCod;
            aux.stock := nLibre;
            write(b,aux);
        end
        else
        begin
            writeln('No existe la indumentaria con ese codigo');
        end;
        write('Ingrese codigo a borrar(-1 para finalizar): ');readln(codABorrar);
    end;
end;

// Algoritmo de alta de registros utilizando técnica de listas invertidas
procedure e(var b:binario);
var
    nuevoR,aux : registroIndumentaria;
    nLibre : integer;
begin
    leerRegistroAIngresar(nuevoR);
    if(nuevoR.cod <> valorInvalidoCod)then
    begin
        seek(b,0);
        read(b,aux);
        if(aux.stock = valorNoExistenRegistrosLibres)then
        begin
            seek(b,filesize(b));
        end
        else
        begin
            nLibre := aux.stock;
            seek(b,nLibre);
            read(b,aux);
            seek(b,0);
            write(b,aux);
            seek(b,nLibre);
        end;
        write(b,nuevoR);
    end
    else
    begin
        writeln('El valor del codigo ingresado no es valido')
    end;
end;

// Generación de archivo binario a partir del txt
// teniendo en cuenta que se utilizará listas invertidas
procedure f(var t:text;var b:binario);
var
    aux : registroIndumentaria;
begin
    reset(t);
    rewrite(b);
    aux.cod := valorInvalidoCod;
    aux.stock := valorNoExistenRegistrosLibres;
    write(b,aux);
    while(not eof(t))do
    begin
        readln(t,aux.cod,aux.stock,aux.nombre);
        readln(t,aux.descripcion);
        write(b,aux);
    end;
end;

begin
end.

{
g) Enumere ventajas que encuentra entre agregar y eliminar indumentaria con o sin
utilización de la técnica de recuperación de espacio libre

- Sin listas invertidas -

Ventajas: 

Facil implementacion

Desventajas:

Se pierde mucho espacio


- Listas invertidas -

Ventajas:

Se reutiliza el espacio

Desventajas:

Algoritmos más complejos 

}