{
    TIPO DE EJERCICIO : ACTUALIZACIÓN DE ARCHIVOS-MAESTRO/DETALLE

Este programa implementa un algoritmo que permite actualizar la información de un 
archivo maestro a partir de múltiples detalles. 
}

Program ejercicio01;

Uses sysutils;

Const valorAlto =   '9999';

Type 

    regDet =   Record
        codEmp:   string;
        fechaVac:   string;
        cantDias:   integer;
    End;

    regMae =   Record
        codEmp:   string;
        nombreYApellido:   string;
        fechaNa:   string;
        direccion:   string;
        cantHijos:   integer;
        telefono:   string;
        cantDiasCorresp:   integer;
    End;

    maestro =   file Of regMae;
    detalle =   file Of regDet;
    arDet =   array[1..10] Of detalle;
    arRegDet =   array[1..10] Of regDet;



Procedure leer(Var d:detalle;Var rD:regDet);
Begin
    If (Not eof(d))Then
        Begin
            read(d,rD);
        End
    Else
        Begin
            rD.codEmp := valorAlto;
        End;
End;

Procedure iniciarArchivos(Var m:maestro;Var aD:arDet;Var aRD:arRegDet);

Var 
    auxRD:   regDet;
    i:   integer;
Begin

    assign(m,'archivoMaestro.dat');
    reset(m);

    For i:=1 To 10 Do
        Begin
            assign(aD[i],('archivoDetalles'+(IntToStr(i)))+'.dat');
            reset(aD[i]);
            leer(aD[i],auxRD);
            aRD[i] := auxRD;

        End;
End;

Procedure cerrarArchivos(Var m:maestro;Var aD:arDet;Var aRD:arRegDet);

Var 
    i:   integer;
Begin
    close(m);
    For i:=1 To 10 Do
        Begin
            close(aD[i]);
        End;
End;

Procedure minimo(Var aD:arDet;Var aRD:arRegDet;Var min:regDet);

Var 
    posMin,i:   integer;
Begin
    posMin := 1;
    min := aRD[1];
    For i:=2 To 10 Do
        Begin
            If (aRD[i].codEmp<min.codEmp)Then
                Begin
                    min := aRD[i];
                    posmin := i;
                End;
        End;
    leer(aD[posMin],aRD[posMin]);

End;


Var 
    mae:   maestro;
    aD:   arDet;
    informe:   text;
    aRegD:   arRegDet;
    min:   regDet;
    auxRegMae:   regMae;

Begin

    iniciarArchivos(mae,aD,aRegD);
    assign(informe,'informe.txt');
    rewrite(informe);

    minimo(aD,aRegD,min);
    While (min.codEmp<>valorAlto) Do
        Begin

            while (not eof(mae)) do
                Begin
                    read(mae,auxRegMae);
                    if (auxRegMae.codEmp=min.codEmp) then break;
                End;

            If (auxRegMae.codEmp=min.codEmp)Then
                Begin
                    If (auxRegMae.cantDiasCorresp >= min.cantDias)Then
                        Begin
                            auxRegMae.cantDiasCorresp := auxRegMae.cantDiasCorresp - min.cantDias;

                            // Lo comento porque sino cada vez que corro el programa se modifica el contenido
                            // del archivo maestro y terminan todos pidiendo más días de los que tienen
                            
                            //seek(mae,filepos(mae)-1);
                            //write(mae,auxRegMae);

                            seek(mae, filepos(mae)-1);
                        End
                    Else
                        Begin
                            writeln(informe,
                                    'Codigo de empleado: '+min.codEmp
                                    +', Nombre y apellido: '+ auxRegMae.nombreYApellido
                                    +', Cantidad de días disponibles: ' +(IntToStr(auxRegMae.cantDiasCorresp))
                                    +', Cantidad de días que solicita: '+(IntToStr(min.cantDias)));
                        End;
                End;
            minimo(aD,aRegD,min);
        End;
    close(informe);
    cerrarArchivos(mae,aD,aRegD);

End.
