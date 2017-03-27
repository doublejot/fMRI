function [acquorder,mv_parameter,Filt,smooth,fisios] = initial_questions

%--------------------------------------------------------------------------

uiwait (msgbox({'Introduce el orden en que se adquirieron los cortes ("slice order")' '' 'Ejemplos:' 'Ascending' 'Descending' 'InterleavedEven' 'InterleavedOdd' '(Escribir igual que los ejemplos)'},'Preprocessing fMRI'));
prompt = 'Orden: ';
acquorder = inputdlg(prompt);
%--------------------------------------------------------------------------

uiwait (msgbox({'¿Cuántos parámetros de realineamiento usar? 6, 12 ó 24' },'Preprocessing fMRI')) 
prompt = '6, 12, 24: ';
mv_parameter = inputdlg(prompt);
mv_parameter = mv_parameter{1};
mv_parameter = str2double(mv_parameter);
%--------------------------------------------------------------------------

uiwait (msgbox({'Introduce el filtro de paso alto a aplicar' '' 'Para imágenes muy ruidosas = 1' 'Para resting state o diseño de bloques = 2' 'No aplicar filtro = 3' 'Diseño de eventos = 4'},'Preprocessing fMRI'));
prompt = 'Filtro: ';
Filt = inputdlg(prompt);
Filt = Filt{1};
Filt = str2double(Filt);
%--------------------------------------------------------------------------

uiwait (msgbox({'Introduce el/los suavizados separados por espacios' '(e.g.,6 8 10)'},'Preprocessing fMRI'));
prompt = 'Suavizado: ';
smooth = inputdlg(prompt);
%--------------------------------------------------------------------------

uiwait (msgbox('¿Desea eliminar el efecto de otras variables fisiológicas sobre la señal BOLD?', 'Preprocessing fMRI'));
prompt = 'Y / N';
fisios = inputdlg(prompt);
%--------------------------------------------------------------------------


end