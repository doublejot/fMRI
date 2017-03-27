function [ Xp, Yp, Zp ] = rmove(New,imagedim,Baseline);
%  P.mat transforms voxel coordinates to x,y,z position in mm.
%  New is P.mat for image, Baseline is P(1).mat for baseline image
%  dim is 3D vector of image size.
%  Output is change in (x,y,z) position for every voxel on this image.
Mf = New - Baseline;
for i = 1:imagedim(1)
    for j = 1:imagedim(2)
        for k = 1:imagedim(3)
            Xp(i,j,k) = Mf(1,1)*i+Mf(1,2)*j+Mf(1,3)*k+Mf(1,4);
            Yp(i,j,k) = Mf(2,1)*i+Mf(2,2)*j+Mf(2,3)*k+Mf(2,4);
            Zp(i,j,k) = Mf(3,1)*i+Mf(3,2)*j+Mf(3,3)*k+Mf(3,4);
        end
    end
end