function [directorio,numberofnor] = check_origin 

%Ask me for the subjects directory please

uiwait (msgbox('Recuerda que todos los sujetos deben tener el origen de la imagen T1 en el eje de la comisura anterior', 'Preprocessing fMRI'));

uiwait(msgbox('Selecciona el directorio donde se encuentran los sujetos que vas a analizar','Preprocessing fMRI'));
directorio = uigetdir;
%--------------------------------------------------------------------------

fprintf(['Checkeando si algún sujeto no tiene la imagen reorientada a la comisura anterior... \n ',...
    'Los sujetos que no están reorientados son los siguientes: \n']);

%Get de T1 folder for all the subjects
[mainfolder] = spm_select('FPList',directorio,'dir');
a = '\';
mainfolder = strcat(mainfolder,a);
dirsuj = cellstr(mainfolder);
lengthsuj = size(dirsuj);
lengthsuj = lengthsuj(1);
numberofnor = 0;

for l = 1:lengthsuj
folder = dirsuj{l,1}; 
filesAndFolders = dir(folder);
dircell = struct2cell(filesAndFolders);
a = dircell{1,3};
b = dircell{1,4};

t1 = regexpi(a, 'T1');
t2 = regexpi(b, 'T1');

if t1 >= 1
   folT1 = strcat(folder,a);
end

if t2 >= 1
   folT1 = strcat(folder,b);
end

%--------------------------------------------------------------------------
%Check if all the subjects have the same origin (anterior comissure)

%If you don't change the origin of the image the matrix of 
%mri.niftihdr.sform will must be like this:

%      1     0     0     0
%      0     1     0     0
%      0     0     1     0
%      0     0     0     1

%If you already changed the origin of the image, the matrix of 
%mri.niftihdr.sform will must be like this:

%     0.0246   -0.0834    0.7950  -70.7613
%    -0.7623   -0.1707    0.0060  142.3073
%    -0.1691    0.7578    0.0888 -124.1767
%          0         0         0    1.0000


structural = spm_select('FPList',folT1,'^2.*\.nii');

st_hd = MRIread(structural);

coord = st_hd.niftihdr.sform(1,4);

if coord == 0
   disp(folder)
   numberofnor = 1;
end

%print the subjects that doesn't have the origin at the anterior comissure

end


%--------------------------------------------------------------------------

end