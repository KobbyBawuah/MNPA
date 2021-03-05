%Kwabena Gyasi Bawuah 
%101048814

close all 

global G 
global C
global F

G = zeros(6, 6); 
C = zeros(6, 6); 
F = zeros(6, 1);
vo2 = zeros(1000, 1); 
W = zeros(1000, 1);
%part d
CC = zeros(1000,1);
GG = zeros(1000,1);


%Circuit Parameters 
%resistances and conductances
R1 = 1;
R2 = 2;
R3 = 10;
R4 = 0.1; 
R0 = 1000; 
G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G0 = 1/R0;
L = 0.2;
a = 100;
Cap = 0.25;

vi = zeros(100, 1);
vo = zeros(100, 1);
v3 = zeros(100, 1);

G(1, 1) = 1;                                        
G(2, 1) = G1; G(2, 2) = -(G1 + G2); G(2, 6) = -1;   
G(3 ,3) = -G3; G(3, 6) = 1;                       
G(4, 3) = -a*G3; G(4, 4) = 1;                        
G(5, 5) = -(G4+G0); G(5, 4) = G4;   
G(6, 2) = -1; G(6, 3) = 1;

C(2, 1) = Cap; C(2, 2) = -Cap;
C(6, 6) = L;

v = 0;
% [V1 Iin V2 I3 V4 Icc Vo]

%DC Case
%capacitive/inductive effect
s = 0;

for Vin = -10:0.1:10
    v = v + 1;
    F(1) = Vin;
    
    Vm = G\F;
    vi(v) = Vin;
    vo(v) = Vm(5);
    v3(v) = Vm(3);
    %v = v + 1;
end

figure(1)
subplot(2,2,1)
plot(vi, vo);
hold on;
plot(vi, v3);
title('VO and V3 against DC Sweep of (Vin): -10 V to 10 V');
xlabel('V')
ylabel('Vin')
legend('Vo','V3')

Avlog = zeros(1000, 1);

for freq = linspace(0, 100, 1000)
    v = v + 1;
    Vm2 = (G + 1j * freq * C) \ F;
    W(v) = freq;
    vo2(v) = norm(Vm2(5));
    %to get the db
    Avlog(v) = 20*log10(norm(Vm2(5))/10);
end 

subplot(2,2,2)
plot(W, vo2)
hold on;
plot(W, Avlog)
title('Vo(w) and gain in dB as a function of ω')
xlabel('ω(rad)')
ylabel('V(dB)')
legend('Vo','V3')

%using a normal distribution with std = 0.05 and w=π
w = 3.14;
for i = 1:1000
    randp = Cap + 0.05*randn();
    C(2, 1) = randp; 
    C(2, 2) = -randp;
    C(3, 3) = L;
    Vm3 = (G+1i*w*C)\F;
    CC(i) = randp;
    %for the gain
    GG(i) = 20*log10(norm(Vm3(5))/10);
end

subplot(2,2,3)
histogram(CC)
xlabel('C')
ylabel('Number')
subplot(2,2,4)
histogram(GG)
xlabel('Vo/Vi')
ylabel('Number')
