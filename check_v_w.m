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

% Vx = vx.*cos(gt_theta) - vy.*sin(gt_theta);
% Vy = vx.*sin(gt_theta) + vy.*cos(gt_theta);

gt_vx = gt_Vx.*cos(gt_theta) + gt_Vx.*sin(gt_theta);
gt_vy = -gt_Vx.*sin(gt_theta) + gt_Vy.*cos(gt_theta);


figure(1)
plot(t,gt_Vx)
title("V");
ylabel("velocity [m/s]");
xlabel("time [s]");

figure(2)
plot(t,gt_Vy)
title("Vn");
ylabel("velocity [m/s]");
xlabel("time [s]");

figure(3)
plot(t,gt_w)
title("w");
ylabel("angular velocity [rad/s]");
xlabel("time [s]");
