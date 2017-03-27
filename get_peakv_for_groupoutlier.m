function get_peakv_for_groupoutlier(folEPI)

%Find and print a plot with the outliers after estimate the first level
%analysis
%INPUT = the folder where is the Con image of one single subject

%==========================================================================
%First of all get the peak value for the images
%==========================================================================
% [ScaleFactors] = art_percentscale;

folCon = strcat(folEPI,'\Preproc_con_despike\Suavizado8mm\1st_level_Mv_wmcsf_Regressor');
a = spm_select('FPList',folCon,'^con.*\.nii');

if strcmp (a,'')
    folCon = strcat(folEPI,'\Preproc_con_despike\Suavizado6mm\1st_level_Mv_wmcsf_Regressor');
    a = spm_select('FPList',folCon,'^con.*\.nii');
    
elseif strcmp (a,'')
    folCon = strcat(folEPI,'\Preproc_con_despike\Suavizado10mm\1st_level_Mv_wmcsf_Regressor');
    a = spm_select('FPList',folCon,'^con.*\.nii');
end


% folderCon = 'E:\IMAGENES_PRUEBA\ND_Convertidos\Controls\CONT_003\1_501_FE_EPI_20110615\Preproc_con_despike\Suavizado6mm\1st_level_All_Regressors\'

Rimages = spm_select('FPList',folCon,'^con_.*\.nii');

    [ResultsFolder, temp ] = fileparts(Rimages(1,:));
    [temp, ResultsName ] = fileparts(ResultsFolder);
    
 aMaskimages = spm_select('List',ResultsFolder,'^mask'); 
 imgmask = fullfile(ResultsFolder,aMaskimages);


try 
    %  v2.2 logic
    % Try to find the peak value of design regressor, and the
    % the contrast sum for each contrast, assuming SPM.mat is there.
    SPMfile = fullfile(ResultsFolder,'SPM.mat');
    load(SPMfile);
    upu = SPM.xX.X(:,1);
    jpeak =[];
    for j = 2:length(upu)-1
        if ( upu(j) > upu(j-1) & upu(j) >= upu(j+1) & upu(j) > 0)  % peak in timeseries
            jpeak = [ jpeak upu(j) ];
        end
    end
    %jpeak = round(100*jpeak);       
    %jpeakmode = 0.01*mode(jpeak);   % 'mode' not in Matlab 6.5
    [ jpa, jpb ] = max(hist(jpeak,[0:0.01:max(jpeak)]));
    jpeakmode = 0.01*(jpb-1);
    for qqi = 1:size(Rimages,1)
        ConImage = Rimages(qqi,:);
        [ upx, upy, upz ] = fileparts(ConImage);
        lenCon = length(upy);
        %  Just in case the user is entering beta or spm images...
        if ('con' == upy(1:3) )   % scale the con images
            ConNum = str2num(upy(lenCon-2:lenCon));
            uu = SPM.xCon(ConNum).c;
            lenuu = find(uu > 0);
            contrast_value(qqi) = sum(uu(lenuu));  % sum of positive contrast coefficients
        elseif ('bet' == upy(1:3) )   %  beta image
            contrast_value(qqi) = 1;  % OK for beta
        end
    end
    if isempty(jpeakmode)
        disp('art_percentscale: No peaks found. Check SPM.mat file.')
        return
    else
        disp('Automatically estimated peak and contrast scaling.'); end
catch  % couldn't generate automatic scaling for some reason
    disp('art_percentscale: Could not find SPM.mat file, or other problem');
    return
end

% Find the ResMS and last beta image in Results folder with the Images
   %R = spm_vol(Rimages);
   %nimages = size(R,1);
   %betaimages = spm_select('List',ResultsFolder,'^beta.*\.img$'); % for SPM5
   betaimages = spm_select('List',ResultsFolder,'^beta'); % for SPM12
   lastbeta = size(betaimages,1);
   Normimage = betaimages(lastbeta,:);
   words = [' Normalizing by ', Normimage]; disp(words);
   
   
   % The last beta image in the Results folder is the SPM-estimated
% constant term. Scale all images by the average value of the last
% beta image with the head mask to get percentage.
% Find the normalization coefficient
    Normimagep = fullfile(ResultsFolder,Normimage);
    Pb = spm_vol(Normimagep);
    Xb = spm_read_vols(Pb);
    Maska = spm_vol(imgmask);
    Mask = spm_read_vols(Maska);
    Mask = round(Mask);    % sometimes computed masks have roundoff error
% Find the global mean within the mask
    bmean = sum(Xb(find(Mask==1))); 
    bvox = length(find(Mask==1));   % number of voxels in mask
    bmean = bmean/bvox;             % mean of beta in the mask
    clear Xb
    
    
ScaleFactors(1) = jpeakmode;
ScaleFactors(2) = contrast_value(1);   
ScaleFactors(3) = bmean;
ratio = (jpeakmode/contrast_value(1))*100/bmean;
words1 = ['Peak value    = ',num2str(jpeakmode,3)];
words2 = ['Contrast sum  = ',num2str(contrast_value(1))];
words3 = ['Mean value    = ',num2str(bmean)];
words4 = ['(peak/contrast_sum)*100/bmean  = ',num2str(ratio)];
disp(words1)
disp(words2)
disp(words3)
disp(words4)

cd(folEPI)
peakv = ScaleFactors(1)

save('Peak_Value_Con.txt','peakv','-ascii'); %save the peak value in order
%to obtain after the mean peak value for all the subjects
  
%==========================================================================

end