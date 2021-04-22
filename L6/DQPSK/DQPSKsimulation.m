%Setting up number of bits to send in each iteration
nBits = 1000000;

%Total number of allowed symbols
M = 4;

%Calculating symbol size in terms of bits
symSize = log2(M);

%Calculating number of symbols to send
nSymbols = nBits/symSize;
%%
%Setting up SNR values and related parameters
SNRdB = 1:10;
nSNR = length(SNRdB);
SNR = 10.^(SNRdB/10);
noiseAmp = 1./SNR;
sigma = sqrt(noiseAmp/2);
%%
%Generating array of allowed symbols and their coded representations
symbolSpace = [(1+1i) (1-1i) (-1+1i) (-1-1i)];
symBinRepresentation = ['00'; '01'; '10'; '11'];
%%
%Calculating Theoretical BER and defining empty container for Simulation
%BER array
a = sqrt(2*SNR*(1-sqrt(1/2)));
b = sqrt(2*SNR*(1+sqrt(1/2)));
ThBER = marcumq(a,b) - 0.5.*besseli(0,a.*b).*exp(-0.5*(a.^2 + b.^2));
SimBER = zeros(nSNR, 1);
%%
%Loop for simulation
for SNRindex = 1:nSNR
    
    %Generating random binary signal
    inBinSig = randi([0 1], nBits, 1);
    
    %Obtaining modulated signal
    modSig = DQPSKmodulator(inBinSig);
    
    %Adding AWGN noise to modulated signal
    channelSig = modSig + sigma(SNRindex)*(randn(nSymbols + 1, 1) + 1i*randn(nSymbols + 1, 1));
    
    %Plotting constellation diagrams
    figure(SNRindex);
    scatter(real(channelSig), imag(channelSig), 'b.');
    hold on;
    scatter(real(symbolSpace), imag(symbolSpace), 'red', 'filled');
    for symIndex = 1:M
        text(real(symbolSpace(symIndex)), imag(symbolSpace(symIndex)), symBinRepresentation(symIndex, :));
    end
    hold off;
        xlabel('In-Phase Component');
    ylabel('Quadrature Component');
    plotTitle = strcat('Constellation with original and erroneous symbols for SNR value =', num2str(SNRdB(SNRindex)), ' dB');
    title(plotTitle);
    axis equal;
    
    %Calculating demodulated final binary signal
    outBinSig = DQPSKdemodulator(channelSig, symbolSpace);
    
    %Calculating BER for simulation wrt each iteration
    SimBER(SNRindex) = sum(inBinSig ~= outBinSig)/nBits;
    
end
%%
%Plotting Simulation and Theoretical BER values
figure(SNRindex+1);
semilogy(SNRdB, ThBER, 'blue');
hold on;
semilogy(SNRdB, SimBER, 'red');
hold off;
xlabel('SNR Value (dB) (Eb/No)');
ylabel('Bit Error Rate (BER)');
legend('Theoretical BER - DQPSK', 'Simulation BER - DQPSK');