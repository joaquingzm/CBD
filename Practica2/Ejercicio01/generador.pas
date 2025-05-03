Program generadorArchivos;

Uses sysutils;

Type
    regDet = Record
        codEmp: string;
        fechaVac: string;
        cantDias: integer;
    End;

    regMae = Record
        codEmp: string;
        nombreYApellido: string;
        fechaNa: string;
        direccion: string;
        cantHijos: integer;
        telefono: string;
        cantDiasCorresp: integer;
    End;

    maestro = file Of regMae;
    detalle = file Of regDet;

Var 
    m: maestro;
    d: detalle;
    rM: regMae;
    rD: regDet;
    i: integer;

Begin
    // Crear maestro
    assign(m, 'archivoMaestro.dat');
    rewrite(m);

    rM.codEmp := '0002';
    rM.nombreYApellido := 'Juan Perez';
    rM.fechaNa := '1980-05-23';
    rM.direccion := 'Av. Siempre Viva 123';
    rM.cantHijos := 2;
    rM.telefono := '123456789';
    rM.cantDiasCorresp := 5;
    write(m, rM);

    rM.codEmp := '0005';
    rM.nombreYApellido := 'Maria Gomez';
    rM.fechaNa := '1990-02-11';
    rM.direccion := 'Calle Falsa 456';
    rM.cantHijos := 1;
    rM.telefono := '987654321';
    rM.cantDiasCorresp := 15;
    write(m, rM);

    rM.codEmp := '0008';
    rM.nombreYApellido := 'Carlos Ruiz';
    rM.fechaNa := '1985-12-01';
    rM.direccion := 'Boulevard Sol 789';
    rM.cantHijos := 3;
    rM.telefono := '1122334455';
    rM.cantDiasCorresp := 11;
    write(m, rM);

    close(m);

    // Crear detalle 1 con vacaciones
    assign(d, 'archivoDetalles1.dat');
    rewrite(d);

    rD.codEmp := '0005';
    rD.fechaVac := '2024-02-19';
    rD.cantDias := 5;
    write(d, rD);

    rD.codEmp := '0008';
    rD.fechaVac := '2024-01-18';
    rD.cantDias := 4;
    write(d, rD);

    close(d);

    // Crear detalle 2 con otra info de más días pedidos que disponibles
    assign(d, 'archivoDetalles2.dat');
    rewrite(d);

    rD.codEmp := '0002';
    rD.fechaVac := '2024-06-15';
    rD.cantDias := 7;
    write(d, rD);

    close(d);

    // Crear los restantes vacíos
    for i := 3 to 10 do
    begin
        assign(d, 'archivoDetalles' + IntToStr(i) + '.dat');
        rewrite(d);
        close(d);
    end;

    writeln('Archivos generados exitosamente.');
End.
