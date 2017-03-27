function coregister_bold(imaget1,imagemean,otherimages)
%referencia es la imagen estructural T1 sin tocar nii,1
%source es la mean nii,1
%other son el set de imagenes nii,1


% matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {'G:\prueba\MCI_001\1_301_T1W_3D_TFE_20110927\20110927_001_T1W_3D_TFE.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {imaget1};
% matlabbatch{1}.spm.spatial.coreg.estwrite.source = {'G:\prueba\MCI_001\1_501_FE_EPI_20110927\20110927_001_FE_EPI_004.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {imagemean};

% matlabbatch{1}.spm.spatial.coreg.estwrite.other = {
%                                                    'G:\prueba\MCI_001\1_501_FE_EPI_20110927\Preproc_sin_despike\Suavizado12mm\swgrah20110927_001_FE_EPI_001.nii,1'
%                                                    'G:\prueba\MCI_001\1_501_FE_EPI_20110927\Preproc_sin_despike\Suavizado12mm\swgrah20110927_001_FE_EPI_004.nii,1'
%                                                    'G:\prueba\MCI_001\1_501_FE_EPI_20110927\Preproc_sin_despike\Suavizado12mm\swgrah20110927_001_FE_EPI_005.nii,1'
%                                                    'G:\prueba\MCI_001\1_501_FE_EPI_20110927\Preproc_sin_despike\Suavizado12mm\swgrah20110927_001_FE_EPI_006.nii,1'
%                                                    'G:\prueba\MCI_001\1_501_FE_EPI_20110927\Preproc_sin_despike\Suavizado12mm\swgrah20110927_001_FE_EPI_007.nii,1'
%                                                    };

matlabbatch{1}.spm.spatial.coreg.estwrite.other = otherimages;
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'g';

output_list = spm_jobman('run',matlabbatch);

end
