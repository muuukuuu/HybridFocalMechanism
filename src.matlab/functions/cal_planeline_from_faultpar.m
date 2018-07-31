function [x,y] = cal_planeline_from_faultpar(strike, dip)

d2r = pi/180;

if dip >= 90
    dip = 89.9;
end

strike = strike*d2r;
dip = dip*d2r;

phi = 0:.01:pi;
radip = atan(tan(dip)*sin(phi));
rproj = sqrt(2)*sin((pi/2 - radip)/2);

xp  = rproj .* sin(phi);
yp  = rproj .* cos(phi);

% rotation of strike deg.
x = cos(-strike)*xp - sin(-strike)*yp;
y = sin(-strike)*xp + cos(-strike)*yp;
end

