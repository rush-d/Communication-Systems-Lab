%Function to generate DBPSK modulated signal given random binary
%signal/sequence
function outBinSig = DBPSKdemodulator(channelSig)

    %Extracting signal length here
    sigLen = length(channelSig);
    
    %Defining container for demodulated signal
    demodSig = zeros(sigLen, 1);
    
    %Loop for demodulation logic
    for index = 1:sigLen
        
        %Comparing real value of noisy signal to zero (decision)
        if real(channelSig(index)) > 0
            demodSig(index) = 1;
        else
            demodSig(index) = -1;
        end
    end
    
    %Converting polar signal to binary differentially decoded signal
    diffDecSig = 0.5 * (demodSig + 1);
    
    %Performing XNOR operation on differentially decoded signal and its -1
    %delayed version to extract the final output binary signal
    outBinSig = zeros(sigLen - 1, 1);
    for index = 1:sigLen - 1
        outBinSig(index) = not(xor(diffDecSig(index), diffDecSig(index + 1)));
    end
end