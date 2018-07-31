close all
clear

fnc_pdir = './functions/';
path(path,fnc_pdir);

% ---[Read Station file]---------------------------------------------------
Stafilename = './Example.sta';
delimiterIn = ' ';
StationPos = importdata(Stafilename, delimiterIn);
Xs = StationPos.data(:,1);
Ys = StationPos.data(:,2);
Zs = StationPos.data(:,3);
nd=numel(Xs)-1;


% ---[ Read File ]---------------------------------------------------------
n=5;  % <--- increment of grid search [deg]

k=1;
for i=1:360/n+1
    for j=1:90/n+1
        Pazim(k)=n*(i-1);
        Pinc(k)=n*(j-1);
        k=k+1;
    end
end


% ---[ Reading of polarity consistent focal mechanism]---------------------
Polfilename='./Example.pol';
delimiterIn = ' ';
headerlinesIn = 0;
fpdata = importdata(Polfilename, delimiterIn, headerlinesIn);
    
fpstrike = fpdata(:,1);
fpdip    = fpdata(:,2);
fprake   = fpdata(:,3);
       
fpazim = fpstrike-90;      % Azimuth of dipping orientation (Slip vector)
fpinc = 90-fpdip;        % Inclination of dipping orientation (Slip vector)


% ---[depth for each events]-----------------------------------------------
xt=11000;yt=10500;zt=4300;
Depth=zt;

x =   Xs - ones(7,1)*xt;
y =   Ys - ones(7,1)*yt;
z = -(Zs - ones(7,1)*zt);
[Azimuth] = rel2deg(x,y,z);
[Ierr,Take_off] = cal_TakeoffAngle(xt,yt,zt,Xs,Ys,Zs);
d2r   = pi/180;

Type(1:6)=[1 1 -1 1 1 1];


% figure ---
% Polarity consistent focal mechanism
subplot(1,2,1);
MatlabPoleplot2(0,0,1);hold on;

s1 = fpstrike;
d1 = fpdip;
dip_az = (90-s1)-90;
theta  = pi*(dip_az+180)/180;          % az converted to MATLAB angle
rho    = sqrt(2)*sin(pi*(d1)/360);     % projected distance from origin
xp     = rho .* cos(theta);
yp     = rho .* sin(theta);
plot(xp,yp,'r+','MarkerSize',6,'LineWidth',1);hold on;


% Station
for i = 1:nd
    theta(i)   = Azimuth(i)*d2r;
    rho(i)     = sqrt(2)*sin((Take_off(i))/2*d2r);
    [x(i),y(i)] = pol2cart(theta(i),rho(i));

   if Type(i) == 1
           plot(x(i),y(i),'ko','MarkerFaceColor','k','MarkerSize',10);
   elseif  Type(i) == -1 
           plot(x(i),y(i),'ko','MarkerFaceColor','w','MarkerSize',10);
   end;
   hold on;
end


% figure ---
% 
subplot(1,2,2)
MatlabPoleplot2(0,0,1);hold on;

n=5
a=(0:n:360);
b=(0:n:90);
% if 
% end

FP=zeros(360/n+1,90/n+1);
for i=1:numel(a)
    ii=19*(i-1)+1;
    for j=1:numel(b)
        [AA(i,j),BB(i,j)]=plotPoleAziInc( Pazim(ii),Pinc(j),0 );hold on;
    end
end

for j=1:numel(fpazim)
    if fpazim(j)>360
        fpazim(j)=fpazim(j)-360;
    elseif fpazim(j)<0
        fpazim(j)=fpazim(j)+360;
    end
    k=fpazim(j)/5+1;
    l=fpinc(j)/5+1;
    FP(k,l)=1;
end
possibleFPnum=nnz(FP)


%--- Stress contour ---
dCpp=cal_dCpp(Depth);
Cfp=FP.*dCpp;


%%-- constrain by wellhead pressure ---------------------------------------
% eliminate Cpp>WHP
WHP=15
A=Cfp>WHP;
Cfp=Cfp-A.*Cfp;
constrainedFPnum=nnz(Cfp)
    
ElmRate=(possibleFPnum-constrainedFPnum)/possibleFPnum
    
Cfpmax=max(Cfp(:));
tempID=find(Cfp>0);
Cfpmin=min(Cfp(tempID));
clear tempID;
    
%%-- normalization between Cfpmax and Cfpmin ------------------------------
B=Cfp~=0;
SI=1; %SlipIndex: ON=1, OFF=0
Ptt=Cfp;
Ptt=(WHP*B-Cfp)/(WHP-Cfpmin);
% Ptt0=Ptt;
[C ,hc] = contourf(AA,BB,Ptt,20,'EdgeColor','none') ;  hold on;
colormap(jet);
caxis([ 0 1 ]) ;

% 
if true
    for j=1:numel(fpazim) %because of fpazim(1)=ID information
        k=fpazim(j)/5+1;
        l=fpinc(j)/5+1;

        if (Ptt(k,l)>0)
            s1 = fpstrike(j);
            d1 = fpdip(j);
            dip_az = (90-s1)-90;
            theta  = pi*(dip_az+180)/180;          % az converted to MATLAB angle
            rho    = sqrt(2)*sin(pi*(d1)/360);     % projected distance from origin
            xp     = rho .* cos(theta);
            yp     = rho .* sin(theta);
            plot(xp,yp,'w+','MarkerSize',6,'LineWidth',1);hold on;
        end
    end
end
set(gcf,'Position',[200   0   860*1.05 771*1.05]) % By Hotta Dec.1





