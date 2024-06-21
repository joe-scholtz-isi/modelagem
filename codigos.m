function [x2p, y2p, wp] = dinamica2(F1x, F1y, F2x, F2y, F3x, F3y, F4x, F4y, Vx, Vy, w)
    % Defina a constante m
    m = 1750;
    l = 1.48;
    c = 2.7;
    jz = 2500;
    

    
    % Coloque as entradas em uma matriz de uma linha
    Fxy = [F1x; F1y; F2x; F2y; F3x; F3y; F4x; F4y];

    sigma = [1,   0,   1,    0,   1,   0,    1,    0;
             0,   1,   0,    1,   0,   1,    0,    1;
             l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];

    u = sigma*Fxy;

    x2p = (Vy*w)  + (1/m)*u(1,1);
    y2p = (-Vx*w) + (1/m)*u(2,1);
    wp  =    0    + (1/jz)*u(3,1);
    
end

function [Vrx1, Vry1, Vrx2, Vry2, Vrx3, Vry3, Vrx4, Vry4] = corpo2roda2(vx, vy, w)
    % Parâmetros do robô (constantes)
    l = 1.48;
    c = 2.7;
  

    x=[vx, vy, w]';

    sigma = [1,   0,   1,    0,   1,   0,    1,    0;
             0,   1,   0,    1,   0,   1,    0,    1;
             l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];
    
    vxy=sigma.'*x;

    Vrx1=vxy(1,1);  
    Vry1=vxy(2,1);
    Vrx2=vxy(3,1);
    Vry2=vxy(4,1);
    Vrx3=vxy(5,1);
    Vry3=vxy(6,1);
    Vrx4=vxy(7,1);
    Vry4=vxy(8,1);

end



function [w, v]  = va2v(Vx, Vy, ax, ay)

   
   w = (Vx*ay-Vy*ax)/(Vx^2+Vy^2);

   v=sqrt(pow2(Vx)+pow2(Vy));

end


function [x2p, y2p, wp] = dinamica3(Vx, Vy, w, F1, F2, F3, F4, s1, s2, s3, s4)
    % Defina a constante m
    m = 1750;
    jz = 2500;
    l = 1.48;
    c = 2.7;
    
    F1x=F1*cos(s1);
    F1y=F1*sin(s1);
    F2x=F2*cos(s2);
    F2y=F2*sin(s2);
    F3x=F3*cos(s3);
    F3y=F3*sin(s3);
    F4x=F4*cos(s4);
    F4y=F4*sin(s4);

    % Coloque as entradas em uma matriz de uma linha
    Fxy = [F1x; F1y; F2x; F2y; F3x; F3y; F4x; F4y];

    sigma = [1,   0,   1,    0,   1,   0,    1,    0;
             0,   1,   0,    1,   0,   1,    0,    1;
             l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];

    u = sigma*Fxy;

    x2p = (Vy*w)  + (1/m)*u(1,1);
    y2p = (-Vx*w) + (1/m)*u(2,1);
    wp  =    0    + (1/jz)*u(3,1);

end

function [v4, v3, v2, v1, s4, s3, s2, s1] = cinematicav(w, vy, vx) 

l = 1.48;
c = 2.7;
stub=0;
R=0.3135;

v=sqrt(pow2(vx)+pow2(vy));

Icr=v/w;

if (w==0)
    gammaR=0.0;
    % vr=v;

    gammaL=0.0;
    % vl=v;
else
    % gammaR=atan2(c/2,(Icr+(l/2)));
       
    gammaR=atan(c/2/(Icr+l/2));

    % rr=sqrt(sqrt(c/2)+sqrt(Icr-(l/c))-stub);
    % 
    % vr=sign(Icr)*rr*w;

    % gammaL=atan2(c/2,(Icr-(l/2)));

    gammaL=atan(c/2/(Icr-l/2));

    % rl=sqrt(sqrt(c/2)+sqrt(Icr+(l/c))+stub);
    % 
    % vl=sign(Icr)*rl*w;
end
% 
% gammaR=saturate(gammaR,deg2rad(45));
% gammaL=saturate(gammaL,deg2rad(45));
    
% wr=vr/R;
% 
% wl=vl/R;

s1=gammaR;
s2=gammaL;
s3=-gammaR;
s4=-gammaL;


% w1=wr;
% w2=wl;
% w3=wr;
% w4=wl;

    x=[vx, vy, w]';

    sigma = [1,   0,   1,    0,   1,   0,    1,    0;
             0,   1,   0,    1,   0,   1,    0,    1;
             l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];
    
    vxy=sigma.'*x;

    Vx1=vxy(1,1);  
    Vy1=vxy(2,1);
    Vx2=vxy(3,1);
    Vy2=vxy(4,1);
    Vx3=vxy(5,1);
    Vy3=vxy(6,1);
    Vx4=vxy(7,1);
    Vy4=vxy(8,1);

    v1=sqrt(pow2(Vx1)+pow2(Vy1));

    v2=sqrt(pow2(Vx2)+pow2(Vy2));

    v3=sqrt(pow2(Vx3)+pow2(Vy3));

    v4=sqrt(pow2(Vx4)+pow2(Vy4));
    
end

function [v1, v2, v3, v4, s1, s2, s3, s4] = cinematica3(w, vy, vx) 

l = 1.48;
c = 2.7;

v=sqrt(pow2(vx)+pow2(vy));

Icr=v/w;

if (w==0)

    gammaR=0.0;
    gammaL=0.0;

else
       
    gammaR=atan(c/2/(Icr+l/2));
    gammaL=atan(c/2/(Icr-l/2));

end

gammaR=saturate(gammaR,deg2rad(45));
gammaL=saturate(gammaL,deg2rad(45));
    
s1=gammaR;
s2=gammaL;
s3=-gammaR;
s4=-gammaL;

    x=[vx, vy, w]';

    sigma = [1,   0,   1,    0,   1,   0,    1,    0;
             0,   1,   0,    1,   0,   1,    0,    1;
             l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];
    
    vxy=sigma.'*x;

    Vx1=vxy(1,1);  
    Vy1=vxy(2,1);
    Vx2=vxy(3,1);
    Vy2=vxy(4,1);
    Vx3=vxy(5,1);
    Vy3=vxy(6,1);
    Vx4=vxy(7,1);
    Vy4=vxy(8,1);

    v1=sqrt(pow2(Vx1)+pow2(Vy1));

    v2=sqrt(pow2(Vx2)+pow2(Vy2));

    v3=sqrt(pow2(Vx3)+pow2(Vy3));

    v4=sqrt(pow2(Vx4)+pow2(Vy4));
    
end



