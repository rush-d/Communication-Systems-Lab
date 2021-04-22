function demodSig = QAMGrayDemodulator(channelSig, M)
%QAMBINDEMODULATOR Summary of this function goes here
%   Detailed explanation goes here
    %Array of all symbols
    symbolSpace = 0:M-1;
    
    %Array of modulated signals acording to gray coding
    modSymbolSpace = QAMGrayModulator(symbolSpace, M);
    
    %Extracing the symbolic signal length
    symSigLen = length(channelSig);
    
    %Demodulated signal container
    demodSig = zeros(symSigLen, 1);
    
    %Demodulating the each symbol
    for index = 1:symSigLen
        
        %Mapping to the symbol with minimum euclidean distance
        [symIndex, demodSig(index)] = min(abs(channelSig(index) - modSymbolSpace));
    end
    
    %Finally calculating the demodulated signal
    demodSig = demodSig - 1;
end

