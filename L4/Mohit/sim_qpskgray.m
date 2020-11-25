%QPSK simulation with Gray coding
%Run from editor debug(F5)
%JC 2/16/07
%The purpose of this m-file is to show a baseband simulated version of QPSK with
%Gray coding which may give valid results (still trying to figure out if it is correct) 
%when compared to theoritical analysis.
%The simulation assumes a perfect system. I have kluged this together from
%various programs that I have seen on the internet and hope it may be
%somewhat useful to others to play with. I have provided comments and notes for review. 
clear
%randn('state',0);%keeps bits the same on reruns
nr_data_bits=64000;% 0's and 1's, keep even number-Takes ~1 minute for a run of 1 million
%64000 allows bits and complex values to be shown in array editor
nr_symbols=nr_data_bits/2;
b_data = (randn(1, nr_data_bits) > .5);%random 0's and 1's
b = [b_data];
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
    if (imp==0)&(p==0)
        d(n)=exp(j*pi/4);%45 degrees
    end
    if (imp==1)&(p==0)
        d(n)=exp(j*3*pi/4);%135 degrees
    end
    if (imp==1)&(p==1)
        d(n)=exp(j*5*pi/4);%225 degrees
    end
    if (imp==0)&(p==1)
        d(n)=exp(j*7*pi/4);%315 degrees
    end
end
qpsk=d;
figure(1);
plot(d,'o');%plot constellation without noise
axis([-2 2 -2 2]);
grid on;
xlabel('real'); ylabel('imag');
title('QPSK constellation');

SNR=0:12;
BER1=[];
SNR1=[];
SER=[];
SER1=[];
sigma1=[];

%AWGN(additive white Gaussian noise)
for SNR=0:length(SNR);%loop over SNR
sigma = sqrt(10.0^(-SNR/10.0));
sigma=sigma/2;%Required a division by 2 to get close to exact solutions(Notes)-WHY?
%Is dividing by two(2) legitimate?
sigma1=[sigma1 sigma];
%add noise to QPSK Gray coded signals
snqpsk=(real(qpsk)+sigma.*randn(size(qpsk))) +i.*(imag(qpsk)+sigma*randn(size(qpsk)));

figure(2);
plot(snqpsk,'o'); % plot constellation with noise
axis([-2 2 -2 2]);
grid on;
xlabel('real'); ylabel('imag');
title('QPSK constellation with noise');

%Receiver
r=snqpsk;%received signal plus noise
%Detector-When Gray coding is configured as shown, the detection process
%becomes fairly simple as shown. A system without Gray coding requires a much
%more difficult detection method
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
figure(3);
semilogy(SNR1,BER1,'*',SNR1,SER1,'o');
grid on; 
xlabel('SNR=Eb/No(dB)'); ylabel('BER or SER');
title('Simulation of BER/SER for QPSK with Gray coding');
legend('BER-simulated','SER-simulated');

%Notes: Theoritical QPSK EXACT SOLUTION for several SNR=Eb/No points on BER/SER plot
%Assuming Gray coding
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
%0,1,2,3,4,5,6,8,10,11,12 You do the rest of these and plot if so inclined



        

