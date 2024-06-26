data = csvread("data/kinematics.csv");

wheels_radius =  0.24;

t = data(:,1) - data(2,1);
t(1) = 0;
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

[vx, vy, w] = cinematica_direta(V1,V2,V3,V4, s1, s2, s3, s4);

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
% plot(t,[y,gt_y])
% legend(["y";"gt y"])
% plot(t,[x,y,theta,gt_x,gt_y,gt_theta]);
% legend(["x";"y";"theta";"ground truth x"; "ground truth y"; "ground truth theta"]);

csvwrite("data/data_out.csv",data);
