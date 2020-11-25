%QPSK simulation with Gray coding and simple Rayleigh (no LOS) multipath and AWGN added
%Run from editor debug(F5)
%JC-7/1/08
%The purpose of this m-file is to show a baseband simulated version of QPSK with
%Gray coding( Rayleigh multipath and AWGN added) which may give valid results
%(still trying to figure out if this program is correct-multipath so subjective)
%when compared to theoritical/simulated AWGN MPSK analysis SER and BER.
%The simulation assumes a single channel(no diversity or FEC codes other than Gray)
%perfect system with perfect sync and no intersymbol interference. The program contains
%no Root Raised Cosine or Raised Cosine filters as they would just add delay. I hope
%it will be useful to others to play with and give a basic understanding of the problems
%encountered in the channel with various types of multipath.
%I have provided comments, notes and references for review. You can also
%download the file sim_qpskgray.m under JC file for BER and SER simulation
%only in AWGN channel. What this all proves is that you need at least 17 dB
%of fade margin at 10-3 BER with Rayleigh multipath when comparing only with AWGN 
%at SNR of 7 to 8dB. Of course you can lower this with antenna diversity, FEC codes,etc
%or possibly with DSSS with psuedo random codes If you have the communications toolbox
%you can make comparisons with what it gives in it's plots(see references)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TRANSMITTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%randn('state',0);%keeps bits the same on reruns
nr_data_bits=1000000;% 0's and 1's, keep even number-Takes ~1 minute for a run of 1 million
%64000 allows bits and complex values to be shown in array editor
nr_symbols=nr_data_bits/2;
b_data = (randn(1, nr_data_bits) > .5);%random 0's and 1's
b = (b_data);
% Map the bits to be transmitted into QPSK symbols using Gray coding. The
% resulting QPSK symbol is complex-valued, where one of the two bits in each
% QPSK symbol affects the real part (I channel) of the symbol and the other
% bit the imaginary part (Q channel). Each part is subsequently
% modulated to form the complex-valued QPSK symbol.
%
% The Gray mapping resulting from the two branches are shown where
% one symbol error corresponds to one bit error going counterclockwise.
% imaginary part (Q channel)
%         ^
%         |
%  10 x   |   x 00   (odd bit, even bit)
%         |
%  -------+------->  real part (I channel)
%         |
%  11 x   |   x 01
%         |
% Input:
%   b = bits {0, 1} to be mapped into QPSK symbols
%
% Output:
%   d = complex-valued QPSK symbols  0.70711 + 0.70711i, etc


d=zeros(1,length(b)/2);
%definition of the QPSK symbols using Gray coding.
for n=1:length(b)/2
    p=b(2*n);
    imp=b(2*n-1);
    if (imp==0)&&(p==0)
        d(n)=exp(j*pi/4);%45 degrees
    end
    if (imp==1)&&(p==0)
        d(n)=exp(j*3*pi/4);%135 degrees
    end
    if (imp==1)&&(p==1)
        d(n)=exp(j*5*pi/4);%225 degrees
    end
    if (imp==0)&&(p==1)
        d(n)=exp(j*7*pi/4);%315 degrees
    end
end
qpsk=d;


SNR=0:30;%change SNR values
BER1=[];
SNR1=[];
SER=[];
SER1=[];
sigma1=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rayleigh multipath/AWGN(Additive White Gaussian Noise)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for SNR=0:length(SNR);%loop over SNR-change SNR values (0,5,10 etc dB)
sigma = sqrt(10.0^(-SNR/10.0));
sigma=sigma/2;%Required a division by 2 to get close to exact solutions(Notes)-WHY?
%Is dividing by two(2) legitimate?
%sigma1=[sigma1 sigma];
%add Rayleigh multipath(no LOS) to signal(qpsk)
x=randn(1,nr_symbols); 
y=randn(1,nr_symbols);
ray=sqrt(0.5*(x.^2+y.^2));%variance=0.5-Tracks theoritical PDF closely
mpqpsk=qpsk.*ray;
%add noise to QPSK Gray coded signals with multipath
mpsnqpsk=(real(mpqpsk)+sigma.*randn(size(mpqpsk))) +i.*(imag(mpqpsk)+sigma.*randn(size(mpqpsk)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=mpsnqpsk;%received signal plus noise and multipath
%Detector-When Gray coding is configured as shown, the detection process
%becomes fairly simple as shown. A system without Gray coding requires a much
%more complex algorithim detection method
bhat=[real(r)<0;imag(r)<0];%detector 
bhat=bhat(:)';
bhat1=bhat;%0's and 1's

ne=sum(b~=bhat1);%number of errors
BER=ne/nr_data_bits;
SER=ne/nr_symbols;%consider this to be Ps=log2(4)*Pb=2*Pb
SER1=[SER1 SER];
BER1=[BER1 BER];
SNR1=[SNR1 SNR];
end


%Notes: Theoritical QPSK EXACT SOLUTION for several SNR=Eb/No points on BER/SER plot
%Assuming Gray coding and AWGN
%Pb=Q(sqrt(2SNRbit))
%Ps=2Q(sqrt(2SNRbit))[1-.5Q(sqrt(2SNRbit))]
%SNR=7dB
%SNRbit=10^(7/10)=5.0118 get ratio
%Pb=Q(sqrt(2*SNRbit))=Q(sqrt(10.0237))=7.7116e-4  (bit error rate)
%where Q=.5*erfc(sqrt(10.0237)/1.414)
%Ps=2*Q-Q^2=2*(7.7116e-4)-(7.7116e-4)^2=1.5e-3   (symbol error rate)
%SNR=9dB
%SNRbit=10^(9/10)=7.943 get ratio
%Pb=Q(sqrt(2*SNRbit))=Q(sqrt(15.866))=3.37e-5  (bit error rate)
%Ps=2*Q-Q^2=2*(3.37e-5)-(3.37e-5)^2=6.74e-5   (symbol error rate)
%0,1,2,3,4,5,6,8,10,11,12 You can do the rest of these with a loop and hold
%or hand plot on "Simulation of BER/SER for QPSK with Gray coding
%(Rayleigh multipath and AWGN) graph 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
plot(d,'o');%plot constellation without noise
axis([-2 2 -2 2]);
grid on;
xlabel('real'); ylabel('imag');
title('QPSK constellation');

figure(2);
semilogy(SNR1,BER1,'*',SNR1,SER1,'o');
grid on; 
xlabel('SNR=Eb/No(dB)'); ylabel('BER/SER');
title('Simulation of BER/SER for QPSK with Gray coding( Rayleigh multipath and AWGN)');
legend('BER-simulated','SER-simulated');

figure(3)
plot(real(qpsk));
grid on;
axis([1 200 -2 2]);
title('QPSK symbols');
xlabel('symbols');ylabel('Amplitude');

figure(4)
plot(20*log10(abs(ray)));
grid on;
axis([1 200 -30 10]);
title('Rayleigh Fading Envelope(variance=0.5)');
xlabel('symbols');ylabel('Amplitude/RMS(dB)');

%References
%This website shows Matlab code for various fading channels that may be helpful
%http://www.urel.feec.vutbr.cz//RADIOENG/fulltexts/2003/03_04_12_16.pdf or
%search the web for "Mobile Radio Channels Modeling in Matlab-Nikolay KOSTOV". If
%you go through and understand this paper, I'm sure it will be helpful. I even learned 
%how to use -inf. 

%PROAKIS, Digital Communications 4th ed. (chapter 14)14.4.2 Fading Multiphase Signals

%Mathworks, Communications Toolbox, Fading Channels

