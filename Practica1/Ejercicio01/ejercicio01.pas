
Program ejercicio01;

Var 
    nombreLogico:   text;
    nombreArchivo:   string;
    materialConstruccion:   string;
Begin
    write('Ingrese el nombre del archivo: ');
    readln(nombreArchivo);

    assign(nombreLogico,nombreArchivo+'.txt');
    rewrite(nombreLogico);

    Repeat
        Begin

            write('Ingrese el nombre del material de construccion: ');
            readln(materialConstruccion);
            writeln(nombreLogico,materialConstruccion);

        End;
    Until (materialConstruccion = 'cemento');

    writeln('Saliste del loop');
    close(nombreLogico);
End.
