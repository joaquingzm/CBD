
Program ejercicio06;

Type 

    libro =   Record
        ISBN:   string;
        titulo:   string;
        anioEd:   string;
        editorial:   string;
        genero:   string;

    End;

    archivoLibro =   file Of libro;

Function libroToString(l:libro):   string;
Begin
    libroToString := 'ISBN: '+l.ISBN
                     +', Título: '+l.titulo
                     +', Año de edición: '+ l.anioEd
                     +', Editorial: '+l.editorial
                     +', Género: '+l.genero;
End;

Procedure listarLibros(Var aL:archivoLibro);

Var 
    auxL:   libro;
Begin
    reset(aL);
    While (Not eof(aL)) Do
        Begin
            read(al,auxL);
            writeln(libroToString(auxL));
        End;
    close(aL);
End;

Procedure pasarLibroTxtALibroBin(Var aLTxt:text;Var l:libro);

Var 
    auxStr:   string;
Begin

    readln(alTxt,auxStr);
    l.ISBN := copy(auxStr,1,13);
    l.titulo := copy(auxStr,14,length(auxStr));
    readln(alTxt,auxStr);
    l.anioEd := copy(auxStr,1,4);
    l.editorial := copy(auxStr,5,length(auxStr));
    readln(alTxt,auxStr);
    l.genero := auxStr;

End;

Procedure pasarTxtABin(Var alTxt:text;Var al:archivoLibro);

Var 
    auxStr:   string;
    auxL:   libro;
Begin
    reset(alTxt);

    rewrite(aL);
    While (Not eof(alTxt)) Do
        Begin
            pasarLibroTxtALibroBin(alTxt,auxL);
            write(aL,auxL);
        End;

    close(alTxt);
End;

Procedure ingresarLibro(Var l:libro);

Var 
    auxStr:   string;

Begin

    write('Ingresar ISBN: ');
    readln(auxStr);
    l.ISBN := auxStr;
    write('Ingresar titulo: ');
    readln(auxStr);
    l.titulo := auxStr;
    write('Ingresar año de edición: ');
    readln(auxStr);
    l.anioEd := auxStr;
    write('Ingresar editorial: ');
    readln(auxStr);
    l.editorial := auxStr;
    write('Ingresar género: ');
    readln(auxStr);
    l.genero := auxStr;

End;


Procedure agregarLibro(Var aL:archivoLibro);

Var 
    auxL:   libro;
Begin
    reset(aL);
    seek(aL,filesize(aL));
    ingresarLibro(auxL);
    write(aL,auxL);
    close(aL);
End;


Procedure modificarLibro(Var aL:archivoLibro);

Var 
    auxStr:   string;
    auxL:   libro;
    seEncontro:   boolean;
Begin
    seEncontro := false;
    write('Ingresar ISBN: ');
    readln(auxStr);
    reset(aL);
    While (Not eof(aL)) And (Not seEncontro) Do
        Begin
            read(aL,auxL);
            If (auxL.ISBN = auxStr)Then
                Begin
                    seEncontro := true;
                    writeln('Se encontró el libro, ingrese los nuevos datos');
                    ingresarLibro(auxL);
                    writeln(libroToString(auxL));
                    seek(aL,filepos(aL)-1);
                    write(aL,auxL);
                End;
        End;
    If (Not seEncontro)Then writeln('No se encontró un libro con ese ISBN');
    close(aL);
End;

Var 

    salir:   boolean;
    aLTxt:   text;
    aL:   archivoLibro;
    eleccion:   string;
Begin

    assign(aLTxt,'ejercicio06.txt');
    assign(aL,'ejercicio06.dat');

    pasarTxtABin(aLTxt,aL);

    Repeat
        salir := false;
        Begin
            writeln('Opciones:');
            writeln('1) Agregar libro');
            writeln('2) Modificar libro');
            writeln('3) Listar libros');
            writeln('4) Terminar proceso');

            readln(eleccion);

            Case eleccion Of 
                '1':   agregarLibro(aL);
                '2':   modificarLibro(aL);
                '3':   listarLibros(aL);
                '4':   salir := true;
                Else
                    writeln('Por favor, elija una opción válida.');
            End;
        End;
    Until (salir);

End.
