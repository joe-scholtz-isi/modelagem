data = csvread("data/kinematics_wo_pid_2.csv");

wheels_radius =  0.24;

t = data(:,1) - data(2,1);
t(1) = 0;
t(2) = ( t(3) - t(1) )/2.0;
gt_x = data(:,2);
gt_y = data(:,3);
gt_theta = data(:,5);

t_joint = data(:,6) - data(2,6);
t_joint(1) = 0;
s1 = data(:,7);
V1 = data(:,8) * wheels_radius;
s2 = data(:,9);
V2 = data(:,10) * wheels_radius;
s3 = data(:,11);
V3 = data(:,12) * wheels_radius;
s4 = data(:,13);
V4 = data(:,14) * wheels_radius;

[vx, vy, w] = direct_kinematics(V1,V2,V3,V4, s1, s2, s3, s4);

theta = cumtrapz(t_joint,w) + gt_theta(3);
theta = atan2(sin(theta),cos(theta)); %wrap to [-pi;pi]

Vx = vx.*cos(gt_theta) - vy.*sin(gt_theta);
Vy = vx.*sin(gt_theta) + vy.*cos(gt_theta);

x = cumtrapz(t_joint,Vx) + gt_x(3) - 0.5;
y = cumtrapz(t_joint,Vy) + gt_y(3);

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

%csvwrite("data/kinematics_out.csv",data);
