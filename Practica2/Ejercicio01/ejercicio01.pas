
Program ejercicio01;

Uses sysutils;

Const valorAlto =   9999;

Type 

    regDet =   Record
        codEmp:   string;
        fechaVac:   string;
        cantDias:   integer;
    End;

    regMae =   Record
        codEmp:   string;
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

Procedure iniciarArchivos(Var m:maestro;Var aD:arDet;Var aRD:arRegDet);

Var 
    auxRD:   regDet;

Begin

    assign(m,'archivoMaestro');
    reset(m);

    For i:=1 To 10 Do
        Begin
            assign(aD[i],'archivoDetalles'+i);
            reset(aD[i]);
            leer(aD[i],auxRD);
            aRD[i] := auxRD;

        End;
End;

Procedure cerrarArchivos(Var m:maestro;Var aD:arDet;Var aRD:arRegDet);
Begin
    close(m);
    For i:=1 To 10 Do
        Begin
            close(aD[i]);
        End;
End;

Procedure leer(Var d:detalle;Var rD:regDet);
Begin
    If (Not eof(d))Then read(d,rD)
    Else rD.codEmp := valorAlto;
End;

Procedure minimo(Var aD:arDet;Var aRegD:arRegDet;Var min:detalle);

Var 
    posMin:   int;
Begin
    posMin := 1;
    min := arRegDet[1];
    For i:=2 To 10 Do
        Begin
            If (arRegDet[i]<min.codEmp)Then
                Begin
                    min := arRegDet[i];
                    posmin := i;
                End;
        End;
    leer(aD[posMin],arRegDet[posMin]);

End;


Var 
    mae:   maestro;
    aD:   arDet;
    informe:   text;
    aRegD:   arRegDet;
    auxDet:   detalle;
    auxRegDet,min:   regDet;
    auxRegMae:   regMae;

Begin

    iniciarArchivos(mae,aD,aRegD);

    minimo(aD,aRegD,min);
    While (min.codEmp<>valorAlto) Do
        Begin
            leer(mae,auxRegMae);
            If (auxRegMae.cantDiasCorresp >= min.cantDias)Then
                Begin
                    auxRegMae.cantDiasCorresp := auxRegMae.cantDiasCorresp - min.cantDias;
                    seek(mae,filepos(mae)-1);
                    write(mae,auxRegMae);
                End
            Else
                Begin

                End;
        End;

End.
