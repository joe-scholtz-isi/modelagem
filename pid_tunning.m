s = tf("s")
%     1.471 s - 0.02329
%   ----------------------
%   s^2 + 0.2136 s + 1.789
%
numG1 = [1.471, 0.02329];
denG1 = [1, 0.2136, 1.789];

G1 = tf(numG1,denG1);

[zG1,pG1,kG1] = tf2zp(G1)

% rlocusx(G1)

% Kd = 25
% [numCinner,denCinner] = zp2tf(pG1,[0],Kd)
% Cinner = tf(numCinner,denCinner)

Cinner = 1.7

Tinner = (Cinner*G1)/(1+Cinner*G1)

[z,p,k] = tf2zp(Tinner)

% Ti = Tinner
[numTi, denTi] = zp2tf([z(3)],p([3,4]),k)
Ti = tf(numTi,denTi)
[zi,pi,ki] = tf2zp(Ti)

k = 100
Co = k
To = (Co*(Ti)/s)/(1+Co*(Ti)/s)
