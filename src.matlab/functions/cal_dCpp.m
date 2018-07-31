function [dCpp,dcpp] = cal_dCpp(depth)
    s1 = './a0.6.out ';
    s2 = num2str(depth);
    comandline=[s1 s2]
    clear s1 s2;
    system(comandline);

    % crackfile = './Fusework/CppContour/Nforce_Basel.dat';
    crackfile = './Nforce_Basel.dat';
    fid = fopen(crackfile,'rt');
    fdata = fscanf(fid,' %15c %f%f%f%f \n',[19,inf]);
    fclose(fid);

    cpp = fdata(19,:);  %critical pore pressure
    TVD  = depth+259.34;
    Ppst = TVD*9.81*0.001; 
    dcpp = cpp-Ppst;

    %%---------------Figure--------------------------------------
    a=(0:5:360);
    b=(0:5:90);

    c=1;
    for i=1:numel(a)%azim
        for j=1:numel(b)%inc
            Cpp(i,j)=cpp(c);
            dCpp(i,j)=dcpp(c);
            c=c+1;
        end
    end
end