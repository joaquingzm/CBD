{
Asumo que la información en el texto viene:

dni sueldo
nombre
apellido

}

program parcial1;

type

    profesional = record
        dni : integer;
        nombre : string;
        apellido : string;
        sueldo : real;
    end;

    tArchivo = File of profesional;

procedure crear(var arch:tArchivo; var info:text);
var
    auxM : profesional;
begin
    reset(info);
    rewrite(arch);

    auxM.dni := 0;

    write(arch,auxM);

    while(not eof(info))do
    begin
        readln(info,auxM.dni,auxM.sueldo);
        readln(info,auxM.nombre);
        readln(info,auxM.apellido);

        write(arch,auxM);

    end;
    close(info);
    close(arch);

end;

procedure agregar(var arch:tArchivo; p:profesional);
var
    auxM : profesional;
    nLibre : integer;
begin
    reset(arch);
    read(arch,auxM);
    nLibre := auxM.dni;
    if(dni>=0)then
    begin
        seek(arch,filesize(arch));
    end
    else
    begin
        seek(arch,-nLibre);
        read(arch,auxM);
        seek(arch,0);
        write(arch,auxM);
        seek(arch,-nLibre);
    end;
    write(arch,p);
    close(arch);
end;

procedure eliminar(var arch:tArchivo; dni:integer; var bajas:text);
var
    auxEncabezado,auxM : profesional;
    nLibre : integer;
begin
    reset(arch);
    append(bajas);

    read(arch,auxEncabezado);
    auxM.dni := -1;

    while(not eof(arch))and(auxM.dni <> dni)do
    begin
        read(arch,auxM);
    end;
    if(auxM.dni = dni)do
    begin

        writeln(bajas,auxM.dni,auxM.sueldo);
        writeln(bajas,auxM.nombre);
        writeln(bajas,auxM.apellido);

        nLibre := filepos(arch) - 1;
        seek(arch,nLibre);
        write(arch,auxEncabezado);
        auxM.dni := -nLibre;
        seek(arch,0);
        write(arch,auxM);
    end
    else
    begin
        writeln('No existe el dni buscado');
    end;

    close(arch);
    close(bajas);
end;