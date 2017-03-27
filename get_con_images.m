function [list_imagecon,mean_peak_value,mainfolder] = get_con_images(directorio)

[mainfolder] = spm_select('FPList',directorio,'dir');
a = '\';
mainfolder = strcat(mainfolder,a);

%Select all the EPI folders

dirsuj = cellstr(mainfolder);
lengthsuj = size(dirsuj);
lengthsuj = lengthsuj(1);

imagecon = '';
imagecon= {imagecon};

for j = 1:lengthsuj
folder = dirsuj{j,1}; 
filesAndFolders = dir(folder);
dircell = struct2cell(filesAndFolders);
a = dircell{1,3};
b = dircell{1,4};

epi1 = regexpi(a,'EPI');
epi2 = regexpi(a,'ep2d');
epi3 = regexpi(b,'EPI');
epi4 = regexpi(b,'ep2d');

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

%Select all the Con images for the function

folCon = strcat(folEPI,'\','\Preproc_sin_despike\Suavizado8mm\1st_level_Mv_wmcsf_Regressor');

imagec = spm_select('FPList',folCon,'^con.*\.nii');
imagecon{j,:} = imagec;

     if strcmp (imagec,'')
         folCon = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm\1st_level_Mv_wmcsf_Regressor');
         imagec = spm_select('FPList',folCon,'^con.*\.nii');
         imagecon{j,:} = imagec;

     elseif strcmp (imagec,'')
         folCon = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm\1st_level_Mv_wmcsf_Regressor');
         imagec = spm_select('FPList',folCon,'^con.*\.nii');
         imagecon{j,:} = imagec;
     end
     
     for pi=1:lengthsuj
         
         Peak = spm_select('FPList',folEPI,'^Peak.*\.txt');
         load(Peak);
         peak_value{pi,:} = Peak_Value_Con;
         
     end
     
         
end

%compute the mean peak value of all subjects

     peaks = [peak_value{:,:}];
     mean_peak_value = mean(peaks)

cd(folEPI)
cd ..
cd ..
save('imagescon.mat','imagecon');
load('imagescon.mat'); %imagecon
list_imagecon = char(imagecon);

% fid=fopen('lista.txt','wt');
% for k = 1:length(imagecon)
%     list = imagecon{k};
%     format = '%s %f -ascii';
%     fprintf(fid,format,imagecon{k,:});
%     format2 = '\n';
%     fprintf(fid,format2);
%     
% end
%     fclose(fid);       



end
