function [s2,d2,r2] = cal_AuxPlane(s1,d1,r1)

% read the text written by 'stein & wysession' p228-229, especially p229.
r2d = 180/pi;
d2r = pi/180;

%parameter of NodalPlane
S1 = s1*d2r;
D1 = d1*d2r;
R1 = r1*d2r;

cos_D2 = sin(R1).*sin(D1);           % eq18
    D2 = acos(cos_D2);

sin_R2 = cos(D1)./sin(D2);           % eq19
cos_R2 = -sin(D1).*cos(R1)./sin(D2); % combining eq16 & 17
    R2 = atan2(sin_R2,cos_R2);
    
sin_S1minusS2 =   cos(R1)./sin(D2);  % eq16
cos_S1minusS2 = -1./tan(D1)./tan(D2); % eq22
    S1minusS2 = atan2(sin_S1minusS2, cos_S1minusS2);
           S2 = S1 - S1minusS2;

%parameter of AuxPlane
s2 = S2*r2d;
d2 = D2*r2d;
r2 = R2*r2d;

i=find(d2 > 90);
    s2(i) = 180 + s2(i);
    d2(i) = 180 - d2(i);
    r2(i) = 360 - r2(i);
j=find(s2 >= 360);
    s2(j) = s2(j) - 360;
k=find(s2 < 0);
    s2(k) = s2(k) + 360;

end