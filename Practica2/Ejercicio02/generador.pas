Program generadorCDs;

Uses SysUtils;

Type
    regMae = Record
        codAutor: string;
        nombreAutor: string;
        nombreDisco: string;
        genero: string;
        cantidad: integer;
    End;

    archivoCDs = file of regMae;

Var
    cds: archivoCDs;
    r: regMae;

Procedure agregarCD(cod, autor, disco, gen: string; cant: integer);
Begin
    r.codAutor := cod;
    r.nombreAutor := autor;
    r.nombreDisco := disco;
    r.genero := gen;
    r.cantidad := cant;
    write(cds, r);
End;

Begin
    assign(cds, 'cds.dat');
    rewrite(cds);

    // Autor 0001 - Rock
    agregarCD('0001', 'Los Piojos', 'Ay ay ay', 'Rock', 150);
    agregarCD('0001', 'Los Piojos', 'Verde paisaje del infierno', 'Rock', 120);
    
    // Autor 0001 - Reggae
    agregarCD('0001', 'Los Piojos', 'Ruido', 'Reggae', 80);

    // Autor 0002 - Pop
    agregarCD('0002', 'Fito Páez', 'Circo Beat', 'Pop', 180);
    agregarCD('0002', 'Fito Páez', 'El amor después del amor', 'Pop', 300);

    // Autor 0002 - Rock
    agregarCD('0002', 'Fito Páez', 'Naturaleza sangre', 'Rock', 75);

    // Autor 0003 - Cumbia
    agregarCD('0003', 'Los Palmeras', 'El bombón asesino', 'Cumbia', 500);
    agregarCD('0003', 'Los Palmeras', 'Perra', 'Cumbia', 400);

    close(cds);
    writeln('Archivo cds.dat generado exitosamente.');
End.
