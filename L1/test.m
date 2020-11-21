clc;
close all;
clear ;

%XXXXXXXXXXXXXXXXXXXXXXXXXXX Define AM modulation Index XXXXXXXXXXXXXXXXXXX
%disp(' example: m=1 means 100% modulation');
%m=input(' Enter the value of modulation index (m) = ');
m=1; % for 100% modulation
if (0>m||m>1)
error('m may be less than or equal to one and geter than to zero'); 
end


% Representation of the Message Signal
fs=1024;%sampling frequency
Ts=1/fs;%sampling period
n=4 %number of cycles
Am=5;    %Message_Signal_Amplitude = input ('Enter the message signal amplitude = ');
fm=20;   % Frequency of message signal
Tm=1/fm;  % Time period of message signal
% t= 0:Ts/999:n*Ts-Ts; %time axis
t = 0:Tm/100:10*Tm;

ym = Am.*sin (2*pi*fm*t);   % Equation of message signal
figure();
subplot (5,1,1);
plot (t,ym,'bl');
xlabel ('Time ---->');
ylabel ('Amplitude ---->');
title ('Message Signal ---->');


% Representation of the Carrier Signal

Ac=Am/m;% Amplitude of carrier signal [ where, modulation Index (m)=Am/Ac ]
fc=fm*10;% Frequency of carrier signal
Tc=1/fc;% Time period of carrier signal
yc=Ac*sin(2*pi*fc*t);% Eqation of carrier signal
subplot (5,1,2);
plot (t,yc,'g');
xlabel ('Time ---->');
ylabel ('Amplitude ---->');
title ('Carrier Signal ---->');




% **********DEFINE HILBERT TRANSFORM and took only it's imaginary part*****

% Hilbert transform of baseband 
mh = imag(hilbert(ym));  



%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SSB modulation XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   
  
% Single Side Band with Upper Side Band  
sb = ym .*cos(2 * pi * fc * t) - mh .*sin(2 * pi * fc * t);  
  
% displaying the modulation
subplot (5,1,3);
plot(t, sb); 
title('Single SideBand Modulation'); 
xlabel('Time(sec)'); 
ylabel('Amplitude'); 

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SSB demodulation XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   


% equation for demodulated signal
sb_dm = sb.*sin(2*pi*fc*t);
% figure;
% plot(t,sb_dm);
% title('check1');
  

% for removing dc component
sigLen = length(sb_dm);
intermediateSigFFT = fftshift(fft(sb_dm));
intermediateSigFFT(ceil(sigLen/2)) = 0;
sb_dm = ifft(ifftshift(intermediateSigFFT));
% figure;
% plot(t,sb_dm);
% title('check2');
  
% displaying the modulation
subplot (5,1,4);
plot(t, sb_dm); 
title('Single SideBand Demodulation'); 
xlabel('Time(sec)'); 
ylabel('Amplitude'); 

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SSB recover signal XXXXXXXXXXXXXXXXXXXXXXXXXXXXX   
fs=512;%sampling frequency

% filtering demodulated signal to get beck our message signal
[B,A]=butter(4,fm*2/fs,'Low'); % use butterworth filter 
sb_rec = filter(B,A,sb_dm); % passing through demodulated signal by butterworth filter
sb_rec = Am*sb_rec/max(sb_rec);

%plot
subplot(5,1,5);
plot(t,sb_rec);% Graphical representation of  final recover SSB signal
title ( '  recovered signal  ');
xlabel ( ' time(sec) ');
ylabel (' Amplitude(volt)   ');
grid on;



%<<<<<<<<<<<<<<<<<<< Frequency-domain <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SSB FREQUENCY DOMAIN MODULATION XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

% t=[0:Ts:N*Ts-Ts]; %time axis
N_FFT= fftshift(fft(sb))/numel(sb);
N=numel(N_FFT); %number of samples
f=[-fs/2:fs/N:fs/2-fs/N]; %frequency axis

% ym=Am*sin(2*pi*fm*t); % Eqation of modulating signal
% yc=Ac*sin(2*pi*fc*t);% Eqation of carrier signal
% sb = ym .*cos(2 * pi * fc * t) - mh .*sin(2 * pi * fc * t);   % Equation of  modulated signal

% Y=fft(sb);%modulated signal DFT

%plot
figure;
plot(f,abs(N_FFT)); % Graphical representation in frequency domain modulated SSB signal
title('ssb Modulation Signal Spectrum');
xlabel('Frequency axis');
ylabel('Amplitude');


%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SSB FREQUENCY DOMAIN DEMODULATION XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

sb_dm=sin(2*pi*fc*t).*sb;   %equation for demodulated signal

% for removing dc component
sigLen = length(sb_dm);
intermediateSigFFT = fftshift(fft(sb_dm));
intermediateSigFFT(ceil(sigLen/2)+1) = 0;
sb_dm= ifft(ifftshift(intermediateSigFFT));

%filtering out demodulated signal in frequency domain
[b, a] = butter(4, (2*(fm+1))/fs, "low");
sb_dm = filter(b, a, sb_dm);
Y_dm=fft(sb_dm);%modulated signal DFT

%plot
figure()
plot(f,fftshift(abs(Y_dm))); % Graphical representation in frequency domain demodulated SSB signal
title('SSB Signal Spectrum');
xlabel('Frequency axis');
ylabel('Amplitude');
