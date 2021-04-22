%Function to calculate DQPSK Demodulated signal given noisy signal and
%symbol Space
function outBinSig = DQPSKdemodulator(channelSig, symbolSpace)

    %Number of allowed symbols
    M = 4;
    %Calculating number of symbols
    nSymbols = length(channelSig) - 1;
    %Calculating number of bits
    nBits = 2 * nSymbols;

    %Defining containers for demodulated I and Q components
    demodSigI = zeros(nSymbols + 1, 1);
    demodSigQ = zeros(nSymbols + 1, 1);
    
    %Loop for symbol estimation wrt euclidean distance
    for index = 1:nSymbols + 1
        distVector = zeros(M, 1);
        for symIndex = 1:M
            distVector(symIndex) = norm(symbolSpace(symIndex) - channelSig(index));
        end
        [~, minIndex] = min(distVector);
        %According to gray labelling, storing finally demodulated values
        demodSigI(index) = -real(symbolSpace(minIndex));
        demodSigQ(index) = -imag(symbolSpace(minIndex));
    end
    
    %Converting polar demodulated I and Q signals to binary
    diffDecSigI = 0.5*(demodSigI + 1);
    diffDecSigQ = 0.5*(demodSigQ + 1);
    
    %Defining container for final demodulated signal
    outBinSig = zeros(nBits, 1);
    
    %Loop for calculating final demodulated signal using XNOR operation
    %shifted and original I and Q components respectively to generate
    %estimated binary sequence
    for index = 1:nSymbols
        outBinSig(2*index - 1) = not(xor(diffDecSigI(index), diffDecSigI(index + 1)));
        outBinSig(2*index) = not(xor(diffDecSigQ(index), diffDecSigQ(index + 1)));
    end

end