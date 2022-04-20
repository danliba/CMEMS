%climatologfa temperatura
clear all; close all; clc;
path0='D:\daniel\CMEMS';
MD='D:\daniel\CMEMS\climatologia';
most=1;
moen=12;
%rango lat
rangelat=[-0.5 0.5];
iter=0;
hdir=dir(fullfile(path0,'*.nc'));

%aviobj = QTWriter('High-resol-model-clim.mov','FrameRate',1);
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');


for im=most:1:moen
    disp(['Month: ' num2str(im)])
    iter=iter+1;
    for icmems=1:1:size(hdir,1)
        fns=hdir(icmems).name;
        %disp(['Month: ' num2str(im) '-' fns])
    
        lat=double(ncread(fns,'latitude'));
        lon=double(ncread(fns,'longitude'));
        time=double(ncread(fns,'time'))./24;
        depth=double(ncread(fns,'depth'));

        [yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1950,1,1,0,0,0));
        [loni,depi]=meshgrid(lon,depth);
        indxlat=find(rangelat(1)<=lat & lat<=rangelat(2));
        %new lat
        lat2=lat(indxlat);
        indx01=find(mo==im);
        numrec=length(indx01);
    
        for irec=1:1:numrec
            
            temp=nanmean(double(ncread(fns,'thetao',[1 indxlat(1) 1 indx01(irec)],...
            [length(lon) length(lat2) length(depth) 1],[1 1 1 1])),2);
            temp=permute(temp,[3 1 2]);
            
            masknan=double(~isnan(temp));
            temp(isnan(temp))=0;
            
            if irec==1
                tempm=zeros(size(temp));
                numnonnan2=zeros(size(temp));            
            end
            tempm=tempm+temp;
            numnonnan2=numnonnan2+masknan;
            
        end
        tempmi=tempm./numnonnan2;
        maskcl=double(~isnan(tempmi));
        if icmems==1
            tempi=zeros(size(tempmi));
            numnonnancl=zeros(size(tempmi));
        end
        tempi=tempi+tempmi;
        numnonnancl=numnonnancl+maskcl;
    end
    tempi=tempi./numnonnancl;
    months(im,1)=im; 
    TEMPs(:,:,iter)=tempi;
    
    [c,h]=contourf(loni,-depi,TEMPs(:,:,iter),[12:1:30],'k:');
    colorbar; clabel(c,h);
    caxis([12 30]);
    shading flat;
    colormap jet
    title(num2str(im));
    
    pause(1)
%     M1=getframe(gcf);
%     writeMovie(aviobj, M1);  
    clf
end
%close(aviobj);
%guardar
mfile=fullfile(MD,'Climatologia_temp');
save(mfile,'TEMPs','loni','depi','months');
