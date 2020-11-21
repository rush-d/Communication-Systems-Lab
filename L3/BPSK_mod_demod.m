% XXXXXXXXXXXXXXXXXXX BPSK modulation and de-modulation XXXXXXXXXXXXXXXXXX%

clc;
close all;


% XXXXXXXXXXXXXXXXXXXXX Define transmitted signal XXXXXXXXXXXXXXXXXXXXX

N=10; % Number of bits 
x_inp= rand(2,1,N);   % message to be transmitted                               
Tb=0.0001; % bit period (second)   


% XXXXXXXXXXXXXXXX Represent input signal as digital signal XXXXXXX

x_bit=[]; % modulated bit
nb=100; % bbit/bit
for n=1:1:N   % 
    if x_inp(n)==1   
       x_bitt=ones(1,nb); % modulated bit is 1
    else x_inp(n)== 0
        x_bitt=zeros(1,nb); % modulated bit is -1
    end
     x_bit=[x_bit x_bitt];
end

t1=Tb/nb:Tb/nb:nb*N*(Tb/nb); % time of the signal 

% plot
f1 = figure(1);
set(f1,'color',[1 1 1]);
subplot(3,1,1);
plot(t1,x_bit,'lineWidth',2);
grid on;
axis([ 0 Tb*N -0.5 1.5]);
ylabel('Tmplitude(volt)');
xlabel(' Time(sec)');
title('Input signal as digital signal');


% XXXXXXXXXXXXXXXXXX Define BPSK Modulation XXXXXXXXXXXXXXXXXXXXXXXXXXXX

Ac=5;  % Amplitude of carrier signal
mc=4;  % fc>>fs fc=mc*fs fs=1/Tb
fc=mc*(1/Tb); % carrier frequency for bit 1
fi1=0; % carrier phase for bit 1
fi2=pi; % carrier phase for bit 0
t2=Tb/nb:Tb/nb:Tb;                 
t2L=length(t2);
x_mod=[];
for i=1:1:N
    if (x_inp(i)==1)
        x_mod0=Ac*cos(2*pi*fc*t2+fi1);%modulation signal with carrier signal 1
    else
        x_mod0=Ac*cos(2*pi*fc*t2+fi2);%modulation signal with carrier signal 2
    end
    x_mod=[x_mod x_mod0];
end
t3=Tb/nb:Tb/nb:Tb*N;
subplot(3,1,2);
plot(t3,x_mod);
xlabel('Time(sec)');
ylabel('Amplitude(volt)');
title('Signal of  BPSK modulation ');


% XXXXXXXXXXXXXXXXXXXX Transmitted signal x XXXXXXXXXXXXXXXXXXXXXXXXXX
x=x_mod;

% XXXXXXXXXXXXXXXXXXXX Channel model h and w XXXXXXXXXXXXXXXXXXXXXXXXXXX
h=1; % Fading 
w=0.2; % Noise

% XXXXXXXXXXXXXXXXXXXX Received signal y XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
y=h.*x+w;


% XXXXXXXXXXXXXXXXXXX Define BPSK Demodulation XXXXXXXXXXXXXXXXXXXXXXXXXX

y_dem=[];
for n=t2L:t2L:length(y)
  t=Tb/nb:Tb/nb:Tb;
  c=cos(2*pi*fc*t); % carrier siignal 
  y_dem0=c.*y((n-(t2L-1)):n);
  t4=Tb/nb:Tb/nb:Tb;
  z=trapz(t4,y_dem0); % intregation 
  A_dem=round((2*z/Tb));                                     
  if(A_dem>Ac/2) % logic level = Ac/2
    A=1;
  else
    A=0;
  end
  y_dem=[y_dem A];
end

x_out=y_dem; % output signal;

% XXXXXXXXXX Represent output signal as digital signal XXXXXXXXXXXXXXXX
xx_bit=[];
for n=1:length(x_out)
    if x_out(n)==1
       xx_bitt=ones(1,nb);
    else x_out(n)==0
        xx_bitt=zeros(1,nb);
    end
     xx_bit=[xx_bit xx_bitt];

end
t4=Tb/nb:Tb/nb:nb*length(x_out)*(Tb/nb);
subplot(3,1,3)
plot(t4,xx_bit,'LineWidth',2);grid on;
axis([ 0 Tb*length(x_out) -0.5 1.5]);
ylabel('Amplitude(volt)');
xlabel(' Time(sec)');
title('Output signal as digital signal');


% XXXXXXXXXXXXXXXXXXXXXXXX end of program XXXXXXXXXXXXXXXXXXXXXXXXXXXXX