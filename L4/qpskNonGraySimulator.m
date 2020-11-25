function qpskGraySimulator(nSymbols, SNRdB)
%QPSKNONGRAYSIMULATOR Used for QPSK Simulation and BER Calculation wrt to Non-Gray
%Coding
%   Calculating the number of bits according to the number of symbols
    nBits = 2*nSymbols;

    %Calculating the Linear SNR values according to the input SNR dB values
    SNR = 10.^(SNRdB/10);
    
    %Calculating the noise values according to SNR values
    noiseAmp = 1./SNR;
    
    %Data below is defined for symbols in the order [0, 1, 2, 3]

    %Defining the first bit for symbols
    symbolSpaceI = [1 1 0 0];

    %Calculating the I Component in Polar Value
    polarSymbolSpaceI = 2 * symbolSpaceI - 1;

    %Defining the second bit for symbols
    symbolSpaceQ = [1 0 0 1];

    %Calculating the Q Component in Polar Value
    polarSymbolSpaceQ = 2 * symbolSpaceQ - 1;

    %Establising symbols in Complex Form using above calculated I and Q
    %component values
    polarSymbolSpace = polarSymbolSpaceI + exp(1i*pi/2) * polarSymbolSpaceQ;

    %Normalising the QPSK Power to unity
    polarSymbolSpace = polarSymbolSpace/sqrt(2);

    %Calculating theoretical BER values according to SNR values
    ThBER = 0.5*erfc(sqrt(SNR));

    %Initialising the simulated SNR values container
    SimBER = zeros(1, length(SNRdB));

    %Initialising containers for I and Q components for demodulated Signal
    %outputs
    demodSigI = zeros(nSymbols, 1);
    demodSigQ = zeros(nSymbols, 1);
    demodBinSig = zeros(1, nBits);
    %Container for demodulated polar signal
    demodSymbolSig = zeros(1, nSymbols);

    %Loop for running simulation according to the number of symbols to be
    %sent
    for i = 1:length(noiseAmp)

        %Generating random binary array from the 2 at a time bits will be
        %taken for symbol consideration
        uncodedBinMsgSig = randi([0 1], nBits, 1);
        
        %Converting generated binary array to polar form
        uncodedPolarMsgSig = 2 * uncodedBinMsgSig - 1;

        %Extracting out the odd placed bits to be the I components
        modSigI = uncodedPolarMsgSig(1:2:end);
        
        %Extracting out the odd placed bits to be the Q components
        modSigQ = uncodedPolarMsgSig(2:2:end);
        
        %Generating the polar message signal according to above extracted I
        %and Q values
        symbolMsgSig = modSigI + exp(1i*pi/2) * modSigQ;

        %Adding noise to the I and Q components wrt AWGN channel
        channelSigI = modSigI + sqrt(noiseAmp(i)/2)*randn(nSymbols, 1);
        channelSigQ = modSigQ + sqrt(noiseAmp(i)/2)*randn(nSymbols, 1);
        
        %Generating polar noisy signal from above calculated I and Q
        %components
        channelSig = channelSigI + exp(1i*pi/2) * channelSigQ;

        %Demodulation Logic for I component
        demodSigI(channelSigI > 0) = 1;
        demodSigI(channelSigI < 0) = 0;

        %Demodulation logic for Q component
        demodSigQ(channelSigQ > 0) = 1;
        demodSigQ(channelSigQ < 0) = 0;
        
        %Here the mapping happens as [1+1i, -1+1i, 1-1i, -1-1i] -> [00, 01,
        %10, 11] -> [0, 1, 2, 3] respectively (Non-Gray Coding)

        %Generating the demodulated signal wrt to above calculated I and Q
        %components
        demodSymbolSig = (demodSigI + exp(1i*pi/2) * demodSigQ)/sqrt(2);

        %Generating the Binary stream according to above calculated
        %demodulated signal
        for j = 1:nSymbols
            demodBinSig(2*j-1) = demodSigI(j);
            demodBinSig(2*j) = demodSigQ(j);
        end

        %Calculating the difference signal for BER Calculation
        diffSig = transpose(demodBinSig) - uncodedBinMsgSig;

        %Assiging simulated BER values by summing up total wrong bits
        %divided by total bits transmitted
        SimBER(i) = sum(abs(diffSig))/nBits;

        %Plotting Constellation diagrams of symbols for various SNR values
        figure(i);
        scatter(channelSigI, channelSigQ, 'blue');
        hold on;
        scatter(polarSymbolSpaceI, polarSymbolSpaceQ, 'red', "filled");
        text(polarSymbolSpaceI(1), polarSymbolSpaceQ(1), '00');
        text(polarSymbolSpaceI(2), polarSymbolSpaceQ(2), '11');
        text(polarSymbolSpaceI(3), polarSymbolSpaceQ(3), '10');
        text(polarSymbolSpaceI(4), polarSymbolSpaceQ(4), '01');
        hold off;
        plotTitle = strcat('Constellation with original and erroneous symbols for SNR value = ', num2str(SNRdB(i)), ' dB');
        title(plotTitle);
        xlabel('I Component');
        ylabel('Q Component');
    end
    
    %Plotting Simulated BER and Theoretical BER plots in semilog manner
    figure(i+1);
    semilogy(SNRdB, SimBER, '*r');
    hold on;
    semilogy(SNRdB, ThBER, 'blue');
    hold off;
    title('BER vs SNR Plot');
    xlabel('SNR Value (dB)');
    ylabel('BER Value (Logarithmic Scale)');
    legend('Simulated', 'Theoretical');
end

