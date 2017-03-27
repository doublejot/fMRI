function normalise_bold (template,flowfil,N,m)
matlabbatch{1}.spm.tools.dartel.mni_norm.template = {template};
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.flowfield = {flowfil};
%%
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.images = N;
    
%%
matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [m m m];

output_list = spm_jobman('run',matlabbatch);

end
