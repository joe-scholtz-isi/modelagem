data = csvread("data/dynamics_wo_pid.csv");

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
F1 = data(:,12) / wheels_radius;
s2 = data(:,13);
F2 = data(:,14) / wheels_radius;
s3 = data(:,15);
F3 = data(:,16) / wheels_radius;
s4 = data(:,17);
F4 = data(:,18) / wheels_radius;


vx = [];
vy = [];
w = [];

ax = [];
ay = [];
wp = [];

for i = 1:length(F1)
  i
  length(F1)
  if(i == 1)
    [x2p, y2p, theta2p] = direct_dynamics(0,0,0, F1(i), F2(i), F3(i), F4(i), s1(i), s2(i), s3(i), s4(i))
  else
    [x2p, y2p, theta2p] = direct_dynamics(vx(end), vy(end), w(end), F1(i), F2(i), F3(i), F4(i), s1(i), s2(i), s3(i), s4(i))
  endif

  ax(end + 1) = x2p;
  ay(end + 1) = y2p;
  wp(end + 1) = theta2p;

  vx(end + 1) = trapz(t(1:i),ax);
  vy(end + 1) = trapz(t(1:i),ay);
  w(end + 1) = trapz(t(1:i),wp);
end

theta = cumtrapz(t,w')+ gt_theta(3);
theta = atan2(sin(theta),cos(theta)); %wrap to [-pi;pi]

Vx = vx'.*cos(gt_theta) - vy'.*sin(gt_theta);
Vy = vx'.*sin(gt_theta) + vy'.*cos(gt_theta);

x = cumtrapz(t,Vx) + gt_x(3);
y = cumtrapz(t,Vy) + gt_y(3);

data = [t,x,y,theta];

figure(1)
plot(t,[theta,gt_theta])
legend(["model prediction";"ground truth"])
title("global theta angle of the robot");
ylabel("angle [rad]");
xlabel("time [s]");

figure(2)
plot(t,[x,gt_x])
legend(["model prediction";"ground truth"])
title("global x coordinate of the robot");
ylabel("distance [m]");
xlabel("time [s]");

figure(3)
plot(t,[y,gt_y])
legend(["model prediction";"ground truth"])
title("global y coordinate of the robot");
ylabel("distance [m]");
xlabel("time [s]");

figure(4)
plot(x,y)
title("global x-y coordinate of the robot");
ylabel("distance [m]");
xlabel("distance [m]");
hold on
plot(gt_x,gt_y)
legend(["model prediction";"ground truth"])
hold off

% csvwrite("data/dynamics_out.csv",data);
