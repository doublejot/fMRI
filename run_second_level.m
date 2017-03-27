function run_second_level

clear all
clc

warning('off')

ispar=matlabpool('size');
if ispar == 0;
    matlabpool
end

%Ask for the number of groups in the analysis
uiwait(msgbox('Indica el número de grupos que hay en tu muestra','Second level fMRI'));
prompt = 'Número de Grupos: ';
grupos = inputdlg(prompt);
grupos = grupos{1};
grupos = str2double(grupos);

%Get all the Con images for the analysis
for k = 1:grupos
%   uiwait(msgbox('Selecciona el directorio donde se encuentran los sujetos del grupo','Second level fMRI'));
    directorioGrupo = uigetdir({},['Select the directory for Group ' num2str(k)']);
    get_con_images_2nd_level(directorioGrupo,k)    
end

%Whole brain or ROI analysis?
uiwait(msgbox('¿Quieres hacer el análisis sobre una región en concreto?', 'Second level fMRI'));
prompt = 'Y/N?';
ro = inputdlg(prompt);

Simask = 'Y';
Simask = {Simask};
simask = 'y';
simask = {simask};
Nomask = 'N';
Nomask = {Nomask};
nomask = 'n';
nomask = {nomask};

if strcmp(ro,Nomask) || strcmp(ro,nomask);
    mask = 'C:\Program Files\MATLAB\R2013a\work\spm12\toolbox\FieldMap\brainmask.nii,1';
end

if strcmp(ro,Simask) || strcmp(ro,simask);
%    uiwait(msgbox('Selecciona la máscara a utilizar', 'Second level fMRI'));
    [mask, path] = uigetfile({'*.nii'}, 'Select a mask image *.nii');
     mask = strcat(path,mask);
end

fprintf('%-40s: %30s\n','Initializing Second Level Analysis',spm('time'))
    
%Load the covariates age and gender for the analysis
cd(directorioGrupo);
cd ..
mainfol = cd;
age = spm_select('FPList',mainfol,'^edad.*\.txt');
gender = spm_select('FPList',mainfol,'^gen.*\.txt');
age = load(age);
gender = load(gender);

%Hay 4 tipos de regresores, con 4 tipos de suavizados (16 en total)

if grupos == 2
    folgrp1 = strcat(mainfol,'\lista imagenes con para 2 level\','Grupo 1\');
    folgrp2 = strcat(mainfol,'\lista imagenes con para 2 level\','Grupo 2\');
    mkdir(mainfol,'2nd_level_Results');
    resultfol = strcat(mainfol,'\2nd_level_Results');
    
    %1er analysis: Con despike - 6mm - Mvcsf
    cd(folgrp1)
    load('imageC6_Mvcsf.mat');
    group1= char(imageC6_Mvcsf);
    cd(folgrp2)
    load('imageC6_Mvcsf.mat');
    group2 = char(imageC6_Mvcsf);
    mkdir(resultfol,'2_level_C6_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_C6_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %2º analisis: Con despike - 8mm - Mvcsf
    cd(folgrp1)
    load('imageC8_Mvcsf.mat');
    group1 = char(imageC8_Mvcsf);
    cd(folgrp2)
    load('imageC8_Mvcsf.mat');
    group2 = char(imageC8_Mvcsf);
    mkdir(resultfol,'2_level_C8_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_C8_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %3er analisis:  Con despike - 10mm - Mvcsf
    cd(folgrp1)
    load('imageC10_Mvcsf.mat');
    group1 = char(imageC10_Mvcsf);
    cd(folgrp2)
    load('imageC10_Mvcsf.mat');
    group2 = char(imageC10_Mvcsf);
    mkdir(resultfol,'2_level_C10_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_C10_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %4º analisis: Con despike - 12mm - Mvcsf
    cd(folgrp1)
    load('imageC12_Mvcsf.mat');
    group1 = char(imageC10_Mvcsf);
    cd(folgrp2)
    load('imageC12_Mvcsf.mat');
    group2 = char(imageC10_Mvcsf);
    mkdir(resultfol,'2_level_C12_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_C12_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %5º analisis: Con despike - 6mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageC6_Global.mat');
    group1 = char(imageC6_Global);
    cd(folgrp2)
    load('imageC6_Global.mat');
    group2 = char(imageC6_Global);
    mkdir(resultfol,'2_level_C6_Global');
    Outdir = strcat(resultfol,'\2_level_C6_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %6º analisis: Con despike - 8mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageC8_Global.mat');
    group1 = char(imageC6_Global);
    cd(folgrp2)
    load('imageC8_Global.mat');
    group2 = char(imageC8_Global);
    mkdir(resultfol,'2_level_C8_Global');
    Outdir = strcat(resultfol,'\2_level_C8_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %7º analisis: Con despike - 10mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageC10_Global.mat');
    group1 = char(imageC10_Global);
    cd(folgrp2)
    load('imageC10_Global.mat');
    group2 = char(imageC10_Global);
    mkdir(resultfol,'2_level_C10_Global');
    Outdir = strcat(resultfol,'\2_level_C10_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %8º analisis: Con despike - 12mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageC12_Global.mat');
    group1 = char(imageC12_Global);
    cd(folgrp2)
    load('imageC12_Global.mat');
    group2 = char(imageC12_Global);
    mkdir(resultfol,'2_level_C12_Global');
    Outdir = strcat(resultfol,'\2_level_C12_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
%--------------------------------------------------------------------------
    
    %9º analisis: Sin despike - 6mm - Mvcsfwm
    cd(folgrp1)
    load('imageS6_Mvcsf.mat');
    group1= char(imageS6_Mvcsf);
    cd(folgrp2)
    load('imageS6_Mvcsf.mat');
    group2 = char(imageS6_Mvcsf);
    mkdir(resultfol,'2_level_S6_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_S6_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %10º analisis: Sin despike - 8mm - Mvcsfwm
    cd(folgrp1)
    load('imageS8_Mvcsf.mat');
    group1= char(imageS8_Mvcsf);
    cd(folgrp2)
    load('imageS8_Mvcsf.mat');
    group2 = char(imageS8_Mvcsf);
    mkdir(resultfol,'2_level_S8_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_S8_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %11º analisis: Sin despike - 10mm - Mvcsfwm
    cd(folgrp1)
    load('imageS10_Mvcsf.mat');
    group1= char(imageS10_Mvcsf);
    cd(folgrp2)
    load('imageS10_Mvcsf.mat');
    group2 = char(imageS10_Mvcsf);
    mkdir(resultfol,'2_level_S10_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_S10_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %12º analisis: Sin despike - 12mm - Mvcsfwm
    cd(folgrp1)
    load('imageS12_Mvcsf.mat');
    group1= char(imageS12_Mvcsf);
    cd(folgrp2)
    load('imageS12_Mvcsf.mat');
    group2 = char(imageS12_Mvcsf);
    mkdir(resultfol,'2_level_S12_Mvcsfwm');
    Outdir = strcat(resultfol,'\2_level_S12_Mvcsfwm');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %13º analisis: Sin despike - 6mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageS6_Global.mat');
    group1 = char(imageS6_Global);
    cd(folgrp2)
    load('imageS6_Global.mat');
    group2 = char(imageS6_Global);
    mkdir(resultfol,'2_level_S6_Global');
    Outdir = strcat(resultfol,'\2_level_S6_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %14º analisis: Sin despike - 8mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageS8_Global.mat');
    group1 = char(imageS8_Global);
    cd(folgrp2)
    load('imageS8_Global.mat');
    group2 = char(imageS8_Global);
    mkdir(resultfol,'2_level_S8_Global');
    Outdir = strcat(resultfol,'\2_level_S8_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %15º analisis: Sin despike - 10mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageS10_Global.mat');
    group1 = char(imageS6_Global);
    cd(folgrp2)
    load('imageS10_Global.mat');
    group2 = char(imageS10_Global);
    mkdir(resultfol,'2_level_S10_Global');
    Outdir = strcat(resultfol,'\2_level_S10_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %16º analisis: Sin despike - 12mm - Mvcsfwm + Global
    cd(folgrp1)
    load('imageS12_Global.mat');
    group1 = char(imageS12_Global);
    cd(folgrp2)
    load('imageS12_Global.mat');
    group2 = char(imageS12_Global);
    mkdir(resultfol,'2_level_S12_Global');
    Outdir = strcat(resultfol,'\2_level_S12_Global');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)

%--------------------------------------------------------------------------
    %17º analisis: Con despike - 6mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageC6_Phys.mat');    
    if length(imageC6_Phys{1,1}) > 1
        group1 = char(imageC6_Phys);
        
    elseif length(imageC6_Phys{1,1}) < 1
        load('imageC6_Mvcsf.mat')
        group1 = char(imageC6_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC6_Phys.mat');
    if length(imageC6_Phys{1,1}) > 1
        group2 = char(imageC6_Phys);
        
    elseif length(imageC6_Phys{1,1}) < 1
        load('imageC6_Mvcsf.mat')
        group2 = char(imageC6_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C6_Phys');
    Outdir = strcat(resultfol,'\2_level_C6_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)

    %18º analisis: Con despike - 8mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageC8_Phys.mat');    
    if length(imageC8_Phys{1,1}) > 1
        group1 = char(imageC8_Phys);
        
    elseif length(imageC8_Phys{1,1}) < 1
        load('imageC8_Mvcsf.mat')
        group1 = char(imageC8_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC8_Phys.mat');
    if length(imageC8_Phys{1,1}) > 1
        group2 = char(imageC8_Phys);
        
    elseif length(imageC8_Phys{1,1}) < 1
        load('imageC8_Mvcsf.mat')
        group2 = char(imageC8_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C8_Phys');
    Outdir = strcat(resultfol,'\2_level_C8_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %19º analisis: Con despike - 10mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageC10_Phys.mat');    
    if length(imageC10_Phys{1,1}) > 1
        group1 = char(imageC10_Phys);
        
    elseif length(imageC10_Phys{1,1}) < 1
        load('imageC10_Mvcsf.mat')
        group1 = char(imageC10_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC10_Phys.mat');
    if length(imageC10_Phys{1,1}) > 1
        group2 = char(imageC10_Phys);
        
    elseif length(imageC10_Phys{1,1}) < 1
        load('imageC10_Mvcsf.mat')
        group2 = char(imageC10_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C10_Phys');
    Outdir = strcat(resultfol,'\2_level_C10_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %20º analisis: Con despike - 12mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageC12_Phys.mat');    
    if length(imageC12_Phys{1,1}) > 1
        group1 = char(imageC12_Phys);
        
    elseif length(imageC12_Phys{1,1}) < 1
        load('imageC12_Mvcsf.mat')
        group1 = char(imageC12_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC12_Phys.mat');
    if length(imageC12_Phys{1,1}) > 1
        group2 = char(imageC12_Phys);
        
    elseif length(imageC12_Phys{1,1}) < 1
        load('imageC12_Mvcsf.mat')
        group2 = char(imageC12_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C12_Phys');
    Outdir = strcat(resultfol,'\2_level_C12_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
%--------------------------------------------------------------------------

    %21º analisis: Sin despike - 6mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageS6_Phys.mat');    
    if length(imageS6_Phys{1,1}) > 1
        group1 = char(imageS6_Phys);
        
    elseif length(imageS6_Phys{1,1}) < 1
        load('imageS6_Mvcsf.mat')
        group1 = char(imageS6_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS6_Phys.mat');
    if length(imageS6_Phys{1,1}) > 1
        group2 = char(imageS6_Phys);
        
    elseif length(imageS6_Phys{1,1}) < 1
        load('imageS6_Mvcsf.mat')
        group2 = char(imageS6_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S6_Phys');
    Outdir = strcat(resultfol,'\2_level_S6_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %22º analisis: Sin despike - 8mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageS8_Phys.mat');    
    if length(imageS8_Phys{1,1}) > 1
        group1 = char(imageS8_Phys);
        
    elseif length(imageS8_Phys{1,1}) < 1
        load('imageS8_Mvcsf.mat')
        group1 = char(imageS8_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS8_Phys.mat');
    if length(imageS8_Phys{1,1}) > 1
        group2 = char(imageS8_Phys);
        
    elseif length(imageS8_Phys{1,1}) < 1
        load('imageS8_Mvcsf.mat')
        group2 = char(imageS8_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S8_Phys');
    Outdir = strcat(resultfol,'\2_level_S8_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %23º analisis: Sin despike - 10mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageS10_Phys.mat');    
    if length(imageS10_Phys{1,1}) > 1
        group1 = char(imageS10_Phys);
        
    elseif length(imageS10_Phys{1,1}) < 1
        load('imageS10_Mvcsf.mat')
        group1 = char(imageS10_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS10_Phys.mat');
    if length(imageS10_Phys{1,1}) > 1
        group2 = char(imageS10_Phys);
        
    elseif length(imageS10_Phys{1,1}) < 1
        load('imageS10_Mvcsf.mat')
        group2 = char(imageS10_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S10_Phys');
    Outdir = strcat(resultfol,'\2_level_S10_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %24º analisis: Sin despike - 12mm - Mvcsfwm + Physios
    cd(folgrp1)
    load('imageS12_Phys.mat');    
    if length(imageS12_Phys{1,1}) > 1
        group1 = char(imageS12_Phys);
        
    elseif length(imageS12_Phys{1,1}) < 1
        load('imageS12_Mvcsf.mat')
        group1 = char(imageS12_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS12_Phys.mat');
    if length(imageS12_Phys{1,1}) > 1
        group2 = char(imageS12_Phys);
        
    elseif length(imageS12_Phys{1,1}) < 1
        load('imageS12_Mvcsf.mat')
        group2 = char(imageS12_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S12_Phys');
    Outdir = strcat(resultfol,'\2_level_S12_Phys');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
  
%--------------------------------------------------------------------------
    %25º analisis: Con despike - 6mm - All
    cd(folgrp1)
    load('imageC6_All.mat');    
    if length(imageC6_All{1,1}) > 1
        group1 = char(imageC6_All);
        
    elseif length(imageC6_All{1,1}) < 1
        load('imageC6_Mvcsf.mat')
        group1 = char(imageC6_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC6_All.mat');
    if length(imageC6_All{1,1}) > 1
        group2 = char(imageC6_All);
        
    elseif length(imageC6_All{1,1}) < 1
        load('imageC6_Mvcsf.mat')
        group2 = char(imageC6_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C6_All');
    Outdir = strcat(resultfol,'\2_level_C6_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)

    %26º analisis: Con despike - 8mm - All
    cd(folgrp1)
    load('imageC8_All.mat');    
    if length(imageC8_All{1,1}) > 1
        group1 = char(imageC8_All);
        
    elseif length(imageC8_All{1,1}) < 1
        load('imageC8_Mvcsf.mat')
        group1 = char(imageC8_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC8_All.mat');
    if length(imageC8_All{1,1}) > 1
        group2 = char(imageC8_All);
        
    elseif length(imageC8_All{1,1}) < 1
        load('imageC8_Mvcsf.mat')
        group2 = char(imageC8_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C8_All');
    Outdir = strcat(resultfol,'\2_level_C8_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    
    %27º analisis: Con despike - 10mm - All
    cd(folgrp1)
    load('imageC10_All.mat');    
    if length(imageC10_All{1,1}) > 1
        group1 = char(imageC10_All);
        
    elseif length(imageC10_All{1,1}) < 1
        load('imageC10_Mvcsf.mat')
        group1 = char(imageC10_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC10_All.mat');
    if length(imageC10_All{1,1}) > 1
        group2 = char(imageC10_All);
        
    elseif length(imageC10_All{1,1}) < 1
        load('imageC10_Mvcsf.mat')
        group2 = char(imageC10_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C10_All');
    Outdir = strcat(resultfol,'\2_level_C10_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %28º analisis: Con despike - 12mm - All
    cd(folgrp1)
    load('imageC12_All.mat');    
    if length(imageC12_All{1,1}) > 1
        group1 = char(imageC12_All);
        
    elseif length(imageC12_All{1,1}) < 1
        load('imageC12_Mvcsf.mat')
        group1 = char(imageC12_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageC12_All.mat');
    if length(imageC12_All{1,1}) > 1
        group2 = char(imageC12_All);
        
    elseif length(imageC12_All{1,1}) < 1
        load('imageC12_Mvcsf.mat')
        group2 = char(imageC12_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_C12_All');
    Outdir = strcat(resultfol,'\2_level_C12_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)

%--------------------------------------------------------------------------
    %29º analisis: Sin despike - 6mm - All
    cd(folgrp1)
    load('imageS6_All.mat');    
    if length(imageS6_All{1,1}) > 1
        group1 = char(imageS6_All);
        
    elseif length(imageS6_All{1,1}) < 1
        load('imageS6_Mvcsf.mat')
        group1 = char(imageS6_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS6_All.mat');
    if length(imageS6_All{1,1}) > 1
        group2 = char(imageS6_All);
        
    elseif length(imageS6_All{1,1}) < 1
        load('imageS6_Mvcsf.mat')
        group2 = char(imageS6_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S6_All');
    Outdir = strcat(resultfol,'\2_level_S6_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %30º analisis: Sin despike - 8mm - All
    cd(folgrp1)
    load('imageS8_All.mat');    
    if length(imageS8_All{1,1}) > 1
        group1 = char(imageS8_All);
        
    elseif length(imageS8_All{1,1}) < 1
        load('imageS8_Mvcsf.mat')
        group1 = char(imageS8_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS8_All.mat');
    if length(imageS8_All{1,1}) > 1
        group2 = char(imageS8_All);
        
    elseif length(imageS8_All{1,1}) < 1
        load('imageS8_Mvcsf.mat')
        group2 = char(imageS8_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S8_All');
    Outdir = strcat(resultfol,'\2_level_S8_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %31º analisis: Sin despike - 10mm - All
    cd(folgrp1)
    load('imageS10_All.mat');    
    if length(imageS10_All{1,1}) > 1
        group1 = char(imageS10_All);
        
    elseif length(imageS10_All{1,1}) < 1
        load('imageS10_Mvcsf.mat')
        group1 = char(imageS10_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS10_All.mat');
    if length(imageS10_All{1,1}) > 1
        group2 = char(imageS10_All);
        
    elseif length(imageS10_All{1,1}) < 1
        load('imageS10_Mvcsf.mat')
        group2 = char(imageS10_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S10_All');
    Outdir = strcat(resultfol,'\2_level_S10_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
    %32º analisis: Sin despike - 12mm - All
    cd(folgrp1)
    load('imageS12_All.mat');    
    if length(imageS12_All{1,1}) > 1
        group1 = char(imageS12_All);
        
    elseif length(imageS12_All{1,1}) < 1
        load('imageS12_Mvcsf.mat')
        group1 = char(imageS12_Mvcsf);
    end
    
    cd(folgrp2)
    load('imageS12_All.mat');
    if length(imageS12_All{1,1}) > 1
        group2 = char(imageS12_All);
        
    elseif length(imageS12_All{1,1}) < 1
        load('imageS12_Mvcsf.mat')
        group2 = char(imageS12_Mvcsf);
    end
    
    mkdir(resultfol,'2_level_S12_All');
    Outdir = strcat(resultfol,'\2_level_S12_All');
    
    second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)
    
end
    
fprintf('%-40s: %30s\n','Second Level Analysis Completed!',spm('time'))


end