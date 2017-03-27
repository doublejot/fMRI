function get_con_images_2nd_level(directorioGrupo,k)

[mainfolder] = spm_select('FPList',directorioGrupo,'dir');
a = '\';
mainfolder = strcat(mainfolder,a);


%Select all the EPI folders

dirsuj = cellstr(mainfolder);
lengthsuj = size(dirsuj);
lengthsuj = lengthsuj(1);

imagecon = '';
imagecon= {imagecon};

%Con despike_6mm
imageC6_Mvcsf = '';
imageC6_Mvcsf ={imageC6_Mvcsf};
imageC6_Global = '';
imageC6_Global = {imageC6_Global};
imageC6_Phys = '';
imageC6_Phys = {imageC6_Phys};
imageC6_All = '';
imageC6_All = {imageC6_All};


%Con despike_8mm
imageC8_Mvcsf = '';
imageC8_Mvcsf = {imageC8_Mvcsf};
imageC8_Global = '';
imageC8_Global = {imageC8_Global};
imageC8_Phys = '';
imageC8_Phys = {imageC8_Phys};
imageC8_All = '';
imageC8_All = {imageC8_All};

%Con despike_10mm
imageC10_Mvcsf = '';
imageC10_Mvcsf = {imageC10_Mvcsf};
imageC10_Global = '';
imageC10_Global = {imageC10_Global};
imageC10_Phys = '';
imageC10_Phys = {imageC10_Phys};
imageC10_All = '';
imageC10_All = {imageC10_All};

%Con despike_12mm
imageC12_Mvcsf = '';
imageC12_Mvcsf = {imageC12_Mvcsf};
imageC12_Global = '';
imageC12_Global = {imageC12_Global};
imageC12_Phys = '';
imageC12_Phys = {imageC12_Phys};
imageC12_All = '';
imageC12_All = {imageC12_All};

%Sin despike_6mm
imageS6_Mvcsf = '';
imageS6_Mvcsf ={imageS6_Mvcsf};
imageS6_Global = '';
imageS6_Global = {imageS6_Global};
imageS6_Phys = '';
imageS6_Phys = {imageS6_Phys};
imageS6_All = '';
imageS6_All = {imageS6_All};

%Sin despike_8mm
imageS8_Mvcsf = '';
imageS8_Mvcsf = {imageS8_Mvcsf};
imageS8_Global = '';
imageS8_Global = {imageS8_Global};
imageS8_Phys = '';
imageS8_Phys = {imageS8_Phys};
imageS8_All = '';
imageS8_All = {imageS8_All};

%Sin despike_10mm
imageS10_Mvcsf = '';
imageS10_Mvcsf = {imageS10_Mvcsf};
imageS10_Global = '';
imageS10_Global = {imageS10_Global};
imageS10_Phys = '';
imageS10_Phys = {imageS10_Phys};
imageS10_All = '';
imageS10_All = {imageS10_All};

%Sin despike_12mm
imageS12_Mvcsf = '';
imageS12_Mvcsf = {imageS12_Mvcsf};
imageS12_Global = '';
imageS12_Global = {imageS12_Global};
imageS12_Phys = '';
imageS12_Phys = {imageS12_Phys};
imageS12_All = '';
imageS12_All = {imageS12_All};


for i = 1:lengthsuj
folder = dirsuj{i,1}; 
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

%Select all the Con images for the second analysis
%--------------------------------------------------------------------------
%Mv_WM+CSF regressors with despiked images
folCon6_1 = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm\1st_level_Mv_wmcsf_Regressor');
imagec6_1 = spm_select('FPList',folCon6_1,'^con.*\.nii');
imageC6_Mvcsf{i,:} = imagec6_1;

folCon8_1 = strcat(folEPI,'\','\Preproc_con_despike\Suavizado8mm\1st_level_Mv_wmcsf_Regressor');
imagec8_1 = spm_select('FPList',folCon8_1,'^con.*\.nii');
imageC8_Mvcsf{i,:} = imagec8_1;

folCon10_1 = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm\1st_level_Mv_wmcsf_Regressor');
imagec10_1 = spm_select('FPList',folCon10_1,'^con.*\.nii');
imageC10_Mvcsf{i,:} = imagec10_1;

folCon12_1 = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm\1st_level_Mv_wmcsf_Regressor');
imagec12_1 = spm_select('FPList',folCon12_1,'^con.*\.nii');
imageC12_Mvcsf{i,:} = imagec12_1;


%Mv_WM+CSF+GlobalSignal regressors with despiked images
folCon6_2 = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm\1st_level_Mv_wmcsf_global_Regressor');
imagec6_2 = spm_select('FPList',folCon6_2,'^con.*\.nii');
imageC6_Global{i,:} = imagec6_2;

folCon8_2 = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm\1st_level_Mv_wmcsf_global_Regressor');
imagec8_2 = spm_select('FPList',folCon8_2,'^con.*\.nii');
imageC8_Global{i,:} = imagec8_2;

folCon10_2 = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm\1st_level_Mv_wmcsf_global_Regressor');
imagec10_2 = spm_select('FPList',folCon10_2,'^con.*\.nii');
imageC10_Global{i,:} = imagec10_2;

folCon12_2 = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm\1st_level_Mv_wmcsf_global_Regressor');
imagec12_2 = spm_select('FPList',folCon12_2,'^con.*\.nii');
imageC12_Global{i,:} = imagec12_2;


%Mv_WM+CSF+Phyios regressors with despiked images
folCon6_3 = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm\Mv_wmcsf_physio_Regressor');
imagec6_3 = spm_select('FPList',folCon6_3,'^con.*\.nii');
imageC6_Phys{i,:} = imagec6_3;

folCon8_3 = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm\Mv_wmcsf_physio_Regressor');
imagec8_3 = spm_select('FPList',folCon8_3,'^con.*\.nii');
imageC8_Phys{i,:} = imagec8_3;

folCon10_3 = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm\Mv_wmcsf_physio_Regressor');
imagec10_3 = spm_select('FPList',folCon10_3,'^con.*\.nii');
imageC10_Phys{i,:} = imagec10_3;

folCon12_3 = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm\Mv_wmcsf_physio_Regressor');
imagec12_3 = spm_select('FPList',folCon12_3,'^con.*\.nii');
imageC12_Phys{i,:} = imagec12_3;


%All regressors with despiked images
folCon6_4 = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm\All_Regressors');
imagec6_4 = spm_select('FPList',folCon6_4,'^con.*\.nii');
imageC6_All{i,:} = imagec6_4;

folCon8_4 = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm\All_Regressors');
imagec8_4 = spm_select('FPList',folCon8_4,'^con.*\.nii');
imageC8_All{i,:} = imagec8_4;

folCon10_4 = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm\All_Regressors');
imagec10_4 = spm_select('FPList',folCon10_4,'^con.*\.nii');
imageC10_All{i,:} = imagec10_4;

folCon12_4 = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm\All_Regressors');
imagec12_4 = spm_select('FPList',folCon12_4,'^con.*\.nii');
imageC12_All{i,:} = imagec12_4;

%_________________________________________________________________________%

%%Mv_WM+CSF regressors with NOT despiked images
folSon6_1 = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm\1st_level_Mv_wmcsf_Regressor');
images6_1 = spm_select('FPList',folSon6_1,'^con.*\.nii');
imageS6_Mvcsf{i,:} = images6_1;

folSon8_1 = strcat(folEPI,'\','\Preproc_sin_despike\Suavizado8mm\1st_level_Mv_wmcsf_Regressor');
images8_1 = spm_select('FPList',folSon8_1,'^con.*\.nii');
imageS8_Mvcsf{i,:} = images8_1;

folSon10_1 = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm\1st_level_Mv_wmcsf_Regressor');
images10_1 = spm_select('FPList',folSon10_1,'^con.*\.nii');
imageS10_Mvcsf{i,:} = images10_1;

folSon12_1 = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm\1st_level_Mv_wmcsf_Regressor');
images12_1 = spm_select('FPList',folSon12_1,'^con.*\.nii');
imageS12_Mvcsf{i,:} = images12_1;


%Mv_WM+CSF+GlobalSignal regressors with NOT despiked images
folSon6_2 = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm\1st_level_Mv_wmcsf_global_Regressor');
images6_2 = spm_select('FPList',folSon6_2,'^con.*\.nii');
imageS6_Global{i,:} = images6_2;

folSon8_2 = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm\1st_level_Mv_wmcsf_global_Regressor');
images8_2 = spm_select('FPList',folSon8_2,'^con.*\.nii');
imageS8_Global{i,:} = images8_2;

folSon10_2 = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm\1st_level_Mv_wmcsf_global_Regressor');
images10_2 = spm_select('FPList',folSon10_2,'^con.*\.nii');
imageS10_Global{i,:} = images10_2;


%Mv_WM+CSF+Phyios regressors with NOT despiked images
folSon6_3 = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm\Mv_wmcsf_physio_Regressor');
images6_3 = spm_select('FPList',folSon6_3,'^con.*\.nii');
imageS6_Phys{i,:} = images6_3;

folSon8_3 = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm\Mv_wmcsf_physio_Regressor');
images8_3 = spm_select('FPList',folSon8_3,'^con.*\.nii');
imageS8_Phys{i,:} = images8_3;

folSon10_3 = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm\Mv_wmcsf_physio_Regressor');
images10_3 = spm_select('FPList',folSon10_3,'^con.*\.nii');
imageS10_Phys{i,:} = images10_3;

folSon12_3 = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm\Mv_wmcsf_physio_Regressor');
images12_3 = spm_select('FPList',folSon12_3,'^con.*\.nii');
imageS12_Phys{i,:} = images12_3;


%All regressors with NOT despiked images
folSon6_4 = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm\All_Regressors');
images6_4 = spm_select('FPList',folSon6_4,'^con.*\.nii');
imageS6_All{i,:} = images6_4;

folSon8_4 = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm\All_Regressors');
images8_4 = spm_select('FPList',folSon8_4,'^con.*\.nii');
imageS8_All{i,:} = images8_4;

folSon10_4 = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm\All_Regressors');
images10_4 = spm_select('FPList',folSon10_4,'^con.*\.nii');
imageS10_All{i,:} = images10_4;

folSon12_4 = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm\All_Regressors');
images12_4 = spm_select('FPList',folSon12_4,'^con.*\.nii');
imageS12_All{i,:} = images12_4;

end


cd(folEPI);
cd ..
cd ..
cd ..
mkdir(['lista imagenes con para 2 level\Grupo ' num2str(k)'])
 a = cd;
 b = strcat([a,'\lista imagenes con para 2 level\Grupo ' num2str(k)']);

 cd(b);

save('imageC6_Mvcsf.mat','imageC6_Mvcsf');
save('imageC8_Mvcsf.mat','imageC8_Mvcsf');
save('imageC10_Mvcsf.mat','imageC10_Mvcsf');
save('imageC12_Mvcsf.mat','imageC12_Mvcsf');
save('imageC6_Global.mat','imageC6_Global');
save('imageC8_Global.mat','imageC8_Global');
save('imageC10_Global.mat','imageC10_Global');
save('imageC12_Global.mat','imageC12_Global');
save('imageC6_Phys.mat','imageC6_Phys');
save('imageC8_Phys.mat','imageC8_Phys');
save('imageC10_Phys.mat','imageC10_Phys');
save('imageC12_Phys.mat','imageC12_Phys');
save('imageC6_All.mat','imageC6_All');
save('imageC8_All.mat','imageC8_All');
save('imageC10_All.mat','imageC10_All');
save('imageC12_All.mat','imageC12_All');


save('imageS6_Mvcsf.mat','imageS6_Mvcsf');
save('imageS8_Mvcsf.mat','imageS8_Mvcsf');
save('imageS10_Mvcsf.mat','imageS10_Mvcsf');
save('imageS12_Mvcsf.mat','imageS12_Mvcsf');
save('imageS6_Global.mat','imageS6_Global');
save('imageS8_Global.mat','imageS8_Global');
save('imageS10_Global.mat','imageS10_Global');
save('imageS12_Global.mat','imageS12_Global');
save('imageS6_Phys.mat','imageS6_Phys');
save('imageS8_Phys.mat','imageS8_Phys');
save('imageS10_Phys.mat','imageS10_Phys');
save('imageS12_Phys.mat','imageS12_Phys');
save('imageS6_All.mat','imageS6_All');
save('imageS8_All.mat','imageS8_All');
save('imageS10_All.mat','imageS10_All');
save('imageS12_All.mat','imageS12_All');


end