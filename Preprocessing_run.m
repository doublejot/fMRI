function Preprocessing_run

%Help for Function Preprocessing
%Before start, make sure that you already installed SPM12, the
%ArtRepairToolbox and TAPAS Physios toolbox.
%This script runs a complete preprocessing for fMR images. It requests
%several thing before run:
%Each subject must have the T1 image and the Epi images in a separate
%directory. Epi's folder must contain all the functional images in 3D, and
%the info sequence obtained from MRIConvert. This file is an output from
%convert the dicom file to nii in this program. This is necessary in order
%to read the sequence info for slice timing.
%You have to reorient with SPM the T1 image to the anterior comissure
%manually.
%Now, you can run the script. At the beginnig, will ask you a several
%question:
%1. The main directory for all the images. 
%Before that, the script will check if the T1 is reoriented to the
%anterior comissure.
%2. The second input is the Acquisition Order of the slices. I you don't
%know it, but your images are from Siemens, don't worry, you can let this
%field blank. But if from Philips, you have to set it. E.g. Ascending,
%Descending, InterleavedEven, InterleavedOdd.
%3. The movement parameter. You have 3 options: 6, for rigid body
%transformation. 12, for the 6 motion parameters and their 6 derivatives.
%And 24, for friston movement parameter.
%4. The filt you want to apply to the images. You can see the examples in
%the prompt.
%5. The number of the smooths. There are several possibilities, but always
%a combination of smooths, between 6, 8, 10 or 12.
%6. The last one let you choose if you wanna include the physiological data
%as regressor or not. You can decide after use it, because this will
%generate a regressor with physiological data and without physiological
%data.
%After this question the script will run all the subjects in the main
%folder.
%First of all, apply a the function from Art Repair toolbox, slice repair.
%This check all the slices of all volumes and repair if one of them is bad.
%The next step is slice timing, realign and reslice, from SPM12. After
%this, the script will transform the realigment parameter to the selected
%before.
%The nexts steps do the segment for the T1 images and the Dartel for them.
%Next apply a function from Art Repair toolbox, art_despike. After this you
%have two set s of images in order to coregistration: the one with the
%despike apply and the one with not despike.
%After the coregistration, the script obtain the ROI time course for WM,
%CSF and Global signal. (You can add another ROI manully).
%Next, the script gets the regressor of the physiological noise.
%And finally normalise and smooth the bold images.
%The normalise and smooth images are save inside the folder of the EPI
%images. They are saved in two folders: "con despike" (with despike) and
%"sin despike" (without despike). Inside this folders, there are the
%subfolders with the differents smoothings.
%
%Now, the images are ready for the first level analysis!
%__________________________________________________________________________
%Written by Juan Jesús Toro Murillo
%mail to author: jjsfc12@gmail.com
%version 1.0
%Release 27/03/2017
%--------------------------------------------------------------------------

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
%Check if the T1 images have the origin at the anterior comissure
%==========================================================================

[directorio,numberofnor] = check_origin;
%
if numberofnor == 1
    error('Las imágenes tienen que estar reorientadas a la comisura anterior');
end

%==========================================================================
%Initial questions
%==========================================================================

[acquorder,mv_parameter,Filt,smooth,fisios] = initial_questions;


%==========================================================================
%Get the files folders
%==========================================================================

[mainfolder] = spm_select('FPList',directorio,'dir');
a = '\';
mainfolder = strcat(mainfolder,a);
dirsuj = cellstr(mainfolder);
lengthsuj = size(dirsuj);
lengthsuj = lengthsuj(1);

wb = waitbar(0,'Preprocessing fMRI ...');


for i = 1:lengthsuj
    
    waitbar(i/lengthsuj)
    
    [folEPI,folT1] = select_folders(dirsuj,i);
    
    fprintf('%-40s: %30s\n','Initializing preprocessing for subject ...',spm('time'));
    folEPI
    
    %======================================================================
    %Slice Repair
    %======================================================================
    
    [P] = spm_select('FPList',folEPI,'^2.*\.nii');
    
    slice_repair(P)
    
    fprintf('%-40s: %30s\n','Completed',spm('time'));
    
    %======================================================================
    %Slice Timing
    %======================================================================
    %----------------------------------------------------------------------
    %Read sequence info from txt
    %----------------------------------------------------------------------
    [info] = spm_select('FPList',folEPI,'info.*\.txt');
    fid = fopen(info, 'r');
    tline1 = fgetl(fid); %delete the files from txt including patient's name
    tline2 = fgetl(fid);
    tline3 = fgetl(fid);
    tline4 = fgetl(fid);
    tline5 = fgetl(fid);
    tline6 = fgetl(fid);
    opt = {-inf, 'endofline','','whitespace',' \b\t\r\n', 'collectoutput',1};
    fmt = '%s%s';
    data = textscan(fid,fmt,opt{:});
    fid = fclose(fid);
    data = num2cell(data{1});
    scanner = data{6,2};
    scanner = scanner{1,1};
    %----------------------------------------------------------------------
    
    [info] = spm_select('FPList',folEPI,'info.*\.txt');
    fid = fopen(info, 'r');
    tline1 = fgetl(fid);
    tline2 = fgetl(fid);
    tline3 = fgetl(fid);
    tline4 = fgetl(fid);
    tline5 = fgetl(fid);
    tline6 = fgetl(fid);
    tline7 = fgetl(fid);
    tline8 = fgetl(fid);
    tline9 = fgetl(fid);
    tline10 = fgetl(fid);
    tline11 = fgetl(fid);
    tline12 = fgetl(fid);
    opt = {-inf, 'endofline','','whitespace',' \b\t\r\n', 'collectoutput',1};
    fmt = '%s%s';
    data = textscan(fid,fmt,opt{:});
    fid = fclose(fid);
    data = num2cell(data{1});
    
    
    if strcmp(scanner,'Philips')
        tr = data{5,2};
        tr= tr{1};
        t= str2num(tr);
        t = t/1000;
        vo= data{27,1};
        vo=vo{1};
        vol=str2num(vo); %#ok<ST2NM>
        numberslices = data{29,1};
        numberslices= numberslices{1};
        c= str2num(numberslices); %#ok<ST2NM>
        order = acquorder;
    end
    
    if strcmp(scanner,'SIEMENS')
        tr = data{5,2};
        tr= tr{1};
        t= str2num(tr);
        t= t/1000;
        vo= data{27,1};
        vo=vo{1};
        vol=str2num(vo); %#ok<ST2NM>
        numberslices = data{29,1};
        numberslices= numberslices{1};
        c= str2num(numberslices);
        order1 = data{58,1};
        order2 = data{58,2};
        order1 = order1{1};
        order2 = order2{1};
        order = strcat(order1,order2);
    end
    
    if strcmp(order,'Ascending');
        o = [1:1:c];
    elseif strcmp(order,'Descending');
        o = [c:-1:1];
    elseif strcmp(order,'InterleavedEven');
        o = [2:2:c 1:2:c];
    elseif strcmp(order,'InterleavedOdd');
        o = [1:2:c 2:2:c];
    end
    
    %obtain reference slice
    reference = num2cell(o);
    middle = c/2;
    reference = reference{middle};
    r = reference;
    
    %----------------------------------------------------------------------
    %Sequence Parameters
    %----------------------------------------------------------------------
    TR = t;
    num_slices = c;
    ref_slice  = r;
    slice_time = TR/num_slices;
    slice_gap  = slice_time;
    slice_ord  = o;
    %----------------------------------------------------------------------
    
    [P] = spm_select('FPList',folEPI,'^h.*\.nii');
    
    spm_slice_timing(P, slice_ord, ref_slice, [slice_time slice_gap]);
    
    
    %======================================================================
    %Realign Estime & Reslice
    %======================================================================
    
    [P] = spm_select('FPList',folEPI,'^a.*\.nii');
    
    spm_realign(P);
    spm_reslice(P);
    
    %======================================================================
    %Transform realingment parameters from 6 to 12/24
    %======================================================================
    
    [mv] = spm_select('FPList',folEPI,'^rp_ah.*\.txt');
    mv = load(mv);
    
    if mv_parameter == 6
        fprintf('%-40s: %30s\n','6 motion regressors',spm('time'))
        
    elseif mv_parameter == 12
        fprintf('%-40s: %30s\n','getting 12 motion regressors',spm('time'))
        motionregres12(mv,folEPI)
        fprintf('%-40s: %30s\n','Completed!',spm('time'))
        
    elseif mv_parameter == 24
        fprintf('%-40s: %30s\n','getting 24 motion regressors...',spm('time'))
        motionregres24(mv,folEPI)
        fprintf('%-40s: %30s\n','Completed!',spm('time'))
    end
    
    %======================================================================
    %Segment T1
    %======================================================================
    
    [E] = spm_select('ExtFPList',folT1,'^2.*.\.nii',1);
    
    segment_t1 (E)
    
    %======================================================================
    %Dartel T1
    %======================================================================
    
    [Q] = spm_select('ExtFPList',folT1,'^rc1.*.\.nii',1);
    [W] = spm_select('ExtFPList',folT1,'^rc2.*.\.nii',1);
    [X] = spm_select('ExtFPList',folT1,'^rc3.*.\.nii',1);
    
    Q = {Q};
    W = {W};
    X = {X};
    
    dartel_create_template (Q,W,X)
    
    
    %======================================================================
    %Normalise to MNI space c1,c2,c3
    %======================================================================
    
    template = spm_select('FPList',folT1,'^Template_6.*\.nii');
    flowfil = spm_select('FPList',folT1,'^u.*\.nii');
    [I] = spm_select('FPList',folT1,'^c1.*\.nii');
    [J] = spm_select('FPList',folT1,'^c2.*\.nii');
    [K] = spm_select('FPList',folT1,'^c3.*\.nii');
    % I = cellstr(I);
    % J = cellstr(J);
    % K = cellstr(K);
    
    normalise_T1(template,flowfil,I,J,K)
    
    %======================================================================
    %Despike Bold
    %======================================================================
    
    [Pimages] = spm_select('FPList',folEPI,'^rah.*\.nii');
    
    despike_bold(Pimages,Filt)
    
    fprintf('%-40s: %30s\n','Completed',spm('time'));
    
    %======================================================================
    %Coregister Bold to T1 (despiked)
    %======================================================================
     mean2(folEPI)
    
    [imaget1] = spm_select('ExtFPList',folT1,'^2.*.\.nii',1);
    [imagemean] = spm_select('ExtFPList',folEPI,'^mean.*.\.nii',1);
    [otherimages] = spm_select('ExtFPList',folEPI,'^drah.*.\.nii',1);
    otherimages = cellstr(otherimages);
    
    coregister_bold(imaget1,imagemean,otherimages)
    
    %======================================================================
    %Coregister Bold to T1 (NO despiked)
    %======================================================================
    folmean = strcat(folEPI,'\2mean');
     
    [imaget1] = spm_select('ExtFPList',folT1,'^2.*.\.nii',1);
    [imagemean] = spm_select('ExtFPList',folmean,'^mean.*.\.nii',1);
    [otherimages] = spm_select('ExtFPList',folEPI,'^rah.*.\.nii',1);
    otherimages = cellstr(otherimages);
    
    coregister_bold(imaget1,imagemean,otherimages)
    
    
    %======================================================================
    %Obtain the time course for WM, CSF and Global signal as regressors
    %======================================================================
    
    %Coregister the segmented images to MNI bold first
    %VG = reference T1
    %VF = source image mean Bold
    %P = other images, Bold
    
    [VH] = spm_select('ExtFPList',folEPI,'^gr.*\.nii',1);
    VH = VH(1,1:end);
    [VI] = spm_select('FPList',folT1,'^swc.*\.nii');
    VH= spm_vol(VH);
    VI= spm_vol(VI);
    
    spm_coreg(VH,VI);
    
    flags=[];
    prefijo='g';
    spm_reslice_mod(VI, flags, prefijo);
     
    %----------------------------------------------------------------------
    %Make the mask for the WM, CSF and Global images:
    
    %for WM
    input = spm_select('FPList',folT1,'^gswc2.*\.nii');
    outputname = 'wm_mask';
    outdir = folT1;
    threshold = '0.99';
    exp='i1>';
    expression = strcat(exp,threshold);
    
    fprintf('%-40s: %30s\n','Generating WM mask');
    
    generate_segmented_mask (input,outputname,outdir,expression)
    
    %for CSF
    input = spm_select('FPList',folT1,'^gswc3.*\.nii');
    outputname = 'csf_mask';
    outdir = folT1;
    threshold = '0.99';
    exp='i1>';
    expression = strcat(exp,threshold);
    
    fprintf('%-40s: %30s\n','Generating CSF mask');
    
    generate_segmented_mask (input,outputname,outdir,expression)
    
    %for GM (el umbral tambien es de 0.99)
    
    GC1 = spm_select('FPList',folT1,'^gswc1.*\.nii');
    GC2 = spm_select('FPList',folT1,'^gswc2.*\.nii');
    GC3 = spm_select('FPList',folT1,'^gswc3.*\.nii');
    outdir = folT1;
    
    fprintf('%-40s: %30s\n','Generating Global mask');
    
    generate_segmented_globalmask (GC1,GC2,GC3,outdir)
    
    %Define the ROI before the temporal signal extraction
    AROIDef = spm_select('FPList',folT1,'_mask.*\.nii');
    AROIDef = cellstr(AROIDef);
    AROIDef2 = spm_select('FPList',folT1,'glo.*\.nii');
    AROIDef2 = cellstr(AROIDef2);
    
    %======================================================================
    %TAPAS PhysIO toolbox
    %======================================================================
    RealizarFisios = string('Y');
    RealizarFisios = {RealizarFisios};
    realizarfisios = string('y');
    realizarfisios = {realizarfisios};
    NoRealizar = string('N');
    NoRealizar = {NoRealizar};
    norealizar = string('n');
    norealizar = {norealizar};
    
    
    if strcmp(fisios,RealizarFisios) || strcmp(fisios,realizarfisios);
        [logfile] = spm_select('FPList',folEPI,'^scan.*\.log');
    end
    
    if strcmp(logfile, '');
        fprintf('%-40s: %30s\n','No se realizarán los calculos para las covariables fisiológicas',spm('time'))
        
    elseif length(logfile) > 1;
        
        try  physios_regressors (folEPI,logfile,c,t,vol,r)
        catch
        end
        
    end
    
    if strcmp(fisios,NoRealizar)|| strcmp(fisios,norealizar);
        
        fprintf('%-40s: %30s\n','No se realizarán los calculos para las covariables fisiológicas',spm('time'))
    end
    
    
    
    %======================================================================
    %Normalise and smooth Bold to MNI space (with despike)
    %======================================================================
    RealizarSuavizado = string('Y');
    realizarsuavizado = string('y');
    NoRealizarSuavizado = string('N');
    norealizarsuavizado = string('n');
    
    smooth3 = string('6 8 10');
    smooth3 = {smooth3};
    smooth6mm = string('6');
    smooth6mm = {smooth6mm};
    smooth8mm = string('8');
    smooth8mm = {smooth8mm};
    smooth10mm = string('10');
    smooth10mm = {smooth10mm};
    smooth6y8mm = string('6 8');
    smooth6y8mm = {smooth6y8mm};
    smooth6y10mm = string ('6 10');
    smooth6y10mm = {smooth6y10mm};
    smooth8y10mm = string('8 10');
    smooth8y10mm = {smooth8y10mm};
    smoothtodos = string('6 8 10 12');
    smoothtodos = {smoothtodos};
    smooth6y12mm = string('6 12');
    smooth6y12mm = {smooth6y12mm};
    smooth8y12mm = string('8 12');
    smooth8y12mm = {smooth8y12mm};
    smooth10y12mm = string('10 12');
    smooth10y12mm = {smooth10y12mm};
    smooth6812mm = string('6 8 12');
    smooth6812mm = {smooth6812mm};
    smooth61012mm = string('6 10 12');
    smooth61012mm = {smooth61012mm};
    smooth81012mm = string('8 10 12');
    smooth81012mm = {smooth81012mm};
    %----------------------------------------------------------------------
    [N] = spm_select ('FPList',folEPI,'^gdr.*\.nii');
    N = cellstr(N);
    template = spm_select('FPList',folT1,'^Template_6.*\.nii');
    flowfil = spm_select('FPList',folT1,'^u.*\.nii');
    
    %rest_ExtractROITC --> extract signal for WM, CSF and Global Signal after each smooth
    %join_regressors(foldersuavizado_d,foldersuavizado_nd,mv_parameter,fisios,folder_d,folder_nd,folEPI)
    
    if strcmp(smooth,smooth3);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth6mm);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth8mm);
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth10mm);
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth6y8mm);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth6y10mm);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth8y10mm);
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smoothtodos);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth6y12mm);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth8y12mm);
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth10y12mm);
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth6812mm);
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth61012mm);
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth81012mm);
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_cd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_con_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    end
    
    
    %======================================================================
    %Normalise and smooth Bold to MNI space (without despike)
    %======================================================================
    RealizarSuavizado = string('Y');
    realizarsuavizado = string('y');
    NoRealizarSuavizado = string('N');
    norealizarsuavizado = string('n');
    
    smooth3 = string('6 8 10');
    smooth3 = {smooth3};
    smooth6mm = string('6');
    smooth6mm = {smooth6mm};
    smooth8mm = string('8');
    smooth8mm = {smooth8mm};
    smooth10mm = string('10');
    smooth10mm = {smooth10mm};
    smooth6y8mm = string('6 8');
    smooth6y8mm = {smooth6y8mm};
    smooth6y10mm = string ('6 10');
    smooth6y10mm = {smooth6y10mm};
    smooth8y10mm = string('8 10');
    smooth8y10mm = {smooth8y10mm};
    smoothtodos = string('6 8 10 12');
    smoothtodos = {smoothtodos};
    smooth6y12mm = string('6 12');
    smooth6y12mm = {smooth6y12mm};
    smooth8y12mm = string('8 12');
    smooth8y12mm = {smooth8y12mm};
    smooth10y12mm = string('10 12');
    smooth10y12mm = {smooth10y12mm};
    smooth6812mm = string('6 8 12');
    smooth6812mm = {smooth6812mm};
    smooth61012mm = string('6 10 12');
    smooth61012mm = {smooth61012mm};
    smooth81012mm = string('8 10 12');
    smooth81012mm = {smooth81012mm};
    
    %----------------------------------------------------------------------
    [N] = spm_select ('FPList',folEPI,'^gr.*\.nii');
    N = cellstr(N);
    template = spm_select('FPList',folT1,'^Template_6.*\.nii');
    flowfil = spm_select('FPList',folT1,'^u.*\.nii');
    
    %rest_ExtractROITC --> extract signal for WM, CSF and Global Signal after each smooth
    %join_regressors(foldersuavizado_d,foldersuavizado_nd,mv_parameter,fisios,folder_d,folder_nd,folEPI)
    
    if strcmp(smooth,smooth3);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
        
    elseif strcmp(smooth,smooth6mm);
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth8mm);
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth10mm);
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth6y8mm);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth6y10mm);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth8y10mm);
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smoothtodos);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth6y12mm);
        
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        
    elseif strcmp(smooth,smooth8y12mm);
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth10y12mm);
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth6812mm);
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth61012mm);
        %Smoothing 6mm
        m = 6;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_6mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado6mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    elseif strcmp(smooth,smooth81012mm);
        %Smoothing 8mm
        m = 8;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_8mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado8mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 10mm
        m = 10;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_10mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado10mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
        %Smoothing 12mm
        m = 12;
        normalise_bold (template,flowfil,N,m)
        movefiles_sd_12mm(folEPI)
        
        ADataDir = strcat(folEPI,'\Preproc_sin_despike\Suavizado12mm');
        OutDir = ADataDir;
        [theROITimeCourses] = rest_ExtractROITC(ADataDir, AROIDef,OutDir);
        [theROITimeCourses] = rest_ExtractROITC_mod(ADataDir, AROIDef2,OutDir);
        
        DIR = ADataDir;
        join_regressors(mv_parameter,fisios,folEPI,DIR)
        
    end
    
    %======================================================================
    %Delete all unnecessary files
    %======================================================================
    borrar (folEPI,folT1)
    
    %----------------------------------------------------------------------
    
    fprintf('%-40s: %30s\n','Preprocessing Completed!',spm('time'))
    
    %======================================================================
    %======================================================================
    
end

fprintf('%-40s: %30s\n','Preprocessing for all subjects Completed!',spm('time'))

end