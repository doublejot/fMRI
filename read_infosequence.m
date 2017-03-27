function [t,c,r]=read_infosequence(folEPI,acquorder)

[info] = spm_select('FPList',folEPI,'info.*\.txt');
    fid = fopen(info, 'r');
    tline1 = fgetl(fid); %delete the files from txt including patient's name
    tline2 = fgetl(fid);
    tline3 = fgetl(fid);
    tline4 = fgetl(fid);
    tline5 = fgetl(fid);
    tline6 = fgetl(fid);
    opt = {-inf, 'endofline','','whitespace',' \b\t\r\n', 'collectoutput',1};
    fmt = '%s%s';
    data = textscan(fid,fmt,opt{:});
    fid = fclose(fid);
    data = num2cell(data{1});
    scanner = data{6,2};
    scanner = scanner{1,1};
    %----------------------------------------------------------------------
    
    [info] = spm_select('FPList',folEPI,'info.*\.txt');
    fid = fopen(info, 'r');
    tline1 = fgetl(fid);
    tline2 = fgetl(fid);
    tline3 = fgetl(fid);
    tline4 = fgetl(fid);
    tline5 = fgetl(fid);
    tline6 = fgetl(fid);
    tline7 = fgetl(fid);
    tline8 = fgetl(fid);
    tline9 = fgetl(fid);
    tline10 = fgetl(fid);
    tline11 = fgetl(fid);
    tline12 = fgetl(fid);
    opt = {-inf, 'endofline','','whitespace',' \b\t\r\n', 'collectoutput',1};
    fmt = '%s%s';
    data = textscan(fid,fmt,opt{:});
    fid = fclose(fid);
    data = num2cell(data{1});
    
    
    if strcmp(scanner,'Philips')
        tr = data{5,2};
        tr= tr{1};
        t= str2num(tr);
        t = t/1000;
        vo= data{27,1};
        vo=vo{1};
        vol=str2num(vo); %#ok<ST2NM>
        numberslices = data{29,1};
        numberslices= numberslices{1};
        c= str2num(numberslices); %#ok<ST2NM>
        order = acquorder;
    end
    
    if strcmp(scanner,'SIEMENS')
        tr = data{5,2};
        tr= tr{1};
        t= str2num(tr);
        t= t/1000;
        vo= data{27,1};
        vo=vo{1};
        vol=str2num(vo); %#ok<ST2NM>
        numberslices = data{29,1};
        numberslices= numberslices{1};
        c= str2num(numberslices);
        order1 = data{58,1};
        order2 = data{58,2};
        order1 = order1{1};
        order2 = order2{1};
        order = strcat(order1,order2);
    end
    
    if strcmp(order,'Ascending');
        o = [1:1:c];
    elseif strcmp(order,'Descending');
        o = [c:-1:1];
    elseif strcmp(order,'InterleavedEven');
        o = [2:2:c 1:2:c];
    elseif strcmp(order,'InterleavedOdd');
        o = [1:2:c 2:2:c];
    end
    
    %obtain reference slice
    reference = num2cell(o);
    middle = c/2;
    reference = reference{middle};
    r = reference;
    
    %----------------------------------------------------------------------
    %Sequence Parameters
    %----------------------------------------------------------------------
    TR = t;
    num_slices = c;
    ref_slice  = r;
    slice_time = TR/num_slices;
    slice_gap  = slice_time;
    slice_ord  = o;



end