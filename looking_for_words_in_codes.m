function looking_for_words_in_codes()
carpeta = 'C:\Users\molano\ETIC\';
a = dir([carpeta '*.m']);


funcion = 'other_pixels';
funcion_shown = 0;
for ind2=1:numel(a)
    candidato = a(ind2).name;
    [fileID,~] = fopen([carpeta candidato]);
    d = textscan(fileID,'%s','Delimiter','\n');
    aux = strfind(d{1},funcion(1:end-2));
    aux_comment = strfind(d{1},'%');
    aux = cellfun(@isempty,aux);
    aux_comment = cellfun(@isempty,aux_comment);
    if nnz(~aux)>0 && ~isequal(candidato,funcion)
        if ~funcion_shown
            display('oooooooooooooooooooooooooooooooooo')
            display(['function: ' funcion ' is called in:'])
            funcion_shown = 1;
        end
        display(['-------' candidato])
    end
    fclose(fileID);
end

display('done')
