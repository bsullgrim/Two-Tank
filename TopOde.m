function dh = TopOde(t,H,Cd)
rho = 1000;
    
d = 0.08;
area = pi*(d/2)^2;
do = 0.295/39.3701;
Ao = pi*(do/2)^2;
g = 9.81;
dh =-(Cd*Ao/area)*sqrt(2*g*H);

end