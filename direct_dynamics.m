function [x2p, y2p, wp] = direct_dynamics(vx, vy, w, F1, F2, F3, F4, s1, s2, s3, s4)
  l = 0.52;
  c = 0.88;
  C = c/2;
  m = 1120;
  jz = 96.4629;

  Ff = (F1+F2)/2;
  sf=acot(cot(s2)+(l/(2*c)));
  Fxf = Ff*cos(sf);
  Fyf = Ff*sin(sf);
  Fr = (F3+F4)/2;
  sr=acot(cot(s4)+(l/(2*c)));
  Fxr = Fr*cos(sr);
  Fyr = Fr*sin(sr);
  Fx = Fxf + Fxr;
  Fy = Fyf + Fyr;
  M = (C*Fyf)-(C*Fyr);
  x2p = (vy*w)  + (Fx/m);
  y2p = (-vx*w) + (Fy/m);
  wp  =    0    + (M/jz);

end
