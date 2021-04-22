% Mohammad Ismail Hossain 
% Jacobs University Bremen


%% Q1: Simulate BER for QPSK in Maltlab and compare the results with the theoretical value.
%% Q2: Compute the BER expression using the naive code [00, 01,10, 11]. 
%%     Simulate, and compare the results with that from Gray code.

%%%%  Solution %%%%%%%
clc;
close all;
clear all;

N = 10^5;                                       % Number of bits or symbols
E_s = 1;                                        % Symbol Energy
E_b = E_s / 2;                                  % Bit Energy
E_n_dB = -2:1:10;                               % SNR range in dB
E_n_ln = (10.^(E_n_dB / 10));                   % SNR range in linear
Bit_error_gray=zeros(size(E_n_ln));             % BER for Gray 
Bit_error_gray_theory=zeros(size(E_n_ln));      % BER for Gray Theory 
Bit_error_Naive=zeros(size(E_n_ln));            % BER for Naive
Bit_error_gray_theory=0.5*erfc(sqrt(E_n_ln)/sqrt(2));   % BER for Gray thoery 
Bit_error_Naive_theory=1.5*(0.5*erfc(sqrt(E_n_ln)/sqrt(2))); % BER for Naive thoery 
Q_s=(1/sqrt(2))*[1+1j,-1+1j,-1-1j,1-1j];         %QPSK Symbols Constellation 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Loop Begins %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(E_n_ln)
    N_errors_gray=0;                              % Error Counter for Gray 
    N_errors_Naive=0;                             % Error Counter for Naive
    
    for j=1:N
        N_0=(1/sqrt(2))*(randn(1)+1j*randn(1));   % Noise Generation 
        symbols = [0 1 2 3];
        rndIndex = randi(4, 100);
        T_s = zeros(1, 100);
        for ind = 1:100
            T_s(ind) = Q_s(rndIndex(ind));
        end
        %T_s=Q_s[r_n];                             % Transmit symbols 
        R_s=sqrt(E_n_ln(i))*T_s+N_0;              % receive symbols with noise
        
        %%%%%%% Errors Computation for Gray Code (00 01 11 10) %%%%%%%%%
        if sign(real(T_s))==sign(real(R_s)) && sign(imag(T_s))==sign(imag(R_s))
            N_errors_gray=N_errors_gray+0;
        elseif sign(real(T_s))==sign(real(R_s)) && sign(imag(T_s))~=sign(imag(R_s))
            N_errors_gray=N_errors_gray+1;
        elseif sign(real(T_s))~=sign(real(R_s)) && sign(imag(T_s))==sign(imag(R_s))
            N_errors_gray=N_errors_gray+1;
        else
            N_errors_gray=N_errors_gray+2;
        end
        %%%%%%% Errors Computation for Naive Code (00 01 10 11) %%%%%%%%%
        if sign(real(T_s))==sign(real(R_s)) && sign(imag(T_s))==sign(imag(R_s))
            N_errors_Naive=N_errors_Naive+0;
        elseif sign(real(T_s))~=sign(real(R_s)) && sign(imag(T_s))~=sign(imag(R_s))
            N_errors_Naive=N_errors_Naive+1;
        elseif sign(real(T_s))~=sign(real(R_s)) && sign(imag(T_s))==sign(imag(R_s))
            N_errors_Naive=N_errors_Naive+1;
        else
            N_errors_Naive=N_errors_Naive+2;
        end
        
    end   
    %%%%%%%%%%%%  Bit Errors calculations  %%%%%%%%%%%%%%%%%%%%
    Bit_error_gray(i)=N_errors_gray/(2*N);        %  BER for Gray
    Bit_error_Naive(i)=N_errors_Naive/(2*N);      %  BER for Naive
end        

%%%%%%%%%%%%%%% Plotting for Gray  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
semilogy(E_n_dB,Bit_error_gray,'ob','linewidth',2)
hold on
semilogy(E_n_dB,Bit_error_gray_theory,'-r','linewidth',2)
legend('Simulated BER (Gray)', 'Theoretical BER (Gray)');
grid on
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('SNR Vs BER plot for QPSK Modualtion');
%%%%%%%%%%%%%%% Plotting for Naive  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
semilogy(E_n_dB,Bit_error_Naive,'*b','linewidth',2)
hold on
semilogy(E_n_dB,Bit_error_Naive_theory,'-r','linewidth',2);
legend('Simulated BER (Naive)', 'Theoretical BER (Naive)');
grid on
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('SNR Vs BER plot for QPSK Modualtion');
%%%%%%%%%%%%%%% Plotting for both Gray and Naive  %%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
semilogy(E_n_dB,Bit_error_gray,'ob','linewidth',2)
hold on
semilogy(E_n_dB,Bit_error_gray_theory,'-r','linewidth',2)
hold on
semilogy(E_n_dB,Bit_error_Naive,'*m','linewidth',2)
hold on
semilogy(E_n_dB,Bit_error_Naive_theory,'-k','linewidth',2)
legend('Simulated BER (gray)', 'Theoretical BER (gray)','Simulated BER (Naive)', 'Theoretical BER (Naive)');
grid on
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('SNR Vs BER plot for QPSK Modualtion');

    