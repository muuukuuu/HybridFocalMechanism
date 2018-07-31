function [Ierr,Take_off]=cal_TakeoffAngle(x,y,z,Xs,Ys,Zs)

ps = 0;
direc=0;
Ierr=0;

filename = 'Example.vel';
delimiterIn = ' ';
headerlinesIn = 1;

Vel = importdata(filename, delimiterIn, headerlinesIn);
[Lnum0,dataset]=size(Vel.data(:,:));

if dataset==3
    depth = Vel.data(:,3);  % depth=bndry
    if ps==0
        V = Vel.data(:,1);  % V=Vp
    else
        V = Vel.data(:,2);  % V=Vs
    end
elseif dataset==2
    V = Vel.data(:,1);  % V=Vp
    depth = Vel.data(:,2);  % depth=bndry
else
    Ierr = 1;
    return
end

Lnum = Lnum0-1;
for j=1:6
    stx = Xs(j);  % station
    sty = Ys(j);
    stz = Zs(j);
    
    for i=1:Lnum
        if depth(i+1)>stz
            sti = i-1;
            break
        end
    end
    if depth(Lnum+1)<=stz
        sti = Lnum;
    end

    for i=0:Lnum-1
        if depth(Lnum-i+1)<z
            sri = Lnum-i;
            break
        end
    end
    if depth(2)>=z
        sri = 0;
    end

    if sti==sri
        dist  = sqrt((x-stx)*(x-stx)+(y-sty)*(y-sty)+(z-stz)*(z-stz));
        theta = acos(abs(z-stz)/dist);
    else
        if sti<sri
            stzt  = stz;
            zt    = z;
            direc = 1;
        elseif sti>sri
            i     = sti;
            sti   = sri;
            sri   = i;
            stzt  = z;
            zt    = stz;
            direc = -1;
        end
    
        Hdist1 = sqrt((x-stx)*(x-stx)+(y-sty)*(y-sty));
        Hdist2 = 0;
        ctheta = pi/4;
        theta  = ctheta;
        P      = sin(theta)/V(sri+1);  % snell's law:P=sin(theta')/V(sti+1),theta'=angle of refraction at sti layer
        for i=1:999
            Hdist2 = (zt-depth(sri+1))*tan(theta);
            Hdist2 = Hdist2+(depth(sti+2)-stzt)*P*V(sti+1)/sqrt(1-P*P*V(sti+1)*V(sti+1));
            if sti+2<=sri
                for k=sti+1:sri-1
                     Hdist2 = Hdist2+(depth(k+2)-depth(k+1))*P*V(k+1)/sqrt(1-P*P*V(k+1)*V(k+1));
                end
            end
        
            dif = abs(Hdist1-Hdist2);
            if dif>=0.001
                if Hdist2>Hdist1
                    ctheta = ctheta/2;
                    theta  = theta-ctheta;
                    P      = sin(theta)/V(sri+1);
                elseif Hdist2<Hdist1
                    ctheta = ctheta/2;
                    theta  = theta+ctheta;
                    P      = sin(theta)/V(sri+1);
                end
            else
                break
            end
        end
        if dif>=0.001
            Ierr = 1;
            return
        end
    
    end

    if direc == -1
        Take_off(j) = asin(V(sti+1)/V(sri+1)*sin(theta))*180/pi;
        continue
    else
        Take_off(j) = theta*180/pi;
        continue
    end
end
Take_off = Take_off.';
% Take_off = single(Take_off);
Ierr = single(Ierr);

clearvars -except Take_off Ierr
end


        
        
        
        
