function [vx, vy, w] = cinematica_direta(V1,V2,V3,V4, s1, s2, s3, s4)
  l = 0.52; %wheeltrack
  c = 0.88; %wheelbase
  
  Vx1=V1.*cos(s1);
  Vy1=V1.*sin(s1);
  Vx2=V2.*cos(s2);
  Vy2=V2.*sin(s2);
  Vx3=V3.*cos(s3);
  Vy3=V3.*sin(s3);
  Vx4=V4.*cos(s4);
  Vy4=V4.*sin(s4);

  vxy = [Vx1'; Vy1'; Vx2'; Vy2'; Vx3'; Vy3'; Vx4'; Vy4'];

  sigma = [1, 0, 1, 0, 1, 0, 1, 0;
           0, 1, 0, 1, 0, 1, 0, 1;
           l/2, c/2, -l/2, c/2, l/2, -c/2, -l/2, -c/2];

  x=sigma*vxy;

  vx=x(1,:);

  vy=x(2,:);

  w=x(3,:);
end
