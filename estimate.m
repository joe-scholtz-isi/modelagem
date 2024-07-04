data = csvread("data/open_loop_steering_cut.csv");
%
dtime = seconds(linspace(0,data(length(data),1)-data(1,1),length(data))');
tt = timetable(dtime,data(:,2),data(:,3));

[sys2, ic2 ] = tfest(tt,2)
[sys3, ic3 ] = tfest(tt,3)
[sys4, ic4 ] = tfest(tt,4)
[sys5, ic5 ] = tfest(tt,5)

y2 = sim(sys2,data(:,2));
y3 = sim(sys3,data(:,2));
y4 = sim(sys4,data(:,2));
y5 = sim(sys5,data(:,2));

plot(data(:,3))
hold on;
plot(y2)
plot(y3)
plot(y4)
plot(y5)
hold off;
legend('gt','y2','y3','y4','y5')

%
% [sys2, ic2 ] = tfest(data(:,2),data(:,3),4);
% [sys3, ic3 ] = tfest(data(:,2),data(:,3),4);
% [sys4, ic4 ] = tfest(data(:,2),data(:,3),4);
% 
% y2 = sim(sys2,data(:,2));
% y3 = sim(sys3,data(:,2));
% y4 = sim(sys4,data(:,2));
% 
% plot(data(:,3))
% hold on
% plot(y2)
% plot(y3)
% plot(y4)
% hold off
