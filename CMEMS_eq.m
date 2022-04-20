clear all
clc
fn='mayo.nc';
lon=double(ncread(fn,'longitude'));
lat=double(ncread(fn,'latitude'));
time=double(ncread(fn,'time'))./24;
[yr,mo,da]=datevec(double(time)+datenum(1950,1,1,0,0,0));

depth=double(ncread(fn,'depth'));

sal=nanmean(double(ncread(fn,'so')),4);
temp=nanmean(double(ncread(fn,'thetao')),4);


rangelat=[-0.1 0.1];
indxlat=find(rangelat(1)<=lat & lat<=rangelat(2));
lata=lat(indxlat);
%salinidad
sala=nanmean(sal(:,indxlat,:),2);
sali=permute(sala,[3 1 2]);

%temperatura
tempo=nanmean(temp(:,indxlat,:),2);
tempi=permute(tempo,[3 1 2]);

%densidad
[lonis,depis]=meshgrid(lon,depth);
pr=0;

pt = theta(sali,tempi,depis,pr);
sigma_CMEMS=sigmat(pt,sali);

%importar climatologías 
load('Climatologia_temp');
load('Climatologia_sal');
%hallar la anomalia de temp y sal
indxmo=find(months==mo(1)); 
indxdep=find(depi(:,1)>=0 & depi(:,1)<=350);
sst_anom=tempi-TEMPs(indxdep,:,indxmo);
sss_anom=sali-SALTs(indxdep,:,indxmo);

%% plot
figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

%primer panel
subplot(2,1,1)
[C,h]=contourf(lonis,-depis,tempi,30,'k:');h.LevelList=round(h.LevelList);
colormap(jet);title('Temperatura Subsuperficial 150E-80W','Fontsize',10)
clabel(C,h); colorbar; caxis([11 31]);
hold on
[C,h]=contour(lonis,-depis,sali,[35.5:0.5:36.5],'m--','linewidth',2);
set(gca,'ytick',[-300:50:0],'yticklabel',[-300:50:0],'ylim',[-300 0]);
set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);
xlabel('Longitud','fontsize',8); ylabel('Profundidad');
text(245,-270,'Fuente: CMEMS','color','white','fontweight','bold','fontsize',10);
text(245,-285,'Procesamiento: CIO-Challenger','color','white','fontweight','bold','fontsize',10);

%segundo panel
subplot(2,1,2)
[C,h]=contourf(lonis,-depis,sst_anom,[-6:0.5:6]);
clabel(C,h); colorbar; caxis([-6 6]);
cmocean('balance');
set(gca,'ytick',[-300:50:0],'yticklabel',[-300:50:0],'ylim',[-300 0]);
set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);
xlabel('Longitud','fontsize',8); ylabel('Profundidad');
text(245,-270,'Fuente: CMEMS','color','black','fontsize',10);
text(245,-285,'Procesamiento: CIO-Challenger.DALB','color','black','fontsize',10);
title('Anomalía SST Subsuperficial 150E-80W','Fontsize',10)

print('Temp y anom 140E-85W.png','-dpng','-r500');

%% plot 2

figure
P=get(gcf,'position');
P(3)=P(3)*2;
P(4)=P(4)*2.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(3,1,1)
[C,h]=contourf(lonis,-depis,sigma_CMEMS,[20:0.5:30],':');h.LevelList=round(h.LevelList,1);
colormap(parula);title('Sigma-theta Subsuperficial 140E-80W','fontsize',10);
clabel(C,h); caxis([21 27.5]); 
c=colorbar;
c.Label.String='Sigma-theta';
hold on 
set(gca,'ytick',[-300:50:0],'yticklabel',[-300:50:0],'ylim',[-300 0]);
set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);
xlabel('Longitud','fontsize',8); ylabel('Profundidad');
t=text(143,-25,'A','fontsize',15,'color','w');

subplot(3,1,2)
[C,h]=contourf(lonis,-depis,sali,300,'k:');h.LevelList=round(h.LevelList,1);
colormap(parula);title('Salinidad Subsuperficial 140E-80W','fontsize',10);
c=colorbar;
c.Label.String='Salinidad (ups)';
clabel(C,h); caxis([34 36]);
% hold on
% [C,h]=contour(lonis,-depis,tempi,[15:5:20],'m--','linewidth',2);
% clabel(C,h);
set(gca,'ytick',[-300:50:0],'yticklabel',[-300:50:0],'ylim',[-300 0]);
set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);
xlabel('Longitud','fontsize',8); ylabel('Profundidad');
t=text(143,-25,'B','fontsize',15,'color','w');

subplot(3,1,3)
[C,h]=contourf(lonis,-depis,sss_anom,[-0.5:0.1:0.5]);
colormap(parula);title('Anomalia Salinidad Subsuperficial 140E-80W','fontsize',10);
c=colorbar;
c.Label.String='Salinidad (ups)';
clabel(C,h); caxis([-0.5 0.5]);
set(gca,'ytick',[-300:50:0],'yticklabel',[-300:50:0],'ylim',[-300 0]);
set(gca,'xtick',[140:5:280],'xticklabel',[[140:5:180] [-175:5:-80]],'xlim',[140 280]);
xlabel('Longitud','fontsize',8); ylabel('Profundidad');
text(143,-25,'C','fontsize',15,'color','w');
text(235,-260,'Fuente: CMEMS','color','white','fontweight','bold');
text(235,-285,'Procesamiento: CIO-Challenger.DALB','color','white','fontweight','bold');

print('Salinidad vs Sigma-theta Subsuperficial 140E-85W.png','-dpng','-r500');


