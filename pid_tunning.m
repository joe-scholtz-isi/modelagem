%     1.471 s - 0.02329
%   ----------------------
%   s^2 + 0.2136 s + 1.789
%
numG1 = [1.471, 0.02329];
denG1 = [1, 0.2136, 1.789];

G1 = tf(numG1,denG1);

rlocusx(G1)

Kp = 1.7
numCinner = [Kp]
denCinner = [1]

Cinner = tf(numCinner,denCinner);

Tinner = (Cinner*G1)/(1+Cinner*G1)

[z,p,k] = tf2zp(Tinner)


