%Function to generate DBPSK modulated signal given random binary
%signal/sequence
function modSig = DBPSKmodulator(inBinSig)

    %Extracting signal length here
    sigLen = length(inBinSig);
    
    %Defining container for differentially encoded signal
    diffEncSig = zeros(sigLen + 1, 1);
    
    %Randomly generating the first bit of the differentially encoded signal
    diffEncSig(1) = randi([0 1], 1, 1);
    
    %Loop for XNOR operation of -1 delayed differentially encoded signal and input binary signal 
    for index = 1:sigLen
        diffEncSig(index + 1) = not(xor(diffEncSig(index), inBinSig(index)));
    end
    %
    %Converting binary signal to polar signal
    modSig = 2 * diffEncSig - 1;
end