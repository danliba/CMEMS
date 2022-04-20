clear all
clc
cd D:\daniel\CIO\CMEMS
pathclim='D:\daniel\CMEMS\climatologia';
pathfn='D:\daniel\CIO\CMEMS';

fnclim='pentad_climatologia_temp.mat';
fn='feb.nc';
load(fullfile(pathclim,fnclim));

lon=double(ncread(fn,'longitude'));
lat=double(ncread(fn,'latitude'));
time=double(ncread(fn,'time'))./24;
[yr,mo,da]=datevec(double(time)+datenum(1950,1,1,0,0,0));

depth=double(ncread(fn,'depth'));
temp=nanmean(double(ncread(fn,'thetao')),2);
TEMPs=permute(temp,[3 1 4 2]);

imonth=mo(1);
%promedio cada 5 dias
indxtime5=find(da<=5 & mo==imonth); %5/mes
indxtime10=find(da>5 & da<=10 & mo==imonth); %10/mes
indxtime15=find(da>10 & da<=15 & mo==imonth); %15/mes
indxtime20=find(da>15 & da<=20 & mo==imonth);%20/mes
indxtime25=find(da>20 & da<=25 & mo==imonth); %25/mes
indxtime30=find(da>25 & da<=30 & mo==imonth);%30/mes

temp5=nanmean(TEMPs(:,:,indxtime5),3); %time5=timeis(indxtime5);
temp10=nanmean(TEMPs(:,:,indxtime10),3); %time10 = timeis(indxtime10);
temp15=nanmean(TEMPs(:,:,indxtime15),3); %time15 = timeis(indxtime15);
temp20=nanmean(TEMPs(:,:,indxtime20),3); %time20 = timeis(indxtime20);
temp25=nanmean(TEMPs(:,:,indxtime25),3); %time25 = timeis(indxtime25);
temp30=nanmean(TEMPs(:,:,indxtime30),3); %time30 = timeis(indxtime30);

temperature = cat(3,temp5,temp10,temp15,temp20,temp25,temp30);

%hallar la anomalia pentadal
climato=temp_clim(:,:,imonth,:);
climato=permute(climato,[1 2 4 3]);
anomalia = temperature - climato;

%% graficar la anomalia pentadal
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
for ij=1:1:6
    [c,h]=contourf(lonis,-DEPTHs,anomalia(:,:,ij),[-6:0.5:6],'k:');
    colorbar; clabel(c,h); ylim([-300 0]);
    caxis([-6 6]);
    shading flat;
    cmocean balance
    title(['mes: ' num2str(imonth) ' pentada: ' num2str(ij)]);
    disp(['mes: ' num2str(imonth) ' pentada: ' num2str(ij)])
    set(gca,'ytick',[-300:20:0],'yticklabel',[-300:20:0],'ylim',[-300 -4]);
    set(gca,'xtick',[150:5:275],'xticklabel',[[150:5:180] [-175:5:-85]],'xlim',[150 275]);
    xlabel('Longitud'); ylabel('Profundidad');
    text(245,-270,'Fuente: ARGO','color','white','fontweight','bold');
    text(245,-280,'Procesamiento: CIO-Challenger','color','white','fontweight','bold');
    pause(1)
    clf
end

%% subplot
labels_x={'140ºE','150ºE','160ºE','170ºE','180ºW','170ºW','160ºW','150ºW','140ºW','130ºW','120ºW','110ºW','100ºW','90ºW','80ºW'};
t1 = datetime(yr(1),mo(1),1);
t2 = datetime(yr(1),mo(1),da(end)+1);
t = t1:5:t2;

figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*1;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.11 0.04], [0.06 0.05], [0.15 0.01]);
if ~make_it_tight,  clear subplot;  end

for ij=1:1:6
    subplot(2,3,ij)
    [c,h]=contourf(lonis,-DEPTHs,anomalia(:,:,ij),[-7:1:7],'k:'); set(h,'LineColor','none')
    ax = gca;
    set(gca,'ytick',[-300:50:0],'yticklabel',[-300:50:0],'ylim',[-300 0]);
    set(gca,'xtick',[140:10:280],'xticklabel',labels_x,'xlim',[140 280]);
    ax.XAxis.FontSize = 5.5; ax.YAxis.FontSize = 8;
    ax.XAxis.FontWeight ='bold'
    colorbar;  ylim([-300 0]);
    clabel(c,h);
    hc=colorbar;
    set(hc,'ticks',[-7:1:7],'TickDirection',('out'),'TickLength',0.005);
    hc.Location='eastoutside';
    hc.Position=[0.11 0.11 0.01 0.8];
    ylabel(hc,'SST anomaly');
    caxis([-7 7]);
    shading flat;
    cmocean balance
    if mo(1) == 2
        title(string(t(ij)));
    else
        title(string(t(ij+1)));
    end
    disp(['mes: ' num2str(imonth) ' pentada: ' num2str(ij)])
    grid on
end
savefig('feb.fig');
%% 
openfig('feb.fig');
print('feb_anomalia_pentadal_sst.jpg','-djpeg','-r500');
