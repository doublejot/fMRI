function second_level_2s_Ttest(Outdir,group1,group2,age,gender,mask)

%-----------------------------------------------------------------------
% Job saved on 20-Mar-2017 15:21:00 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {Outdir};
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = {group1
                                                           };
%%
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = {group2
                                                           };
%%
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [age];
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Edad';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 2;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 2;
%%
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = [gender];
%%
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'Genero';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 2;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 2;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {mask};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Grupo1 > Grupo2';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Grupo2 > Grupo1';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.results.conspec(1).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
matlabbatch{4}.spm.stats.results.conspec(1).thresh = 0.05;
matlabbatch{4}.spm.stats.results.conspec(1).extent = 0;
matlabbatch{4}.spm.stats.results.conspec(1).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(1).mask.none = 1;
matlabbatch{4}.spm.stats.results.conspec(2).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(2).contrasts = 2;
matlabbatch{4}.spm.stats.results.conspec(2).threshdesc = 'FWE';
matlabbatch{4}.spm.stats.results.conspec(2).thresh = 0.05;
matlabbatch{4}.spm.stats.results.conspec(2).extent = 0;
matlabbatch{4}.spm.stats.results.conspec(2).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(2).mask.none = 1;
matlabbatch{4}.spm.stats.results.conspec(3).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(3).contrasts = 1;
matlabbatch{4}.spm.stats.results.conspec(3).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(3).thresh = 0.001;
matlabbatch{4}.spm.stats.results.conspec(3).extent = 0;
matlabbatch{4}.spm.stats.results.conspec(3).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(3).mask.none = 1;
matlabbatch{4}.spm.stats.results.conspec(4).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(4).contrasts = 2;
matlabbatch{4}.spm.stats.results.conspec(4).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(4).thresh = 0.001;
matlabbatch{4}.spm.stats.results.conspec(4).extent = 0;
matlabbatch{4}.spm.stats.results.conspec(4).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(4).mask.none = 1;
matlabbatch{4}.spm.stats.results.units = 1;
matlabbatch{4}.spm.stats.results.export{1}.ps = true;
matlabbatch{4}.spm.stats.results.export{2}.pdf = true;

output_list = spm_jobman('run', matlabbatch);

end
