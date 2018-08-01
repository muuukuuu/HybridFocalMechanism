function [X,Y] = cal_compressive_domain(s1,r1,s2,x1,y1,x2,y2)
% “h‚è‚Â‚Ô‚µ(‰Ÿ‚µ)‚Ì”ÍˆÍŽw’è

d2r = pi/180;
S1  = 90-s1;
S2  = 90-s2;
P   = 0;
L   = 0;

if (r1 < 0)||(r1 > 180)
    P = 1;
end

if P == 0
    hi = S1-180;
    lo = S2;

    if hi<lo
        L=1;
        hi=S2;
        lo=S1-180;
    end

    theta1 = lo:1:hi;
    xs1 = cos(theta1*d2r);
    ys1 = sin(theta1*d2r);
    xs2 = -xs1;
    ys2 = -ys1;

elseif P == 1
    x2 = fliplr(x2);
    y2 = fliplr(y2);
    hi = S1-180;
    lo = S2-180;

    if hi < lo
        L  = 1;
        hi = S2-180;
        lo = S1-180;
    end

    theta1 = lo:1:hi;
    xs1 = cos(theta1*d2r);
    ys1 = sin(theta1*d2r);
    xs2 = -xs1;
    ys2 = -ys1;
    
end

if L == 0
    xs1 = fliplr(xs1);
    ys1 = fliplr(ys1);
elseif L == 1
    xs2 = fliplr(xs2);
    ys2 = fliplr(ys2);
end

X = cat(2,x1,xs1,x2,xs2);
Y = cat(2,y1,ys1,y2,ys2);
end            