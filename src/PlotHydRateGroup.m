
%----------[ figure parameter ]--------------------------------------------
close all;
clear all;

%----------[Color map]------------------------------------------------------------
 cm(:,1)=  [     0    0.4470    0.7410];
 cm(:,2)=  [0.8500    0.3250    0.0980];
 cm(:,3)=  [0.9290    0.6940    0.1250];
 cm(:,4)=  [0.4940    0.1840    0.5560];
 cm(:,5)=  [0.4660    0.6740    0.1880];
 cm(:,6)=  [0.3010    0.7450    0.9330];
 cm(:,7)=  [0.6350    0.0780    0.1840];
 
figure;

FontSize=10; 



%-----Read Hydraulic Record -------------------------------------------
startday=2;
fid=fopen('../---00005;DataHydraulic/Hydraulic_data_BS_1.prn','rt') ;
for i=1:3;
    head=fgetl(fid);
end;
Hdata = fscanf(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f\n',[13,inf]);
fclose(fid);
Hyear=Hdata(1,:);  Hmonth=Hdata(2,:);  Hday=Hdata(3,:);
Hhour=Hdata(4,:);  Hmin=Hdata(5,:);  Hsec=Hdata(6,:);
Hday=Hday-startday;
Flow=Hdata(11,:);  Press=Hdata(8,:);
Press=0.1*Press;
Htime=Hday*24+Hhour+Hmin/60;
Htime=Htime/24;
% HdateNum=datenum(Hyear,Hmonth,Hday,Hhour,Hmin,Hsec);
clear Hdata head Hyear Hmonth Hday Hhour Hmin Hsec;

formatIn = 'yyyy-mm-dd HH:MM:SS';
startt=['2006-12-08 11:33:00'];
% starttime=datenum(startt,formatIn);
shutinTime=datenum(startt,formatIn);

Sday=8-startday;
Stime=Sday*24+11+33/60;
Stime=Stime/24;
shutinTime=Stime;
    
    
%-----[ Read loc depth ]---------------------------------------------------
% crackfile2 = './Fusework/CppContour/Basel2006DecAll_jhdDDrepick15+6-3.mos.clst40-97Hz_0.7Mag.loc';
% fid = fopen(crackfile2,'rt');
% fdata = fscanf(fid,' %15c %f%f%f%f%f%f%f%f%f \n',[24,inf]);
% fclose(fid);

fname=['./Fusework/CppContour/Basel2006DecAll_jhdDDrepick15+6-3.mos.clst40-97Hz_0.7Mag.loc'] ;
[Locname,Date,Time,xt,yt,zt,tt,RMSt,Cid,Mag]=...
textread([fname],'%s %f%f %f%f%f%f %f%f%f');
Locnum=numel(xt)

%----------[ Coodinate Event time ]------------------------------------------------------------
%----------------------------------------------------------------------
startday=2;
Lday=Date;
Lday(find(Date<20070100))=Date(find(Date<20070100))-20061200;
Lday(find(Date>20070100 & Date<20070200))=Date(find(Date>20070100 & Date<20070200))-20070100+31;
Lday(find(Date>20070200 & Date<20070300))=Date(find(Date>20070200 & Date<20070300))-20070200+31+28;

Lday=Lday-startday;
Lhour=floor(Time/10000);
Lmin=Time-Lhour*10000;Lmin=floor(Lmin/100);
Ltime=Lday*24+Lhour+Lmin/60;
Ltime=Ltime/24;


%-----[ Read File ]--------------------------------------------------------
filename = './Fusework/CppContour/rejectrate.dat';
[Ratename,cnt,posiFPS,constFPS,Rate]=textread([filename],'%s %u %f%f%f');
Ratenum=numel(cnt)

% -------------------------------
subplot(3,1,1)
  tmax=7;      ttickw=1;
%   tmax=shutinTime;
[AX,H1,H2] = plotyy(Htime,Press,Htime,Flow);hold on;
  set(H1,'Color','k');      set(H2,'Color','r');
  set(AX(1),'YColor','k');            set(AX(2),'YColor','r')
  set(AX(1),'Xlim',[0,tmax]);         set(AX(2),'Xlim',[0,tmax]);
  set(AX(1),'Ylim',[0 30]);          set(AX(2),'Ylim',[-2000 4000]);
  set(AX(1),'XTick',[0:1:tmax]);      set(AX(2),'XTick',[0:1:tmax]);
  set(AX(1),'YTick',[0:10:30]);     set(AX(2),'YTick',[-2000:2000:4000]);
  set(get(AX(1),'YLabel'),'String','Wellhead pressure (MPa)');
  set(get(AX(2),'YLabel'),'String','Flow Rates (l/min)');
  set(get(AX(2),'XLabel'),'String','Elapsed Time (day)','FontName','Arial');
hold on;

% -------------------------------
subplot(3,1,2)
for i=1:7
    fname=char( strcat('./Type',num2str(i),'list.txt') )
    if i==6
        fname=['./TypeNFlist.txt'] ;
    elseif i==7
        fname=['./Typeotherslist.txt'] ;
    end
    [Listname]=textread([fname],'%s');
    Listnum=numel(Listname)
    
    for j=1:Listnum
        for k=1:Ratenum
            kkk=strcmp( Listname(j), Ratename(k) );
            if (kkk==1)
                EVRate(j)=Rate(k);
            end
        end
        for k=1:Locnum
            kkk=strcmp( Listname(j), Locname(k) );
            if (kkk==1)
                EVtime(j)=Ltime(k);
            end
        end
    end
    plot(EVtime,EVRate,'.','Color',cm(:,i),'MarkerSize',15);hold on;
    if i~=7
        plot(EVtime,EVRate,'-','Color',cm(:,i));hold on;
    end
    clear EVtime EVRate Listname

end
line([shutinTime, shutinTime],[0 100],...
    'Color',cm(:,2))
legend('Group1','','Group2','','Group3','',...
    'Group4','','Group5','','NFs','','Others','','Location','southwest')

xlabel('Elapsed Time (day)', 'FontSize', FontSize);
ylabel('Elimination Rate (%)','FontSize', FontSize);
xlim([0,tmax]);
% ylim([mZ-Zrange+geta,mZ+Zrange+geta]);
set(gcf,'Position',[200   0   860*1.05 771*1.05]) % By Hotta Dec.1
% saveas(gcf,'PlotCfpGroup2','epsc');
% hgexport(gcf,'filename',epsfig,'Format','eps')

% pause


%%-- Color bar-------------------------------------------------------------
% if SI==1
%     h=colorbar;
%     ylabel(h,'Slip Index','FontSize',24,'FontName','Arial Unicode MS');hold on;
%     set(h,'FontSize',22,'TickLength',[0.005 0],'LineWidth',2,'YTick',[0 0.2 0.4 0.6 0.8 1]);hold on;
%     set(h,'Position',[0.92 0.2 0.02 0.6]);hold on;
%     set(gcf,'Color','w');
% elseif SI==0
%     h=colorbar;
%     ylabel(h,'Critical Pore pressure [MPa]', 'FontSize', FontSize);hold on;
%     set(h,'FontSize',FontSize);hold on;
%     set(h,'Position',[0.92 0.2 0.02 0.6]);hold on;
%     set(gcf,'Color','w');
% end


%%--- plot all pole--------------------------------------------------------

% Dnum=length(fpstrike)-1;

%%- disp all possible FPS---------------------------------------------------
% S1=fpstrike(2:Dnum);
% D1=fpdip(2:Dnum);
% R1=fprake(2:Dnum);
% [S2,D2] = cal_AuxPlane(S1,D1,R1);
%%--------------------------------------------------------------------------

%%- disp constrained FPss --------------------------------------------------
% k=0;
% for i=1:numel(a)
%     for j=1:numel(b) 
%         if B1(i,j)==1
%             k=k+1;
%             S1(k)=90+5*(i-1);
%             D1(k)=90-5*(j-1);
%         end   
%     end
% end
%%--------------------------------------------------------------------------
% for i=1:length(S1)
%     s1 = S1(i);
%     d1 = D1(i);
%     dip_az = (90-s1)-90;
%     theta  = pi*(dip_az+180)/180;          % az converted to MATLAB angle
%     rho    = sqrt(2)*sin(pi*(d1)/360);     % projected distance from origin
%     xp     = rho .* cos(theta);
%     yp     = rho .* sin(theta);
% %     plot(xp,yp,'rs','MarkerSize',2,'MarkerFaceColor','r');
%     plot(xp,yp,'r+','MarkerSize',6,'LineWidth',1.8);
% 
%     s2 = S2(i);
%     d2 = D2(i);
%     dip_az = (90-s2)-90;
%     theta  = pi*(dip_az+180)/180;
%     rho    = sqrt(2)*sin(pi*(d2)/360);
%     xp     = rho .* cos(theta);
%     yp     = rho .* sin(theta);
%     plot(xp,yp,'rs','MarkerSize',2,'MarkerFaceColor','r');
% 
% end


%%-------------------------------------------------------------------------
% 262~322 to plot station
% filename1 = './Basel2006DecAll_jhdDDrepick15+6-3.mos.clst40-97Hz_0.7Mag.loc';
% delimiterIn = ' ';
% EventData = importdata(filename1, delimiterIn);
% 
% filename2 = './Basel2006.sta';
% delimiterIn = ' ';
% StationPos = importdata(filename2, delimiterIn);
% 
% eventid=P_polarID-1;
% filename3 = './PwavePolarity_ALLBS1.txt';
% delimiterIn = ' ';
% headerlinesIn = 1;
% PwavePolar = importdata(filename3, delimiterIn, headerlinesIn);
% 
% % Date = EventData.data(:,1);
% % Time = EventData.data(:,2);
% Xc   = EventData.data(:,3);   
% Yc   = EventData.data(:,4);
% Zc   = EventData.data(:,5);
% % Mag  = EventData.data(:,9);
% 
% Xs = StationPos.data(:,1);
% Ys = StationPos.data(:,2);
% Zs = StationPos.data(:,3);
% % Type = StationPos.data(:,8); %‰Ÿ‚µˆø‚«
% 
% Type=zeros(1,6);
% for i=1:6
%     Type(1,i) = PwavePolar.data(eventid,i);
% end
% id = PwavePolar.data(eventid,7);
% ts1= [PwavePolar.data(eventid,8) PwavePolar.data(eventid,10)];
% td1= [PwavePolar.data(eventid,9) PwavePolar.data(eventid,11)];
% 
% % relative coordinate(x,y,z)
% x = Xs - ones(7,1)*Xc(id);
% y = Ys - ones(7,1)*Yc(id);
% z = -(Zs - ones(7,1)*Zc(id));
% %--------------------------------------------------------------------------
% 
% [Ierr,Take_off] = cal_TakeoffAngle(Xc(id),Yc(id),Zc(id),Xs,Ys,Zs);
% 
% [Azimuth] = rel2deg(x,y,z);
% ID = [1 2 3 4 5 6];
% ID = ID.';
% nd = length(ID);
% 
% theta = zeros(nd,1);
% rho   = zeros(nd,1);
% d2r   = pi/180;
% for i = 1:nd
%     theta(i)   = Azimuth(i)*d2r;
%     rho(i)     = sqrt(2)*sin((Take_off(i))/2*d2r);
%     [x(i),y(i)] = pol2cart(theta(i),rho(i));
%     
%    if Type(i) == 1  %‰Ÿ‚µ
%            plot(x(i),y(i),'ko','MarkerFaceColor','k','MarkerSize',10);
%    else  %ˆø‚«
%            plot(x(i),y(i),'ko','MarkerFaceColor','w','MarkerSize',10,'LineWidth',1.5);
%    end
% end

%--------------------------------------------------------------------------
% dim1 = [0.4 0.03 0.1 0.05];
% str1 = {'Depth(m)' num2str(round(TVD)) ''};
% annotation('textbox',dim1,'String',str1,'FontSize',18,'LineStyle',...
%     'none','FontWeight','bold','HorizontalAlignment','center');
% dim2 = [0.5 0.03 0.1 0.05];
% str2 = {'WHP(MPa)' num2str(WHP) ''};
% annotation('textbox',dim2,'String',str2,'FontSize',18,'LineStyle',...
%     'none','FontWeight','bold','HorizontalAlignment','center');

