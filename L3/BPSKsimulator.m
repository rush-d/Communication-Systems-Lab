function SimBER = BPSKsimulator(SNRdB, nBits, nIter)
%BPSKSIMULATOR This function can be used to perform Theoretical and
%Simulated BER Comparison in AWGN Channel
%   Inputs
    %SNRdB : SNR values array (dB)
    %nBits : Number of bits in Message Signal
    %nIter : Number of iterations of experiment for each SNR value
    
%Outputs
    %SimBER : Simulated BER experiment values
    
    %Initialising SimBER array with size same as SNRdB array
    SimBER = zeros(length(SNRdB), 1);

    %Loop for varying SNR values
    for index = 1:length(SNRdB)
        
        %Total number of error bits for all iterations for each SNR value
        totalErrorBits = 0;
        
        %Loop for iterations with single SNR Value
        for iter = 1:nIter
            
            %Generating Binary Message Signal with size nBits
            msgSig = randi([0 1], nBits, 1);
            
            %Converting to Polar Message Signal
            modSig = 2 * msgSig - 1;
            
            %Calculating Noise Amplitude corresponding to SNR value
            noiseAmp = 1/(10^(SNRdB(index)/10));
            
            %Adding noise to Modulated Signal
            channelSig = modSig + sqrt(noiseAmp/2)*(randn(nBits, 1)) + 1i*sqrt(noiseAmp/2)*(randn(nBits, 1));
            
            %Initialising Demodulated Signal container
            demodSig = zeros(nBits, 1);
            
            %Demodulation of Noisy signal at Receiver
            
            %Magnitude greater than zero are mapped to 1
            demodSig(channelSig > 0) = 1;
            
            %Magnitude smaller than zero are mapped to 0
            demodSig(channelSig < 0) = 0;
            
            %Calculating the signal difference for BER calculation
            diffSig = msgSig - demodSig;
            
            %Calculating Total Error Bits from each experiment
            totalErrorBits = totalErrorBits + sum(abs(diffSig));
        end
        
        %Saving calculated BER to SimBER array for current SNR value
        SimBER(index) = totalErrorBits/(nIter*nBits);
    end
end

