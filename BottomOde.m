function dh = BottomOde(t,H,Cd)
rho = 1000;
    
d = 0.08;
area = pi*(d/2)^2;
dot = 0.295/39.3701;
Aot = pi*(dot/2)^2;
dob = 10/1000;
Aob = pi*(dob/2)^2;
g = 9.81;
dh =-(Cd*Aob/area)*sqrt(2*g*H);
end