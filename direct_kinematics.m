function [vx, vy, w] = direct_kinematics(V1,V2,V3,V4, s1, s2, s3, s4)
  l = 0.52; %wheeltrack
  c = 0.88; %wheelbase

  xp = [ (V1.*sin(s1+pi/2)+V2.*sin(s2+pi/2))/2, V1.*cos(s1+pi/2),(V2.*sin(s2+pi/2)-V1.*sin(s1+pi/2))/(2*l)+(V3.*cos(s3+pi/2)-V1.*cos(s1+pi/2))/(2*c)];

  vx=xp(:,1);

  vy=xp(:,2);

  w=xp(:,3);

end
