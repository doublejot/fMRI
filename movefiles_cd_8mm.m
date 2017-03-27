function movefiles_cd_8mm(folEPI)

%-----------------------------------------------------------------------
% Job saved on 15-Mar-2017 16:59:37 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {folEPI};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'Preproc_con_despike';
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent(1) = cfg_dep('Make Directory: Make Directory ''Preproc_con_despike''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'Suavizado8mm';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {folEPI};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^sw.*';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^sw)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''Suavizado8mm''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));

output_list = spm_jobman('run',matlabbatch);

end