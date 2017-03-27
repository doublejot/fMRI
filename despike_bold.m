function despike_bold(Pimages,Filt)

spm('defaults','FMRI')
global defaults

CLIP = 1;
Despikedef = 4;
Despike = 4;
FiltType = Filt;

if FiltType == 1
    %  17-tap high pass filter with the coefficients sum of zero
    afilt = [ -1 -1 -1 -1 -1.5 -1.5 -2 -2 22 -2 -2 -1.5 -1.5 -1 -1 -1 -1];
    gain = 1.1/22;  % gain is set for small bias for HRF shape
elseif FiltType == 2
    %  37-tap high pass filter, Takes about 2 sec per image.
    afilt = [ -ones(1,18)  36  -ones(1,18) ];
    gain = 1/36;  % gain is set for small avg. bias to block length 11.
elseif FiltType == 3
    % Skip filtering step. nfilt =17 for clipping baseline.
    afilt = [ -ones(1,7) 0 14 0  -ones(1,7)  ];  % dummy values used only to set nfilt.
    gain = 1/14;
elseif FiltType == 4
    % Movie filter, to possibly see single HRFs in art_movie
    % Filter is matched to HRF shape, assuming TR=2 sec.
    afilt = [ -1 -1 -1.2 -1.2 -1.2 -1.2 -1 -1 2.5 6.3 6.3 2.5 0 -1 -1 -1.2 -1.2 -1.2 -1.2 -1 -1];
    gain = 1/14;
end

nfilt = length(afilt); 
if mod(nfilt,2) == 0   % check that filter length is odd.
    disp('Warning from art_despike: Filter length must be odd')
    return
end

if abs(mean(afilt)) > 0.000001
    disp('Warning from art_despike: Filter coefficients must sum to zero.')
    return
end
lag = (nfilt-1)/2;  % filtered value at 9 corresponds to a peak at 5.
% Convert despike threshold in percent to fractional mulitplier limits
spikeup = 1 + 0.01*Despike;
spikedn = 1 - 0.01*Despike;

    fprintf('\n NEW IMAGE FILES WILL BE CREATED');
    fprintf('\n The filtered scan data will be saved in the same directory');
    fprintf('\n with "d" (for despike or detrend) pre-pended to their filenames.\n');
    prechar = 'd';

    disp('Spikes are clipped before high pass filtering')
    disp('Spikes beyond this percentage value are clipped.')
    disp(Despike)
    
  if FiltType ~= 3
    disp('The high pass filter is:');
    disp(afilt);
    wordsgain = [ 'With gain =' num2str(gain) ];
    disp(wordsgain);
else
    disp('No filtering will be done.');
  end

%--------------------------------------------------------------------------
% FILTER AND DESPIKE IMAGES
% Process all the scans sequentially
% Start and End are padded by reflection, e.g. sets data(-1) = data(3).
% Initialize lagged values for filtering with reflected values
% Near the end, create forward values for filtering with reflected values.

% Find mean image
    P = spm_vol(Pimages);
    startdir = pwd;
    cd(fileparts(Pimages(1,:)));
    [ xaa, xab, xac ] = fileparts(Pimages(1,:));
    xaab = strtok(xab,'_');   % trim off the volume number
    %meanimagename = [ 'mean' xaab xac ];
    meanimagename = [ 'meen' xaab '.img' ];
    local_mean_ui(P,meanimagename);
    Pmean = spm_vol(meanimagename);
    Vmean = spm_read_vols(Pmean);
    nscans = size(Pimages,1);

% Initialize arrays with reflected values.
% Y4 = zeros(nfilt,size(Vmean,1),size(Vmean,2),size(Vmean,3));
% Y4s = zeros(1,size(Vmean,1),size(Vmean,2),size(Vmean,3));
disp('Initializing filter inputs for starting data')
for i = 1:(nfilt+1)/2
    i2 = i + (nfilt-1)/2;
    Y4(i2,:,:,:) = spm_read_vols(P(i));
    i3 = (nfilt+1) -  i2;
    if i > 1   % i=1 then i3 = i2.
        Y4(i3,:,:,:) = Y4(i2,:,:,:);
    end
end

movmean = squeeze(mean(Y4,1));
   for i = 1:nfilt
       Y4s = squeeze(Y4(i,:,:,:));
       Y4s = min(Y4s,spikeup*movmean);
       Y4s = max(Y4s,spikedn*movmean);
       Y4(i,:,:,:) = Y4s;
   end
   
% Main Loop
% Speed Note: Use Y4(1,:,:,:) = spm_read_vols(P(1));  % rows vary fastest
disp('Starting Main Loop')
for i = (nfilt+1)/2:nscans+(nfilt-1)/2
    if i <= nscans
        Y4(1,:,:,:) = spm_read_vols(P(1));
%         Y4(nfilt,:,:,:) = spm_read_vols(P(i));
    else   % Must pad the end data with reflected values.
        i2 = i - nscans;  
        Y4(i2,:,:,:) = spm_read_vols(P(nscans-i2));
%         Y4(nfilt,:,:,:) = spm_read_vols(P(nscans-i2)); % Y4(i2,:,:,:);
    end
    
    
  %  Incremental clipping is done here
    if CLIP == 1 & FiltType == 3   % only despiking
        movmean2 = mean(Y4,1);
        movmean = squeeze(movmean2);  % just a speed thing.
        % This lag is from FiltType = 3
        Y4s = squeeze(Y4(nfilt-lag,:,:,:));  % centered for despike only
        Y4s = min(Y4s,spikeup*movmean);
        Y4s = max(Y4s,spikedn*movmean);
        Yn2 = squeeze(Y4s);
    elseif CLIP == 1 & FiltType ~= 3   % combined despike and filter
        movmean2 = mean(Y4,1);
        movmean = squeeze(movmean2);  % just a speed thing.
        Y4s = squeeze(Y4(nfilt,:,:,:));  % predictive despike to use in filter
        Y4s = min(Y4s,spikeup*movmean);
        Y4s = max(Y4s,spikedn*movmean);
        Y4(nfilt,:,:,:) = Y4s;
    end
    if FiltType ~= 3     % apply filter to original or despiked data
        Yn = filter(afilt,1,Y4,[],1);
        Yn2 = squeeze(Yn(nfilt,:,:,:));
        Yn2 = gain*Yn2 + Vmean;
    end
    
 
  % Prepare the header for the filtered volume, with lag removed.
    V = spm_vol(P(i-lag).fname);
    v = V;
    [dirname, sname, sext ] = fileparts(V.fname);
    sfname = [ prechar, sname ];
    filtname = fullfile(dirname,[sfname sext]);
    v.fname = filtname;
    spm_write_vol(v,Yn2); 
    % Slide the read volumes window up.
    showprog = [' Filtered volume   ', sname, sext ];
    disp(showprog); 
    for js = 1:nfilt-1
        Y4(js,:,:,:) = Y4(js+1,:,:,:);
    end 
end

zout = 1;
fprintf('\nDone with despike and high pass filter!\n');
cd(startdir)

% Plot a sample voxel
%demovoxel = round( size(Vmean)/3 );
%xin = art_plottimeseries(Pimages  ,demovoxel);
%SubjectDir = fileparts(Pimages(1,:));   
%if strcmp(spm_ver,'spm5') 
 %   realname = [ '^d' '.*\.(img$|nii$)'  ];
%	Qimages = spm_select('FPList',[SubjectDir ], realname);
%else   % spm2
 %   realname = ['d' '*.img'];
%	Qimages = spm_get('files',[SubjectDir ], realname);
%end
%xhi = art_plottimeseries( Qimages  ,demovoxel);
%xscanin = [ 1:nscans];
%xscanout = [ 1:size(Qimages,1) ];
%figure(99)
%plot(xscanin,xin,'r',xscanout,xhi,'b');
%titlewords = ['Timeseries before (red) and after (blue) for Voxel '  num2str(demovoxel)];
%title(titlewords)

end
