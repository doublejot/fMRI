function normalise_T1 (template,flowfil,I,J,K)

%Template = Template6
%flowfil = flow fields (^u)
%I,J,K = c1,c2,c3
%s = smoothing, e.g. 8


matlabbatch{1}.spm.tools.dartel.mni_norm.template = {template};
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.flowfield = {flowfil};
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.images = {I
J
K};
matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [1 1 1];

output_list = spm_jobman('run',matlabbatch);

end
