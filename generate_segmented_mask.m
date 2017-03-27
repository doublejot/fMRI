function generate_segmented_mask (input,outputname,outdir,expression)

%Help for generate_segmented_mask (input,outputname,outdir,expression)
%input = the wm or csf segmented imaged
%output name = output name for the generated mask
%outdir = output directory
%threshold = threshold for apply to the mask

matlabbatch{1}.spm.util.imcalc.input = {input};
matlabbatch{1}.spm.util.imcalc.output = outputname;
matlabbatch{1}.spm.util.imcalc.outdir = {outdir};
matlabbatch{1}.spm.util.imcalc.expression = expression;
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

output_list = spm_jobman('run',matlabbatch);

end
