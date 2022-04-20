%% CMEMS quality Climatology 
% UNFINISHED
clear all
clc
path0='D:\descargas\CMEMS';
fn='1999-12.nc';
fns=fullfile(path0,fn);
 
lat=double(ncread(fns,'latitude'));
lon=double(ncread(fns,'longitude'));
time=double(ncread(fns,'time'))./24;
depth=double(ncread(fns,'depth'));
  
[yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));
% 
[loni,lati]=meshgrid(lon,lat);

most=1;
moen=12;
 
iter=0;
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

for im=most:1:moen
    iter=iter+1;
    
    disp(['Month: ' num2str(im)])
        
        indx01=find(mo==im);
         numrec=length(indx01);
    
    for irec=1:1:numrec
        
        sst=double(ncread(fn,'thetao',[1 1 1 indx01(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1]));
        sst=sst(:,:,1);
        salt0=double(ncread(fn,'so',[1 1 1 indx01(irec)],...
            [length(lon) length(lat) length(depth) 1],[1 1 1 1]));
        salt=salt0(:,:,1);
        
        subplot(2,1,1)
        pcolor(loni,lati,salt');
        shading flat;cmocean('balance');
        caxis([32 36])
        colorbar;
        
        subplot(2,1,2)
        pcolor(loni,lati,sst');
        shading flat
        colorbar; cmocean('balance');
        title(num2str(irec));
        caxis([20 33])
        pause(1)
        clf
    end
end
        