function local_mean_ui(P,meanimagename)
% Batch adaptation of spm_mean_ui, with image name added.
% meanimagename is a character string, e.g. 'meansr.img'
% FORMAT spm_mean_ui
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience
% John Ashburner, Andrew Holmes
% $Id: spm_mean_ui.m 1096 2008-01-16 12:12:57Z john $
Vi = spm_vol(P);
n  = prod(size(Vi));
spm_check_orientations(Vi);

%-Compute mean and write headers etc.
%-----------------------------------------------------------------------
fprintf(' ...computing')
Vo = struct(	'fname',	meanimagename,...
		'dim',		Vi(1).dim(1:3),...
		'dt',           [4, spm_platform('bigend')],...
		'mat',		Vi(1).mat,...
		'pinfo',	[1.0,0,0]',...
		'descrip',	'spm - mean image');

%-Adjust scalefactors by 1/n to effect mean by summing
parfor i=1:prod(size(Vi))
	Vi(i).pinfo(1:2,:) = Vi(i).pinfo(1:2,:)/n; end;

Vo            = spm_create_vol(Vo);
Vo.pinfo(1,1) = spm_add(Vi,Vo);
Vo            = spm_create_vol(Vo);


%-End - report back
%-----------------------------------------------------------------------
fprintf(' ...done\n')
fprintf('\tMean image written to file ''%s'' in current directory\n\n',Vo.fname)