function [x2p, y2p, wp] = dinamica_direta(Vx, Vy, w, F1, F2, F3, F4, s1, s2, s3, s4)
  vxy = [Vx1; Vy1; Vx2; Vy2; Vx3; Vy3; Vx4; Vy4];    

  sigma = [1,   0,   1,    0,   1,   0,    1,    0;

           0,   1,   0,    1,   0,   1,    0,    1;

           l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];

  x=sigma*vxy;

  vx=x(1);

  vy=x(2);

  w=x(3);

  v=sqrt(pow2(vx)+pow2(vy));
end
