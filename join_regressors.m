function join_regressors(mv_parameter,fisios,folEPI,DIR)

%Get the movement parameters

if mv_parameter == 6
    movr = spm_select('FPList',folEPI,'^rp_ah.*\.txt');
elseif mv_parameter ~= 6
    movr = spm_select('FPList',folEPI,'motion.*\.txt');
end

movr = load(movr);

%Get the physiological regressors

 RealizarFisios = string('Y');
 RealizarFisios = {RealizarFisios};
 realizarfisios = string('y');
 realizarfisios = {realizarfisios};
 NoRealizar = string('N');
 NoRealizar = {NoRealizar};
 norealizar = string('n');
 norealizar = {norealizar};
 

 if strcmp(fisios,RealizarFisios) || strcmp(fisios,realizarfisios);
     physio = spm_select('FPList',folEPI,'physio_regressors.*\.txt');      

 if strcmp(physio, '');
     fprintf('%-40s: %30s\n','No se incluirán las variables fisiológicas en los regresores al no existir el archivo',spm('time'))
     
 elseif length(physio) > 1;
     
     physio = load(physio);
 
 end 
    
 elseif strcmp(fisios,NoRealizar) || strcmp(fisios,norealizar);
     physio = '';     
      fprintf('%-40s: %30s\n','No hay fichero de variables fisiológicas',spm('time'))
  end 
 
%--------------------------------------------------------------------------

%Get the other regressors, WM+CSF, Global Signal

 wm_csf = spm_select('FPList',DIR,'ROISignals.*\.txt');
    glb = spm_select('FPList',DIR,'ROIGlobal.*\.txt');
    
    wm_csf = load(wm_csf);
    glb = load(glb);
    cd(DIR);
    
%join the regressors

%1. Movement + WM + CSF    
         regresor1 = horzcat(movr,wm_csf);
         save('Mv_wmcsf_Regressor.txt','regresor1','-ascii');

%2. Movement + WM + CSF + GS
         regresor2 = horzcat(movr,wm_csf,glb);
         save('Mv_wmcsf_global_Regressor.txt','regresor2','-ascii');
         
 if  length(physio) > 1;
    
      %3. Movement + WM + CSF + Physiological
             regresor3 = horzcat(movr,wm_csf,physio);
             save('Mv_wmcsf_physio_Regressor.txt','regresor3','-ascii');

      %4. Movement + WM + CSF + GS + Physiological
             regresor4 = horzcat(movr,wm_csf,glb,physio);
             save('All_Regressors.txt','regresor4','-ascii')
 end
end

%Old function--------------------------------------------------------------
% 
% %for the images with despike
% 
% folders = dir(folder_d);
% dirFlags = [folders.isdir];
% subFolders = folders(dirFlags);
% 
% smooths_d = length(subFolders) -2;
% 
% for sm = 1:smooths_d    
%    foldersuavizado_d{sm} = strcat(folder_d,subFolders(sm+2,1).name);
%    foldersuavizado_d(:,find(all(cellfun(@isempty,foldersuavizado_d),1))) = []; 
% end
% 
% for a = 1:length(foldersuavizado_d)
%     DIR = foldersuavizado_d(a);
%     DIR = DIR{1,1};
%     wm_csf = spm_select('FPList',DIR,'ROISignals.*\.txt');
%     glb = spm_select('FPList',DIR,'ROIGlobal.*\.txt');
%     
%     wm_csf = load(wm_csf);
%     glb = load(glb);
%     cd(DIR);
%     
% %1. Movement + WM + CSF    
%          regresor1 = horzcat(movr,wm_csf);
%          save('Mv_wmcsf_Regressor.txt','regresor1','-ascii');
%          
% %2. Movement + WM + CSF + GS
%          regresor2 = horzcat(movr,wm_csf,glb);
%          save('Mv_wmcsf_global_Regressor.txt','regresor2','-ascii');
%          
%  if  length(physio) > 1;
%     
%         %3. Movement + WM + CSF + Physiological
%                  regresor3 = horzcat(movr,wm_csf,physio);
%                  save('Mv_wmcsf_physio_Regressor.txt','regresor3','-ascii');
% 
%         %4. Movement + WM + CSF + GS + Physiological
%                  regresor4 = horzcat(movr,wm_csf,glb,physio);
%                  save('All_Regressors.txt','regresor4','-ascii')
%  end
% 
% end
% 
% %--------------------------------------------------------------------------
% 
% %for the images without despike
% 
% foldersnd = dir(folder_nd);
% dirFlagsnd = [foldersnd.isdir];
% subFoldersnd = foldersnd(dirFlagsnd);
% 
% smooths_nd = length(subFoldersnd) -2;
% 
% 
% for smnd = 1:smooths_nd    
%    foldersuavizado_nd{smnd} = strcat(folder_nd,subFoldersnd(smnd+2,1).name);
%    foldersuavizado_nd(:,find(all(cellfun(@isempty,foldersuavizado_nd),1))) = []; 
% end
% 
% for nd = 1:length(foldersuavizado_nd);
%     DIR2 = foldersuavizado_nd(nd);
%     DIR2 = DIR2{1,1};
%     wm_csf2 = spm_select('FPList',DIR2,'ROISignals.*\.txt');
%     glb2 = spm_select('FPList',DIR2,'ROIGlobal.*\.txt');
%     
%     wm_csf2 = load(wm_csf2);
%     glb2 = load(glb2);
%     
%     cd(DIR2);
%     
% %1. Movement + WM + CSF    
%          regresor1 = horzcat(movr,wm_csf);
%          save('Mv_wmcsf_Regressor.txt','regresor1','-ascii');
%          
% %2. Movement + WM + CSF + GS
%          regresor2 = horzcat(movr,wm_csf,glb);
%          save('Mv_wmcsf_global_Regressor.txt','regresor2','-ascii');
%          
% if length(physio) > 1;
%     
%         %3. Movement + WM + CSF + Physiological
%                  regresor3 = horzcat(movr,wm_csf,physio);
%                  save('Mv_wmcsf_physio_Regressor.txt','regresor3','-ascii');
% 
%         %4. Movement + WM + CSF + GS + Physiological
%                  regresor4 = horzcat(movr,wm_csf,glb,physio);
%                  save('All_Regressors.txt','regresor4','-ascii')
%                  
%  end                 
%     
% end
% 
% 
% end
