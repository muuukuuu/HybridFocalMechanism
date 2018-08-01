function [fault_par] = gridsearch_pol(Azimuth, Take_off, Type, nd, gd)

% translate azimuth of map coordinate to Cartesian coordinates coordinate
% Azimuth=map2cart(Azimuth);

for i=1:nd
    [Azimuth(i),Take_off(i)]=upperhem2lowerhem(Azimuth(i),Take_off(i));
end

c1 = 0;  %counter
c2 = 0;
c3 = 0;
d2r = pi/180;
theta = zeros(nd,1);
rho = zeros(nd,1);
% gd = 10; % grid degree

for i = 1:nd
    if(Take_off(i)==90)
        Take_off(i)=89.5;
    end
    theta(i) = Azimuth(i)*d2r;
    rho(i)   = sqrt(2)*sin((Take_off(i))/2*d2r);
    if Type(i) == 1
        c1 = c1+1;
        xp1(c1) = rho(i) .* cos(theta(i));
        yp1(c1) = rho(i) .* sin(theta(i));
    elseif Type(i) == -1
        c2 = c2+1;
        xp2(c2) = rho(i) .* cos(theta(i));
        yp2(c2) = rho(i) .* sin(theta(i));
    else
        c3=c3+1;
    end
end
tnd = nd-c3; 


j = 0;
k = 1;

for ss1 = 1:360/gd+1
    s1 = (ss1-1)*gd;   %strike
    for dd1 = 1:90/gd+1
         d1 = (dd1-1)*gd;   %dip
        for rr1 = 1:360/gd+1
            r1 = rr1*gd-180;   %rake
            j = j+1;

            [s2,d2] = cal_AuxPlane(s1,d1,r1);
            [x1,y1] = cal_planeline_from_faultpar(s1,d1);
            [x2,y2] = cal_planeline_from_faultpar(s2,d2);

            [X,Y] = cal_compressive_domain(s1,r1,s2,x1,y1,x2,y2);

            in1 = inpolygon(xp1,yp1,X,Y);
            in2 = inpolygon(xp2,yp2,X,Y);

            Match_num1 = numel(xp1(in1));
            Match_num2 = numel(xp2(~in2));
            MR(j) = (Match_num1+Match_num2)/tnd;
           

            if MR(j)>(tnd-1)/tnd
%             if MR(j)>5/6
                strike(k) = s1;
                dip(k)    = d1;
                rake(k)   = r1;
                k = k+1;
            end
        end
    end
end

fault_par=horzcat(strike.',dip.',rake.');
% save fault_par.mat fault_par

end


function [azimuth]=map2cart(input)
   azimuth=-input+180/2;
end


function [Azimuth,Take_off]=upperhem2lowerhem(InAzim,InTake_off)    
    %%% This part is for the case when Take off angle is from upward
    % --------------------------------------------------------------
    if(InTake_off<90)
        % move station on upper hemispere to lower hemispher
        Azimuth=InAzim+180;
        Take_off=InTake_off;
    elseif(InTake_off>=90)
        % move station on upper hemispere to lower hemispher
        Azimuth=InAzim;
        Take_off=180-InTake_off;
    end
end