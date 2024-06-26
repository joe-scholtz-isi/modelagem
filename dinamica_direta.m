function [x2p, y2p, wp] = dinamica_direta(vx, vy, w, F1, F2, F3, F4, s1, s2, s3, s4)
  m = 1120;
  jz = 100;
  l = 0.52; %wheeltrack
  c = 0.88; %wheelbase
  
  F1x=F1.*cos(s1);
  F1y=F1.*sin(s1);
  F2x=F2.*cos(s2);
  F2y=F2.*sin(s2);
  F3x=F3.*cos(s3);
  F3y=F3.*sin(s3);
  F4x=F4.*cos(s4);
  F4y=F4.*sin(s4);

  % Coloque as entradas em uma matriz de uma linha
  Fxy = [F1x'; F1y'; F2x'; F2y'; F3x'; F3y'; F4x'; F4y'];

  sigma = [1,   0,   1,    0,   1,   0,    1,    0;
            0,   1,   0,    1,   0,   1,    0,    1;
            l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];

  u = sigma*Fxy

  x2p = (vy.*w)  + (1/m)*u(1,1);
  y2p = (-vx.*w) + (1/m)*u(2,1);
  wp  =    w.*0    + (1/jz)*u(3,1);

end
