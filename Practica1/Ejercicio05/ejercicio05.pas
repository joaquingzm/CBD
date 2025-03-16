
Program ejercicio05;

Uses sysutils;

Type 

    registroFlor =   Record
        nroEspecie:   integer;
        maxAltura:   real;
        nombreCientifico:   string;
        nombreVulgar:   string;
        color:   string;
    End;

    archivoRegistrosDeFlores =   file Of registroFlor;

Function cargarRegistroFlor(Var rF:registroFlor):   integer;

Var 

    integerAux:   integer;
    stringAux:   string;
    realAux:   real;

Begin
    write('Nombre científico: ');
    readln(stringAux);
    If (stringAux = 'zzz')Then
        Begin
            cargarRegistroFlor := 1;
            exit;
        End;
    rF.nombreCientifico := stringAux;

    write('Nro de especie: ');
    readln(integerAux);
    rF.nroEspecie := integerAux;

    write('Altura máxima: ');
    readln(realAux);
    rF.maxAltura := realAux;

    write('Nombre vulgar: ');
    readln(stringAux);
    rF.nombreVulgar := stringAux;

    write('Color: ');
    readln(stringAux);
    rF.color := stringAux;

    cargarRegistroFlor := 0;
End;


Procedure cargarRegistrosDeFlores(Var archivoRegistroFlores:archivoRegistrosDeFlores;reescribir:boolean);

Var 
    auxRF:   registroFlor;
Begin
    If (reescribir)Then rewrite(archivoRegistroFlores)
    Else
        Begin
            reset(archivoRegistroFlores);
            seek(archivoRegistroFlores,filesize(archivoRegistroFlores));
        End;
    While (cargarRegistroFlor(auxRF) = 0) Do
        Begin
            write(archivoRegistroFlores,auxRF);
        End;
    close(archivoRegistroFlores);

End;

Function registroFlorToString(rF:registroFlor):   string;

Var 
    auxString:   string;
Begin
    auxString :=   'Nro Especie: '+IntToStr(rF.nroEspecie)+
                 ', Altura máxima: '+FloatToStr(rf.maxAltura)+
                 ', Nombre científico: '+rf.nombreCientifico+
                 ', Nombre vulgar: '+rf.nombreVulgar+
                 ', Color: '+rf.color;
    registroFlorToString := auxString;
End;


Procedure listarRegistrosDeFlores(Var archivoRegistroFlores:archivoRegistrosDeFlores);

Var 
    auxRF:   registroFlor;
Begin
    reset(archivoRegistroFlores);
    While (Not eof(archivoRegistroFlores)) Do
        Begin
            read(archivoRegistroFlores,auxRF);
            writeln(registroFlorToString(auxRF));
        End;
    close(archivoRegistroFlores);
End;

Procedure listarRegistrosDeFloresATexto(Var archivoRegistroFlores:archivoRegistrosDeFlores);

Var 
    auxRF:   registroFlor;
    archivoRFTxt:   text;
Begin
    assign(archivoRFTxt,'flores.txt');
    rewrite(archivoRFTxt);
    reset(archivoRegistroFlores);
    While (Not eof(archivoRegistroFlores)) Do
        Begin
            read(archivoRegistroFlores,auxRF);
            writeln(archivoRFTxt,registroFlorToString(auxRF));
        End;
    close(archivoRegistroFlores);
    close(archivoRFTxt);
End;


Procedure reportarCantMinMaxAltura(Var archivoRegistroFlores:archivoRegistrosDeFlores);

Var 
    minAltura,maxAltura,auxRF:   registroFlor;
    cant:   integer;
Begin
    minAltura.maxAltura := 9999;
    maxAltura.maxAltura := 0;
    cant := 0;
    reset(archivoRegistroFlores);
    While (Not eof(archivoRegistroFlores)) Do
        Begin
            read(archivoRegistroFlores,auxRF);
            cant :=   cant + 1;
            If (auxRF.maxAltura>maxAltura.maxAltura)Then maxAltura := auxRF;
            If (auxRF.maxAltura<minAltura.maxAltura)Then minAltura := auxRF;
        End;
    writeln('Cantidad total de especies: '+IntToStr(cant));
    writeln('Especie de menor altura: '+registroFlorToString(minAltura));
    writeln('Especie de mayor altura: '+registroFlorToString(maxAltura));
End;

Procedure modificarNombreCientifico(Var archivoRegistroFlores:archivoRegistrosDeFlores);

Var 
    auxRF:   registroFlor;
    auxString:   string;
Begin
    write('Indique el nombre cientifico de la especie a cambiar: ');
    readln(auxString);
    reset(archivoRegistroFlores);
    While (Not eof(archivoRegistroFlores)) Do
        Begin
            read(archivoRegistroFlores,auxRF);
            If (auxRF.nombreCientifico = auxString)Then
                Begin
                    write('Indique el nuevo nombre cientifico: ');
                    readln(auxString);
                    auxRF.nombreCientifico := auxString;
                    seek(archivoRegistroFlores,Filepos(archivoRegistroFlores)-1);
                    write(archivoRegistroFlores,auxRF);
                End;
        End;
    close(archivoRegistroFlores);
End;


Var 
    archivoRegistroFlores:   archivoRegistrosDeFlores  ;
    eleccion:   string;
    salir:   Boolean;
Begin

    assign(archivoRegistroFlores,'ejercicio05.dat');
    writeln('Carga de registros de flores');
    cargarRegistrosDeFlores(archivoRegistroFlores,true);

    Repeat
        salir := false;
        Begin
            writeln('Opciones:');
            writeln('1) Reportar cantidad total de especies, especie de menor y mayor altura');
            writeln('2) Listar flores');
            writeln('3) Modificar nombre cientifico de alguna especie');
            writeln('4) Añadir una o más especies');
            writeln('5) Listar contenido a un txt');
            writeln('6) Terminar proceso');

            readln(eleccion);

            Case eleccion Of 
                '1':   reportarCantMinMaxAltura(archivoRegistroFlores);
                '2':   listarRegistrosDeFlores(archivoRegistroFlores);
                '3':   modificarNombreCientifico(archivoRegistroFlores);
                '4':   cargarRegistrosDeFlores(archivoRegistroFlores,false);
                '5':   listarRegistrosDeFloresATexto(archivoRegistroFlores);
                '6':   salir := true;
                Else
                    writeln('Por favor, elija una opción válida.');
            End;
        End;
    Until (salir);
End.
