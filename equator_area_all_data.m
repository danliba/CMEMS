%climatologfa temperatura
clear all; close all; clc;
path0='D:\daniel\CMEMS';
MD='D:\daniel\CMEMS\CMEMS_ecuatorial'; %save to path
most=1;
moen=12;
%rango lat
rangelat=[-0.1 0.1];
iter=0;
hdir=dir(fullfile(path0,'*.nc'));


% for im=most:1:1
%     disp(['Month: ' num2str(im)])
%     iter=iter+1;
jj=0;
    for icmems=1:1:size(hdir,1)
        fns=hdir(icmems).name;
        lat=double(ncread(fns,'latitude'));
        lon=double(ncread(fns,'longitude'));
        time=double(ncread(fns,'time'))./24;
        depth=double(ncread(fns,'depth'));

        [yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));
        [loni,depi]=meshgrid(lon,depth);
        indxlat=find(rangelat(1)<=lat & lat<=rangelat(2));
        lat2=lat(indxlat);
        
        
        for ida=1:1:length(da)
            jj=jj+1;
            indx01=find(da==ida);
            numrec=length(indx01);

            for irec=1:1:numrec

                temp=nanmean(double(ncread(fns,'thetao',[1 indxlat(1) 1 indx01(irec)],...
                [length(lon) length(lat2) length(depth) 1],[1 1 1 1])),2);
                temp=permute(temp,[3 1 2]);
                disp(datestr(datenum(yr(ida),mo(ida),ida)))

%                 [c,h]=contourf(loni,-depi,temp,[10:1:30],'k:');
%                 colorbar; clabel(c,h); ylim([-300 0]);
%                 caxis([12 30]);
%                 shading flat;
%                 colormap jet
%                 title(datestr(datenum(yr(ida),mo(ida),ida)));
% 
%             pause(0.5)
        %     M1=getframe(gcf);
        %     writeMovie(aviobj, M1);  
%             clf
            end
            tempis(:,:,jj)=temp;
            timeis(jj,1)=datenum(yr(ida),mo(ida),ida);
        end
    end

TEMPs=tempis(1:29,:,:);
lonis=loni(1:29,:);
DEPTHs=depi(1:29,:);

mfile=fullfile(MD,'all_equator_data_temp');
save(mfile,'TEMPs','lonis','DEPTHs','timeis','-v7.3');