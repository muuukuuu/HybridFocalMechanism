function  [X,Y]=plotPoleAziInc(azi,inc,flag)
% figure
% input azi (Azimuth of Pole, map cordinate, clockwise from North)
% input inc (Inclination of Pole, map cordinate, clockwise from horizontal)

% % % ---Convert Pole of Azim and inc 
% azi=azi+90;
% % azi=azi-90;
% inc=90-inc;


% ---Convert xyz cordinate-----
azi=90-azi;
circle=[cos((0:360)*pi/180) ; sin((0:360)*pi/180) ; (0:360)-(0:360)]';

if(flag==1)
  plot(circle(:,1),circle(:,2),'-k','Linewidth',3);hold on;
  xlim([-1.1,1.1]);
  ylim([-1.1,1.1]);
  zlim([-1.1,1.1]);
  view(0,90);
  axis off;
  axis equal;

else
    if azi==90||azi==270
       X=0;
       Y=sin(azi.*pi./180).*sqrt(2)*sin((90-inc).*pi./(180*2));
    elseif azi==180||azi==360
       X=cos(azi.*pi./180).*sqrt(2)*sin((90-inc).*pi./(180*2));
       Y=0;
    else
       X=cos(azi.*pi./180).*sqrt(2)*sin((90-inc).*pi./(180*2));
       Y=sin(azi.*pi./180).*sqrt(2)*sin((90-inc).*pi./(180*2));
    end
end