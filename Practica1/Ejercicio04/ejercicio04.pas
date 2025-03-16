
Program ejercicio04;

Type 
    archivoDeNumeros =   file Of integer;

Function convertirIntAString(nro:integer):   string;

Var 
    resto:   integer;
    aux:   string;
Begin

    aux := '';

    If (nro = 0)Then
        Begin
            convertirIntAString := '0';
            exit;
        End;
    While (nro <> 0) Do
        Begin
            resto := nro Mod 10;
            nro :=   nro Div 10;

            Case resto Of 
                0:   aux :=   '0' + aux;
                1:   aux :=   '1' + aux;
                2:   aux :=   '2' + aux;
                3:   aux :=   '3' + aux;
                4:   aux :=   '4' + aux;
                5:   aux :=   '5' + aux;
                6:   aux :=   '6' + aux;
                7:   aux :=   '7' + aux;
                8:   aux :=   '8' + aux;
                9:   aux :=   '9' + aux;

            End;
        End;
    convertirNroAString := aux;
End;




Procedure archivosNrosATexto(Var archivoNros:archivoDeNumeros;Var archivoTexto:text);

Var 
    aux:   integer;
Begin
    reset(archivoNros);
    rewrite(archivoTexto);
    While (Not eof(archivoNros)) Do
        Begin
            read(archivoNros,aux);
            writeln(archivoTexto,convertirNroAString(aux));
        End;
    close(archivoNros);
    close(archivoTexto);
End;


Var 
    archivoNros:   archivoDeNumeros;
    archivoTexto:   text;

Begin
    assign(archivoNros,'../Ejercicio02/ejercicio02.dat');
    assign(archivoTexto,'ejercicio04.txt');
    archivosNrosATexto(archivoNros,archivoTexto);
End.
