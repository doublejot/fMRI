clc
clear all

directorio = uigetdir;

[mainfolder] = spm_select('FPList',directorio,'dir'); %poner que el filtro sea cualquiera
a = '\';
mainfolder = strcat(mainfolder,a);
dirsuj = cellstr(mainfolder);
length = size(dirsuj);
length = length(1);

for l = 1:length
    
    
folder = dirsuj{l,1}; %bucle que vaya cambiando el numero de l, 
                      %que es el numero del sujeto

filesAndFolders = dir(folder);
dircell = struct2cell(filesAndFolders);
a = dircell{1,3};
b = dircell{1,4};


epi1 = regexpi(a,'EPI');
epi2 = regexpi(a,'ep2d');
epi3 = regexpi(b,'EPI');
epi4 = regexpi(b,'ep2d');
t1 = regexpi(a, 'T1');
t2 = regexpi(b, 'T1');

if epi1 >= 1
   folEPI = strcat(folder,a);
end

if epi2 >= 1
   folEPI = strcat(folder,b);
end

if epi3 >= 1
   folEPI = strcat(folder,b);
end

if epi4 >= 1
   folEPI = strcat(folder,b);
end

if t1 >= 1
   folT1 = strcat(folder,a);
end

if t2 >= 1
   folT1 = strcat(folder,b);
end

folT1
folEPI
uiwait (msgbox('hola'));
%aquí es donde va el script del preprocesado
%Poner primero el del movement_ouliers
%Despues el preprocesado completo ya habiendo quitado los sujetos outlier

end
%==========================================================================