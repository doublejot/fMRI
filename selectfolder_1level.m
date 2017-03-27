function [folEPI]=selectfolder_1level(i,dirsuj)

folder = dirsuj{i,1}; 
filesAndFolders = dir(folder);
dircell = struct2cell(filesAndFolders);
a = dircell{1,3};
b = dircell{1,4};

epi1 = regexpi(a,'EPI');
epi2 = regexpi(a,'ep2d');
epi3 = regexpi(b,'EPI');
epi4 = regexpi(b,'ep2d');

if epi1 >= 1
   folEPI = strcat(folder,a);
end

if epi2 >= 1
   folEPI = strcat(folder,b);
end

if epi3 >= 1
   folEPI = strcat(folder,b);
end

if epi4 >= 1
   folEPI = strcat(folder,b);
end

end