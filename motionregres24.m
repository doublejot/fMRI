function motionregres24(mv,folEPI)

%load rp_file from spm_realignment

mh=[zeros(1,6); mv(1:end-1,:)];
R=[mv mv.^2 mh mh.^2];

cd(folEPI)
save('24motionregressors.txt','R','-ascii');

end