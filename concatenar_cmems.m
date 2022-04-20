%%creating shell script to catt last day of the month and the month
clear all
close all
clc
%creating shell script
fid = fopen('concatenar_cmems_model.sh','wt');%cambiar a shell
%path
path1='D:\descargas\CMEMS';
hdir=dir(fullfile(path1,'CMEMS_Temperature_Dailymean_MERCATOR_*.nc'));
iter=0;
for icmems=1:1:size(hdir,1)
    fns=hdir(icmems).name;
    time=double(ncread(fns,'time'))./24;
    [yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));
    modelin=fns;
    modelout=sprintf('temp_sal_%d-%02d.nc',yr(1,1),mo(1,1));
    fnend=sprintf('%d-%02d',yr(1,1),mo(1,1));
    %cdo code
    re_name=['mv ', modelin, ' pre_', modelin, ';'];
    nco_ncks=['ncks -O --mk_rec_dmn ', 'time ','pre_',modelin,' ',modelin,';']; 
    nco_ncrcat=['ncrcat -h ',modelin,' ',modelout,' ',fnend,'.nc;'];
    nco_code=[re_name,nco_ncks,nco_ncrcat];
    fprintf(fid,'%s\n',nco_code);
    iter=iter+1;
end
fclose(fid);