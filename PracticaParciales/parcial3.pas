program parcial3;

type

    registroVenta = record
        codSuc : word;
        idAutor : longword;
        isbn : longword;
        idEj : word;
    end;


    ventas = file of registroVenta;


procedure totalizar(var v:ventas;var s:string);
var
    aux,actual : registroVenta;
    cantL,cantA,cantS,cantC : integer;
    t : text;
begin
    assign(t,s);
    append(t);
    reset(v);

    read(v,aux);
    cantC := 0;
    while(not eof(v))do
    begin
        actual.codSuc := aux.codSuc;
        cantS := 0;
        writeln(t,'Codigo sucursal: ',actual.codSuc);
        while(not eof(v))and(aux.codSuc = actual.codSuc)do
        begin
            actual.idAutor := aux.idAutor;
            cantA := 0;
            writeln(t,'Identificacion de Autor: ',actual.idAutor);
            while(not eof(v))and(aux.codSuc = actual.codSuc)and(aux.idAutor = actual.idAutor)do
            begin
                actual.isbn := aux.isbn;
                cantl := 0;
                while(not eof(v))and(aux.codSuc = actual.codSuc)and(aux.idAutor = actual.idAutor)and(aux.isbn = actual.isbn)do
                begin
                    cantL := cantL + 1;
                    read(m,aux);
                end;
                writeln(t,'ISBN: ',actual.isbn,'. Total de ejemplares vendidos del libro: ',cantL);
                cantA := cantA + cantL;
            end;
            writeln(t,'Total de ejemplares vendidos del autor: ',cantA);
            cantS := cantS + cantA
        end;
        writeln(t,'Total de ejemplares vendidos por la sucursal: ',cantS);
        cantC := cantC + cantS;        
    end;
    writeln(t,'TOTAL DE EJEMPLARES VENDIDOS EN LA CADENA: ',cantC);

    close(v);
    close(t);
end;