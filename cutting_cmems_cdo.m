%mercatorglorys12v1_gl12_mean_19960630_R19960703
%cdo code cdo sellonlatbox,lon1,lon2,lat1,lat2 infile.nc outfile.nc
clear all
close all
clc
%creating shell script
fid = fopen('Cutcmems_model.sh','wt');%cambiar a shell
%path
path1='D:\descargas\CMEMS\ultimo_dia_del_mes';
hdir=dir(fullfile(path1,'m*.nc'));

for icmems=1:1:size(hdir,1)
    fns=hdir(icmems).name;
    lon1=140; lon2=280;
    lat1=-5; lat2=5;
    time=double(ncread(fns,'time'))./24;
    [yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));
    modelin=fns;
    modelout=sprintf('temp_sal_%d-%02d',yr(1,1),mo(1,1));
    %cdo code
    cdo_code=['cdo ', 'sellonlatbox',',',num2str(lon1),',',num2str(lon2),',',num2str(lat1),',',num2str(lat2),' ', modelin,' ', modelout,'_d.nc',';'];
    nco_code=['ncks ', '-d depth',',',num2str(0),',',num2str(32),' ', modelout,'_d.nc',' ',modelout,'_s.nc;'];
    select_variables=['cdo ','-selname',',','depth,latitude,longitude,so,thetao,time ',modelout,'_s.nc ',modelout,'.nc;'];
    rm_bash=['rm ',modelout,'_d.nc ',modelout,'_s.nc;'];
    code_sh=[cdo_code,nco_code,select_variables,rm_bash];
    fprintf(fid,'%s\n',code_sh);
end

fclose(fid);