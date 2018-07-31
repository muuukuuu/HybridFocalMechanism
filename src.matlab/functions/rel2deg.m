function [azimuth,take_off] = rel2deg(x,y,z)

    [azimuth,elevation] = cart2sph(x,y,z);

    idx = find(elevation >= 0);
    azimuth(idx)   = azimuth(idx) + pi;
    elevation(idx) = - elevation(idx);

    take_off = pi/2 + elevation;

    azimuth = azimuth*180/pi;
    take_off = take_off*180/pi;
end