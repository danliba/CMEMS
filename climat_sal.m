%Climatologia salt
clear all; close all; clc;
path0='D:\descargas\CMEMS';
MD='D:\descargas\CMEMS\climatologia';
%time
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
            
            salt=nanmean(double(ncread(fns,'so',[1 indxlat(1) 1 indx01(irec)],...
            [length(lon) length(lat2) length(depth) 1],[1 1 1 1])),2);
            salt=permute(salt,[3 1 2]);
            
            masknan=double(~isnan(salt));
            salt(isnan(salt))=0;
            
            if irec==1
                saltm=zeros(size(salt));
                numnonnan2=zeros(size(salt));            
            end
            saltm=saltm+salt;
            numnonnan2=numnonnan2+masknan;
            
        end
        saltmi=saltm./numnonnan2;
        maskcl=double(~isnan(saltmi));
        if icmems==1
            salcl=zeros(size(saltmi));
            numnonnancl=zeros(size(saltmi));
        end
        salcl=salcl+saltmi;
        numnonnancl=numnonnancl+maskcl;
    end
    salcl=salcl./numnonnancl;
    months(im,1)=im; 
    SALTs(:,:,iter)=salcl;
    
    [c,h]=contourf(loni,-depi,SALTs(:,:,iter),[33:0.1:36],'k:');
    colorbar; clabel(c,h);
    caxis([34 36]);
    shading flat;
    colormap parula
    title(num2str(im));
    
    pause(1)
%     M1=getframe(gcf);
%     writeMovie(aviobj, M1);  
    clf
end
%close(aviobj);
%guardar
mfile=fullfile(MD,'Climatologia_sal');
save(mfile,'SALTs','loni','depi','months');
