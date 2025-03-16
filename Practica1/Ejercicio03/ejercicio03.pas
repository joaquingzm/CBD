program ejercicio03;

var
    archivoTexto:text;
    aux,nombreArchivo:string;

begin
    nombreArchivo:='ejercicio03.txt';

    assign(archivoTexto,nombreArchivo);
    rewrite(archivoTexto);

    writeln('Ingreso de los tipos de dinosaurios que habitaron en Sudamérica');
    repeat
    begin
        
        write('Tipo: ');
        readln(aux);
        if(aux<>'zzz')then writeln(archivoTexto,aux);

    end;
    until(aux = 'zzz');

    close(archivoTexto);
end.