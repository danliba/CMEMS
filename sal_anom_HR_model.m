%%anomalia mensual 1993-19999

clear all; close all; clc;
path0='D:\descargas\CMEMS';
pathcl='D:\descargas\CMEMS\climatologia'; MD='D:\descargas\CMEMS\climatologia';
hdir=dir(fullfile(path0,'*.nc'));
fn='Climatologia_sal.mat';
load(fullfile(pathcl,fn));
%time
yrst=1993;
yren=2018;
most=1;
moen=12;
moen0=moen;
%rango lat
rangelat=[-0.5 0.5];
iter=0;
aviobj = QTWriter('High-resol-model-anom.mov','FrameRate',1);
figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
for iy=yrst:1:yren
    if iy>yrst
        most=1;
    end
    
    if iy==yren
        moen=moen0;
        
    else
        moen=12;
    end
    
    for im=most:1:moen
        disp(datestr(datenum(iy,im,28,0,0,0)));
        
        daynum=datestr(datenum(iy,im,28,0,0,0));
       
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
            indx01=find(yr==iy&mo==im);
            numrec=length(indx01);
            %new lat
            lat2=lat(indxlat);
            
            for irec=1:1:numrec
            
            salt=nanmean(double(ncread(fns,'so',[1 indxlat(1) 1 indx01(irec)],...
            [length(lon) length(lat2) length(depth) 1],[1 1 1 1])),2);
            salt=permute(salt,[3 1 2]);
            sst=nanmean(double(ncread(fns,'thetao',[1 indxlat(1) 1 indx01(irec)],...
            [length(lon) length(lat2) length(depth) 1],[1 1 1 1])),2);
            sst=permute(sst,[3 1 2]);
            
            masknan=double(~isnan(salt));
            salt(isnan(salt))=0;
            masknan2=double(~isnan(sst));
            sst(isnan(sst))=0;
                if irec==1
                    saltm=zeros(size(salt));
                    numnonnan2=zeros(size(salt));
                    sstm=zeros(size(sst));
                    numnonnan=zeros(size(sst));
                end
            saltm=saltm+salt;
            numnonnan2=numnonnan2+masknan;
            sstm=sstm+sst;
            numnonnan=numnonnan+masknan2;
            end
            saltmi=saltm./numnonnan2;
            sstmi=sstm./numnonnan;
            SALTanom=saltmi-SALTs(:,:,im);
            pr=0;
            pt = theta(saltmi,sstmi,depi,pr);
            sigma0=sigmat(pt,salt);
            
         end
        [c,h]=contourf(loni,sigma0,SALTanom,[-1:0.1:1],'k:');
        colorbar; clabel(c,h);
        caxis([-2 2]);
        shading flat;
        cmocean('balance');
        title(['SSS anom ' daynum]);
        c=colorbar;
        c.Label.String='Salinidad (ups)';
        set(gca, 'YDir','reverse');
        ylabel('Sigma theta');
        ylim([20.8 26.8]);
        set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);
        pause(1)
        M1=getframe(gcf);
        writeMovie(aviobj, M1);  
        clf
    end     
end
close(aviobj);
