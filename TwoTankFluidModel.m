%% Load Data
close all
rho =1000;
g = 9.81;
%% Validation Data 1
VD1 = load('TT_DynamicValidationData_1.txt');
time = 0:0.05:(0.05*(length(VD1(:,1))-1));
plotyy(time,VD1(:,1),time,VD1(:,3)-6.9)
hold on
plot(time,VD1(:,2),'g')
Vcom= VD1(:,3)-6.9;
Ht = VD1(:,1);
Hb = VD1(:,2);
IC = [.21; .27];
%% Validation Data 2
% VD2 = load('TT_DynamicValidationData_2.txt');
% time = 0:0.05:(0.05*(length(VD2(:,1))-1));
% time = time';
% plotyy(time,VD2(:,2),time,VD2(:,3)-6.9)
% hold on
% plot(time,VD2(:,1),'g')
% Vcom = VD2(:,3)-6.9;
% Ht = VD2(:,1);
% Hb = VD2(:,2);
% IC = [.1757; .25];
%% Top Tank Drain
% MDT = load('TT_TopTankDrain_0.295in_3.txt');
% time = 0:0.05:(0.05*(length(MDT(:,1))-1));
% plotyy(time,MDT(:,1),time,MDT(:,3))
% hold on
% plot(time,MDT(:,2),'g')
% Vcom = MDT(:,3)-6.9;
% IC = 0.35;
% ExpTime = time(480:1001);
% ExpData = MDT(480:1001,1)/100;
% figure
% plot(ExpTime,ExpData)
%% Bottom Tank Drain
% MDB = load('TT_BottomTankDrain_10mm_4.txt');
% time = 0:0.05:(0.05*(length(MDB(:,1))-1));
% plotyy(time,MDB(:,2),time,MDB(:,3))
% hold on
% plot(time,MDB(:,1),'g')
% Vcom = MDB(:,3)-6.9;
% IC = 0.43;
% ExpTime = time(1000:1647);
% ExpData = MDB(1000:1647,2);
% figure
% plot(ExpTime,ExpData)
 
%Model 1
 
function  CP5_Model1(Vcom,time)
clear all
run('LoadData.m')
Tau_T = 11.2;
Tau_B = 15.3;
Z = 3.4575e-5;
rho = 1000;
d = 0.08;
area = pi*(d/2)^2;
g = 9.81;
RT = Tau_T*rho*g/area;
RB = Tau_B*rho*g/area;
 
 
A = [-rho*g/(RT*area) 0; rho*g/(RT*area) -rho*g/(RB*area)];
B = [Z/area;0];
C = [1 0; 0 1];
D = [0; 0];
sys1 = ss(A,B,C,D);
[H,tsim] = lsim(sys1,Vcom,time,IC);
figure
plot(tsim,H(:,1),time,Ht/100,'g')
hold on
plot(tsim,H(:,2))
[ax h1 h2] = plotyy(time,Hb/100,tsim,Vcom);
legend('Htop - sim','Htop - data','Hbottom - sim','Hbottom - data','Command Voltage','location','best')
grid on
xlabel('Time (s)')
axes(ax(1)); ylabel('Height (m)');
axes(ax(2)); ylabel('Volts (V)');
RMSEt = sqrt(sum(((H(:,1)-Ht).^2)/length(tsim)));
RMSEb = sqrt(sum(((H(:,2)-Hb).^2))/length(tsim));
dim = [.7 .07 .3 .3];
str = strcat('RMSE Top= ',num2str(RMSEt));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [.7 .0 .3 .3];
str = strcat('RMSE Bottom= ',num2str(RMSEb));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
title('Linear Resistance Model - Validation Set 1')
end



 
close all
figure
plot(time(480:1001),MDT(480:1001,1)/100,'-')
hold on
Cd_est = 0.4:0.1:1.2;
for i =1:length(Cd_est)
Cd = Cd_est(i);
[tsim,Ht] = ode45(@TopOde,time(480:1001),0.34,[],Cd);
plot(time(480:1001),Ht)
hold on
pause(1)
legarray{i}= strcat('Cd=',num2str(Cd));
end
legarray = ['Data';legarray];
legend(legarray,'location','best')
grid on
xlabel('time (s)')
ylabel('Height (m)')
title('Top Tank Drain')
Cd_T = Cd_est(6);
[tsim,Ht] = ode45(@TopOde,time(480:1001),0.34,[],Cd_T);
figure
plot(time(480:1001),Ht,time(480:1001),MDT(480:1001,1)/100)


function dh = TopOde(t,H,Cd)
rho = 1000;
    
d = 0.08;
area = pi*(d/2)^2;
do = 0.295/39.3701;
Ao = pi*(do/2)^2;
g = 9.81;
dh =-(Cd*Ao/area)*sqrt(2*g*H);
 
end

clc
run('LoadData.m')
 
 
 
figure
plot(time(1000:1647),MDB(1000:1647,2)/100)
hold on
Cd_est = 0.4:0.1:1.2;
for i =1:length(Cd_est)
Cd = Cd_est(i)
[tsim,Hb] = ode45(@BottomOde,time(1000:1647),0.43,[],Cd);
plot(time(1000:1647),Hb)
hold on
pause(1)
legarray{i}= strcat('Cd=',num2str(Cd));
end
legarray = ['Data';legarray];
legend(legarray,'location','best')
grid on
xlabel('time (s)')
ylabel('Height (m)')
title('Bottom Tank Drain')
Cd_B = Cd_est(2);
[tsim,Hb] = ode45(@BottomOde,time(1000:1647),0.43,[],Cd_B);
figure
plot(time(1000:1647),Hb,time(1000:1647),MDB(1000:1647,2)/100)
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

run('LoadData.m')
 
[tsim,H] = ode45(@dh,time,IC,[],Vcom,time);
figure
 
 
 
plot(time,Ht./100,time,Hb./100)
hold on
[ax h1 h2]=plotyy(tsim,H,tsim,Vcom);
legend('Htop - sim','Htop - data','Hbottom - sim','Hbottom - data','Command Voltage','location','NE')
grid on
xlabel('Time (s)')
axes(ax(1)); ylabel('Height (m)');
axes(ax(2)); ylabel('Volts (V)');
RMSEt = sqrt(sum(((H(:,1)-Ht).^2)/length(tsim)));
RMSEb = sqrt(sum(((H(:,2)-Hb).^2))/length(tsim));
dim = [.15 .07 .3 .3];
str = strcat('RMSE Top= ',num2str(RMSEt));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [.15 .01 .3 .3];
str = strcat('RMSE Bottom= ',num2str(RMSEb));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
title('Bernoulli Model - Validation Set 2')
 
function [estimates, model] = optimize_model3(area,ExpData,ExpTime,IC)
% Call fminsearch with a random starting point.
start_point = [1e-6 .5];
model = @expfun;
format long g
estimates = fminsearch(model, start_point);
 
 
    function [J, h] = expfun(params)
  
        k = params(1);
        m = params(2);
        
        [t,h] = ode45(@model,ExpTime,IC);
 
        function dhdt = model(t,h) 
            if h < 0
                h = 0;
            end
            dhdt = -k/area * (1000*9.81*h)^m;
        end
 
        J = sum((h-ExpData).^2);
 
    end
end

close all
[tsim,H] = ode45(@dh3,time,IC,[],Vcom,time);
figure
plot(tsim,H)
legend('Ht','Hb')
hold on
plot(time,Ht/100)  
[ax h1 h2] = plotyy(time,Hb/100,tsim,Vcom);
legend('Htop - sim','Htop - data','Hbottom - sim','Hbottom - data','Command Voltage','location','NE')
grid on
xlabel('Time (s)')
axes(ax(1)); ylabel('Height (m)');
axes(ax(2)); ylabel('Volts (V)');
RMSEt = sqrt(sum(((H(:,1)-Ht).^2)/length(tsim)));
RMSEb = sqrt(sum(((H(:,2)-Hb).^2))/length(tsim));
dim = [.15 .07 .3 .3];
str = strcat('RMSE Top= ',num2str(RMSEt));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [.15 .0 .3 .3];
str = strcat('RMSE Bottom= ',num2str(RMSEb));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
title('Empirical Model - Validation Set 1')




