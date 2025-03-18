
Program generarArchivos;

Uses sysutils;

Type 
    regDet =   Record
        codEmp:   string[10];
        fechaVac:   string[10];
        cantDias:   integer;
    End;

    regMae =   Record
        codEmp:   string[10];
        nombreYApellido:   string[30];
        fechaNa:   string[10];
        direccion:   string[50];
        cantHijos:   integer;
        telefono:   string[15];
        cantDiasCorresp:   integer;
    End;

    detalle =   file Of regDet;
    maestro =   file Of regMae;

Procedure crearArchivoDetalle(nombre: String);

Var 
    f:   detalle;
    r:   regDet;
    i:   integer;
Begin
    assign(f, nombre);
    rewrite(f);
    For i := 1 To 5 Do
        Begin
            Str(i, r.codEmp);
            r.fechaVac := '2025-03-18';
            r.cantDias := 2 + i;
            write(f, r);
        End;
    close(f);
End;

Procedure crearArchivoMaestro(nombre: String);

Var 
    f:   maestro;
    r:   regMae;
    i:   integer;
Begin
    assign(f, nombre);
    rewrite(f);
    For i := 1 To 10 Do
        Begin
            Str(i, r.codEmp);
            r.nombreYApellido := 'Empleado ' + chr(48 + i);
            r.fechaNa := '1990-01-01';
            r.direccion := 'Calle ' + chr(48 + i);
            r.cantHijos := i Mod 3;
            r.telefono := '123456789';
            r.cantDiasCorresp := 15 + (i Mod 5);
            write(f, r);
        End;
    close(f);
End;

Var 
    i:   integer;
    nombreArchivo:   string;

Begin
    For i := 1 To 10 Do
        Begin
            nombreArchivo := 'archivoDetalles' + (IntToStr(i));
            crearArchivoDetalle(nombreArchivo);
        End;
    crearArchivoMaestro('archivoMaestro');
    writeln('Archivos generados correctamente.');
End.
