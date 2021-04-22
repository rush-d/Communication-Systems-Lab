%Function to generate DQPSK Modulated signal given input binary signal
function modSig = DQPSKmodulator(inBinSig)

    %Exatracting out number of symbols in signal
    nSymbols = length(inBinSig)/2;

    %Separating out I and Q components out of the input bitstream
    inSymSigI = inBinSig(1:2:end);
    inSymSigQ = inBinSig(2:2:end);
    
    %Differentially encoding I bitstream
    diffEnSigI = zeros(nSymbols + 1, 1);
    %Setting up first bit as random
    diffEnSigI(1) = randi([0 1], 1, 1);
    
    %Differentially encoding Q bitstream
    diffEnSigQ = zeros(nSymbols + 1, 1);
    %Setting up first bit as random
    diffEnSigQ(1) = randi([0 1], 1, 1);
    
    %Loop for XNOR operation on shifted and original differentially encoded
    %I and Q bitstreams
    for index = 1:nSymbols
        diffEnSigI(index + 1) = not(xor(diffEnSigI(index), inSymSigI(index)));
        diffEnSigQ(index + 1) = not(xor(diffEnSigQ(index), inSymSigQ(index)));
    end
    
    %Generating modulated I and Q components (Polar)
    modSigI = 2*diffEnSigI - 1;
    modSigQ = 2*diffEnSigQ - 1;
    
    %Finally generating modulated signal
    modSig = -(modSigI + 1i*modSigQ);
end