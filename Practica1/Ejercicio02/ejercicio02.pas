
Program ejercicio02;

Type 

    archivoDeNumeros =   file Of integer;


(*
Tengo una duda sobre el tema procedures cuando manejan datos de tipo archivo:
Sucede que en este ejemplo si borro el tipo "archivoDeNumeros" y utilizo "file of integers"
directamente en el procedure y en la declaración de variables me da el siguiente error en
la compilación:

ejercicio02.pas(4,50) Error:   Parameters or result types cannot contain local type definitions. Use a separate
                               Type definition in a Type block.

Por qué es eso?
*)


Procedure cargarNrosArchivo(Var archivoNros: archivoDeNumeros);

Var 
    aux:   integer;

Begin
    rewrite(archivoNros);
    Repeat
        Begin
            Write('Nro ( -1 para salir):');
            readln(aux);
            If (aux >= 0) Then write(archivoNros, aux);
        End;
    Until (aux < 0);
    close(archivoNros);

End;

Var 
    eleccion:   string;
    nombreArchivoNros:   string;
    fileNros:   archivoDeNumeros;
    aux,max,min:   integer;

Begin

    nombreArchivoNros :=   'ejercicio02.dat';
    max :=   0;
    min :=   9999;

    assign(fileNros,nombreArchivoNros);

    Repeat
        Begin
            write('Desea cargar un archivo de votos?(y/n) ');
            readln(eleccion);
        End;
    Until (eleccion = 'y' ) Or (eleccion = 'n');

    If (eleccion = 'y') Then cargarNrosArchivo(fileNros);

    reset(fileNros);

    writeln('Inicio de lectura del archivo');
    While (Not eof(fileNros)) Do
        Begin
            read(fileNros,aux);
            If (aux > max) Then max :=   aux;
            If (aux < min) Then min :=   aux;
            writeln(aux);
        End;
    writeln('Fin de lectura del archivo');

    close(fileNros);
    writeln('Max: ',max);
    writeln('Min: ',min);

End.
