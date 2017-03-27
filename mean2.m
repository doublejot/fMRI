function mean2(folEPI)
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {folEPI};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = '2mean';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {folEPI};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^mean.*';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^mean.*)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.copyto(1) = cfg_dep('Make Directory: Make Directory ''2mean''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));

output_list = spm_jobman('run',matlabbatch);

end