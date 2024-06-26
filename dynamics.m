data = csvread("data/dynamics.csv");

wheels_radius =  0.24;

t = data(:,1) - data(2,1);
t(1) = 0;
t(2) = ( t(3) - t(1) )/2.0;
gt_x = data(:,2);
gt_y = data(:,3);
gt_theta = data(:,5);
gt_Vx = data(:,6);
gt_Vy = data(:,7);
gt_w = data(:,9);

t_joint = data(:,10) - data(2,10);
t_joint(1) = 0;
s1 = data(:,11);
F1 = data(:,12) * wheels_radius;
s2 = data(:,13);
F2 = data(:,14) * wheels_radius;
s3 = data(:,15);
F3 = data(:,16) * wheels_radius;
s4 = data(:,17);
F4 = data(:,18) * wheels_radius;


vx = [0];
vy = [0];
w = [0];

ax = [];
ay = [];
wp = [];

for i = 1:length(F1)/10
  [x2p, y2p, theta2p] = dinamica_direta(vx(end), vy(end), w(end), F1(i), F2(i), F3(i), F4(i), s1(i), s2(i), s3(i), s4(i))

  ax(end + 1) = x2p;
  ay(end + 1) = y2p;
  wp(end + 1) = theta2p;

  vx(end + 1) = trapz(t(1:i),ax);
  vy(end + 1) = trapz(t(1:i),ay);
  w(end + 1) = trapz(t(1:i),wp);
end

theta = cumtrapz(t,w');
theta = atan2(sin(theta),cos(theta)); %wrap to [-pi;pi]

Vx = vx'.*cos(theta) - vy'.*sin(theta);
Vy = vx'.*sin(theta) + vy'.*cos(theta);

x = cumtrapz(t,Vx);
y = cumtrapz(t,Vy);

data = [t,x,y,theta];

% plot(t,[theta,gt_theta])
% legend(["theta";"gt theta"])
plot(t,x)
hold on
plot(t,gt_x)
legend(["Vx";"gt Vx"])
% plot(t,[y,gt_y])
% legend(["y";"gt y"])
% plot(t,[x,y,theta,gt_x,gt_y,gt_theta]);
% legend(["x";"y";"theta";"ground truth x"; "ground truth y"; "ground truth theta"]);

csvwrite("data/dynamics_out.csv",data);
