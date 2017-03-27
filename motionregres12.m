function motionregres12 (mv,folEPI)

%load rp file from spm_realign (m)

rpdiff=diff(mv);
rpdiff = [zeros(1,6);rpdiff];
motion12 = horzcat(mv, rpdiff);

cd(folEPI);
save('12motionregressors.txt','motion12','-ascii');

end
