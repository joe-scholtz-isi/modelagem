data = csvread("data/dynamics.csv");

wheels_radius =  0.24;

t = data(:,1) - data(2,1);
t(1) = 0;
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

[ax, ay, wp] = dinamica_direta(gt_Vx, gt_Vy, gt_w, F1, F2, F3, F4, s1, s2, s3, s4)

w = cumtrapz(t,wp');

theta = cumtrapz(t,w');
theta = atan2(sin(theta),cos(theta)); %wrap to [-pi;pi]

vx = cumtrapz(t,ax');
vy = cumtrapz(t,ay');

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
