function [folEPI,folT1] = select_folders(dirsuj,i)

folder = dirsuj{i,1}; 
filesAndFolders = dir(folder);
dircell = struct2cell(filesAndFolders);
a = dircell{1,3};
b = dircell{1,4};

epi1 = regexpi(a,'EPI');
epi2 = regexpi(a,'ep2d');
epi3 = regexpi(b,'EPI');
epi4 = regexpi(b,'ep2d');
t1 = regexpi(a, 'T1');
t2 = regexpi(b, 'T1');

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

if t1 >= 1
   folT1 = strcat(folder,a);
end

if t2 >= 1
   folT1 = strcat(folder,b);
end

end