{
    TIPO DE EJERCICIO: MODDIFICACION DE ARCHIVOS CON REGISTROS DE LONGITUD FIJA

En este ejercicio la modificación del archivo se implementa utilizando la técnica
de lista encadenada (o pila), consiste en mantener entrelazados los espacios libres y
al crear un nuevo espacio libre, se cambia el puntero al inicio de la lista para que
apunte al nuevo espacio libre y éste mismo apunta al que era antes el primero de la lista.
}
program ejercicio02;

const 
    valorNoExistenRegistrosLibres = 0;
    valorBorradoCod = -1;

type
    tVehiculo = record
        codigoVehiculo : integer;
        patente : string;
        motor : string;
        cantidadPuertas : integer;
        precio : real;
        descripcion : string;
    end;
    
    tArchivo = file of tVehiculo;


procedure eliminar(var a:tArchivo; codigoV : integer);
var
    nLibre: integer;
    auxV,auxVLibre : tVehiculo;
    sLibre : string;
begin
    seek(a,0);
    // Leo registro encabezado
    read(a,auxV);
    auxVLibre.codigoVehiculo := valorBorradoCod -1;
    // Busco vehículo a eliminar
    while(not eof(a))and(auxVLibre.codigoVehiculo <> codigoV)do read(a,auxVLibre);
    if(auxVLibre.codigoVehiculo = codigoV)then
    begin
        // Si lo encontré, marco su número de registro como número de registro
        // libre
        nLibre := filepos(a) - 1;
        // Escribo el registro encabezado (que tiene el puntero al que era antes
        // el primer registro libre) en el nuevo registro libre
        seek(a,nLibre);
        write(a,auxV);
        // Creo un nuevo registro encabezado que apunté al nuevo registro libre
        str(nLibre,sLibre);
        auxVLibre.descripcion := sLibre;
        auxVLibre.codigoVehiculo := valorBorradoCod; // Marco que el registro no es válido
        // Escribo el nuevo registro encabezado al inicio del archivo
        seek(a,0);
        write(a,auxVLibre);
    end
    else
    begin
        writeln('No existe el vehiculo');
    end;

end;

procedure agregar(var a:tArchivo; nuevoV:tVehiculo);
var
    nLibre : integer;
    sLibre : string;
    auxV : tVehiculo;
begin
    seek(a,0);
    // Leo cabecera 
    read(a,auxV);
    // Veo qué número de registro se encuentra libre
    sLibre := auxV.descripcion;
    val(sLibre,nLibre);
    // Si no hay registros libres, voy al final del archivo
    if(nLibre = valorNoExistenRegistrosLibres)then
    begin
        seek(a,filesize(a));
    end    
    // Si sí hay registros libres hago lo del else:
    else
    begin
        // Leo información del registro libro para ponerlo como nueva cabecera
        seek(a,nLibre);
        read(a,auxV);
        seek(a,0);
        write(a,auxV);
        // Siendo que moví el registro libre de nLibre a 0, me posiciono en nLibre
        // para reescribirlo 
        seek(a,nLibre);
    end;
    // Agrego nuevo registro
    write(a,nuevoV);
end;

begin
end.