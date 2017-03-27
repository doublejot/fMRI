function generate_segmented_globalmask (GC1,GC2,GC3,outdir)

matlabbatch{1}.spm.util.imcalc.input = {GC1
    GC2
    GC3};
matlabbatch{1}.spm.util.imcalc.output = 'globalmask';
matlabbatch{1}.spm.util.imcalc.outdir = {outdir};
matlabbatch{1}.spm.util.imcalc.expression = 'i1+i2+i3>0.99';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

output_list = spm_jobman('run',matlabbatch);

%                                         'E:\Imagenes\ND_Convertidos\Controls\CONT_003\1_301_T1W_3D_TFE_20110615\gswc120110615_001_301_T1W_3D_TFE_SENSE_T1W_3D_TFE.nii,1'
%                                         'E:\Imagenes\ND_Convertidos\Controls\CONT_003\1_301_T1W_3D_TFE_20110615\gswc220110615_001_301_T1W_3D_TFE_SENSE_T1W_3D_TFE.nii,1'
%                                         'E:\Imagenes\ND_Convertidos\Controls\CONT_003\1_301_T1W_3D_TFE_20110615\gswc320110615_001_301_T1W_3D_TFE_SENSE_T1W_3D_TFE.nii,1'




end