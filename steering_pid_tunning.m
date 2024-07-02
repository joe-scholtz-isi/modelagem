pkg load control %octave's control package

Gnum = [0.1234 1.7268 -0.4245 0.6037];
Gden = [1 0.3015 2.0288 0.4422 0.8247];

G = tf(Gnum,Gden)
[Gp Gz] = pzmap(G)

rlocus(G)
