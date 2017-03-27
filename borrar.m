function borrar (folEPI,folT1)

filestodelete1 = spm_select('FPList',folEPI,'^ah.*\.nii');
filestodelete2 = spm_select('FPList',folEPI,'^h.*\.nii');
filestodelete3 = spm_select('FPList',folEPI,'^d.*\.nii');
filestodelete4 = spm_select('FPList',folEPI,'^gdrah.*\.nii');
filestodelete5 = spm_select('FPList',folEPI,'^r.*\.nii');
filestodelete6 = spm_select('FPList',folEPI,'^gmean.*\.nii');
filestodelete7 = spm_select('FPList',folEPI,'^Bad.*\.txt');
filestodelete8 = spm_select('FPList',folEPI,'^me');
filestodelete9 = spm_select('FPList',folEPI,'^Art.*\.nii');
filestodelete10 = spm_select('FPList',folEPI,'^grah.*\.nii');
filestodelete11 = spm_select('FPList',folT1,'^Template_1.*\.nii');
filestodelete12 = spm_select('FPList',folT1,'^Template_2.*\.nii');
filestodelete13 = spm_select('FPList',folT1,'^Template_3.*\.nii');
filestodelete14 = spm_select('FPList',folT1,'^Template_4.*\.nii');
filestodelete15 = spm_select('FPList',folT1,'^Template_5.*\.nii');
filestodelete16 = spm_select('FPList',folT1,'^Template_0.*\.nii');
% filestodelete17 = spm_select('FPList',folT1,'^u.*\.nii');
filestodelete18 = spm_select('FPList',folT1,'^rc.*\.nii');
filestodelete19 = spm_select('FPList',folT1,'^swc.*\.nii');
filestodelete20 = spm_select('FPList',folT1,'^c1.*\.nii');
filestodelete21 = spm_select('FPList',folT1,'^c2.*\.nii');
filestodelete22 = spm_select('FPList',folT1,'^c3.*\.nii');
filestodelete23 = spm_select('FPList',folT1,'^g2.*\.nii');
filestodelete24 = spm_select('FPList',folT1,'^mean.*\.nii');

filesdelete = strvcat(filestodelete1, filestodelete2,filestodelete3,filestodelete4,filestodelete5,filestodelete6,filestodelete7,filestodelete8,filestodelete9,filestodelete10,filestodelete11,filestodelete12,filestodelete13,filestodelete14,filestodelete15,filestodelete16,filestodelete18,filestodelete19,filestodelete20,filestodelete21,filestodelete22,filestodelete23,filestodelete24);

filesremoved = cellstr(filesdelete);


lengthrem = size(filesremoved);

lengthrem = lengthrem(1);

for g = 1:lengthrem
    deletef = filesremoved{g,1};
    delete(deletef)
end

end