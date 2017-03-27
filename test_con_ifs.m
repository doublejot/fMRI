function first_level_RS

%==========================================================================
%Load de settings
%==========================================================================
clc
clear all

war = warning('off','all');
warning(war)

spm('defaults','FMRI')

ispar=matlabpool('size');
if ispar == 0;
    matlabpool
end

%==========================================================================
%Select the directory
%==========================================================================
uiwait(msgbox('Selecciona el directorio donde se encuentran los sujetos que vas a analizar','First level fMRI'));
directorio = uigetdir;

uiwait (msgbox({'Introduce el orden en que se adquirieron los cortes ("slice order")' '' 'Ejemplos:' 'Ascending' 'Descending' 'InterleavedEven' 'InterleavedOdd' '(Escribir igual que los ejemplos)'},'First level fMRI'));
prompt = 'Orden: ';
acquorder = inputdlg(prompt);

[mainfolder] = spm_select('FPList',directorio,'dir');
a = '\';
mainfolder = strcat(mainfolder,a);
dirsuj = cellstr(mainfolder);
lengthsuj = size(dirsuj);
lengthsuj = lengthsuj(1);


for i = 1:lengthsuj
    
    [folEPI]=selectfolder_1level(i,dirsuj);
    
    fprintf('%-40s: %30s\n','Initializing first level analysis for subject ...',spm('time'));
    folEPI
    
    %======================================================================
    %Load the sequence parameters
    %======================================================================
    
    [t,c,r]=read_infosequence(folEPI,acquorder);
    
    %t = TR
    %c = number of slices
    %r = reference slice
    
    %======================================================================
    %aqui ya tendría las folEPI, tendría que buscar los directorios donde están
    %los suavizados. Siempre serán Preproc_con_despike / Preproc_sin_despike
    
    folder_d = strcat(folEPI,'\Preproc_con_despike\');
    folder_nd = strcat(folEPI,'\Preproc_sin_despike\');
    
    
    %======================================================================
    %First Level all images with despike
    %======================================================================
    
    %Suavizado 6mm Con despike---------------------------------------------
    
    folder_cd_6 = strcat(folder_d,'Suavizado6mm\');    
    [images_cd_6]= spm_select('FPList',folder_cd_6,'^sw.*\.nii');  
    images_cd_6 = cellstr(images_cd_6);
    
    if length(images_cd_6) > 1;
        
        images_fl = images_cd_6;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_cd_6,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_cd_6,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_cd_6,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_cd_6,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_cd_6,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_cd_6,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_cd_6,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_cd_6,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_cd_6,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_cd_6,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_cd_6,'All_Regressors');
            folder_reg4 = strcat(folder_cd_6,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    %----------------------------------------------------------------------
    
    %Suavizado 8mm Con despike---------------------------------------------
    
    folder_cd_8 = strcat(folder_d,'Suavizado8mm\');    
    [images_cd_8]= spm_select('FPList',folder_cd_8,'^sw.*\.nii');  
    images_cd_8 = cellstr(images_cd_8);
    
    if length(images_cd_8) > 1;
        
        images_fl = images_cd_8;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_cd_8,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_cd_8,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_cd_8,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_cd_8,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_cd_8,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_cd_8,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_cd_8,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_cd_8,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_cd_8,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_cd_8,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_cd_8,'All_Regressors');
            folder_reg4 = strcat(folder_cd_8,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    %----------------------------------------------------------------------
    
    %Suavizado 10mm Con despike--------------------------------------------
    
    folder_cd_10 = strcat(folder_d,'Suavizado10mm\');    
    [images_cd_10]= spm_select('FPList',folder_cd_10,'^sw.*\.nii');  
    images_cd_10 = cellstr(images_cd_10);
    
    if length(images_cd_10) > 1;
        
        images_fl = images_cd_10;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_cd_10,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_cd_10,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_cd_10,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_cd_10,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_cd_10,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_cd_10,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_cd_10,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_cd_10,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_cd_10,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_cd_10,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_cd_10,'All_Regressors');
            folder_reg4 = strcat(folder_cd_10,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    
    %Suavizado 12mm Con despike--------------------------------------------
    
    folder_cd_12 = strcat(folder_d,'Suavizado12mm\');    
    [images_cd_12]= spm_select('FPList',folder_cd_12,'^sw.*\.nii');  
    images_cd_12 = cellstr(images_cd_12);
    
    if length(images_cd_12) > 1;
        
        images_fl = images_cd_12;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_cd_12,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_cd_12,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_cd_12,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_cd_12,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_cd_12,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_cd_12,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_cd_12,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_cd_12,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_cd_12,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_cd_12,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_cd_12,'All_Regressors');
            folder_reg4 = strcat(folder_cd_12,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    
    %======================================================================
    %First Level all images not despiked
    %======================================================================
    
    %Suavizado 6mm Sin despike---------------------------------------------
    
    folder_sd_6 = strcat(folder_nd,'Suavizado6mm\');    
    [images_sd_6]= spm_select('FPList',folder_sd_6,'^sw.*\.nii');  
    images_sd_6 = cellstr(images_sd_6);
    
    if length(images_sd_6) > 1;
        
        images_fl = images_sd_6;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_sd_6,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_sd_6,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_sd_6,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_sd_6,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_sd_6,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_sd_6,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_sd_6,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_sd_6,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_sd_6,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_sd_6,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_sd_6,'All_Regressors');
            folder_reg4 = strcat(folder_sd_6,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    %----------------------------------------------------------------------
    
    %Suavizado 8mm Sin despike---------------------------------------------
    
    folder_sd_8 = strcat(folder_nd,'Suavizado8mm\');    
    [images_sd_8]= spm_select('FPList',folder_sd_8,'^sw.*\.nii');  
    images_sd_8 = cellstr(images_sd_8);
    
    if length(images_sd_8) > 1;
        
        images_fl = images_sd_8;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_sd_8,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_sd_8,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_sd_8,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_sd_8,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_sd_8,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_sd_8,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_sd_8,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_sd_8,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_sd_8,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_sd_8,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_sd_8,'All_Regressors');
            folder_reg4 = strcat(folder_sd_8,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    %----------------------------------------------------------------------
    
     %Suavizado 10mm Sin despike---------------------------------------------
    
    folder_sd_10 = strcat(folder_nd,'Suavizado10mm\');    
    [images_sd_10]= spm_select('FPList',folder_sd_10,'^sw.*\.nii');  
    images_sd_10 = cellstr(images_sd_10);
    
    if length(images_sd_10) > 1;
        
        images_fl = images_sd_10;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_sd_10,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_sd_10,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_sd_10,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_sd_10,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_sd_10,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_sd_10,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_sd_10,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_sd_10,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_sd_10,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_sd_10,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_sd_10,'All_Regressors');
            folder_reg4 = strcat(folder_sd_10,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    %----------------------------------------------------------------------
    
     %Suavizado 10mm Sin despike---------------------------------------------
    
    folder_sd_12 = strcat(folder_nd,'Suavizado10mm\');    
    [images_sd_12]= spm_select('FPList',folder_sd_12,'^sw.*\.nii');  
    images_sd_12 = cellstr(images_sd_12);
    
    if length(images_sd_12) > 1;
        
        images_fl = images_sd_12;
        
        %load the regressors first of all
        
        regresor1 = spm_select('FPList',folder_sd_12,'Mv_wmcsf_Regressor.*\.txt');
        regresor2 = spm_select('FPList',folder_sd_12,'Mv_wmcsf_global_Regressor.*\.txt');
        regresor3 = spm_select('FPList',folder_sd_12,'Mv_wmcsf_physio_Regressor.*\.txt');
        regresor4 = spm_select('FPList',folder_sd_12,'All_Regressors.*\.txt');
        
        %run the first level for each regresor
        
        mkdir(folder_sd_12,'1st_level_Mv_wmcsf_Regressor');
        folder_reg1 = strcat(folder_sd_12,'1st_level_Mv_wmcsf_Regressor');
        mkdir(folder_sd_12,'1st_level_Mv_wmcsf_global_Regressor');
        folder_reg2 = strcat(folder_sd_12,'1st_level_Mv_wmcsf_global_Regressor');
        
        folder_1st_level = folder_reg1;
        first_level(folder_1st_level,c,t,r,images_fl,regresor1)
        
        folder_1st_level = folder_reg2;
        first_level(folder_1st_level,c,t,r,images_fl,regresor2)
        
        
        if length(regresor3) > 1
            
            mkdir(folder_sd_12,'Mv_wmcsf_physio_Regressor');
            folder_reg3 = strcat(folder_sd_12,'Mv_wmcsf_physio_Regressor');
            folder_1st_level = folder_reg3;
            first_level(folder_1st_level,c,t,r,images_fl,regresor3)
        end
        
        if length(regresor4) > 1
            
            mkdir(folder_sd_12,'All_Regressors');
            folder_reg4 = strcat(folder_sd_12,'All_Regressors');
            folder_1st_level = folder_reg4;
            first_level(folder_1st_level,c,t,r,images_fl,regresor4)
        end
        
    end
    %----------------------------------------------------------------------
    
%==========================================================================
%Get the peak value for get outliers function
%==========================================================================
get_peakv_for_groupoutlier(folEPI)
    
end
%==========================================================================
%Get the outliers
%==========================================================================

%Primero tiene que cargar todas las imágenes Con de todos los sujetos
%--------------------------------------------------------------------------
[list_imagecon,mean_peak_value,mainfolder] = get_con_images(directorio);


%Se le pasa la función que detecta los outliers y saca una gráfica con
%ellos
%--------------------------------------------------------------------------

detect_outliers(mean_peak_value,list_imagecon,mainfolder,directorio)

end