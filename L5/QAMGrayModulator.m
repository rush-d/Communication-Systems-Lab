function modSig = QAMGrayModulator(symSig, M)
%QAMBINMODULATOR Summary of this function goes here
%   Detailed explanation goes here

    %Copy of the input symbolic signal
    symSigG = symSig;
    
    %Changing the symbols to map according to gray coding
    for index = 1:length(symSigG)
        currentSym = symSigG(index);
        switch currentSym
            case 2
                currentSym = 3;
            case 3
                currentSym = 2;
            case 6
                currentSym = 7;
            case 7
                currentSym = 6;
            case 8
                currentSym = 12;
            case 9
                currentSym = 13;
            case 10
                currentSym = 15;
            case 11
                currentSym = 14;
            case 12
                currentSym = 8;
            case 13
                currentSym = 9;
            case 14
                currentSym = 11;
            case 15
                currentSym = 10;
        end
        %Changing the symbol at index here
        symSigG(index) = currentSym;
    end
    
    %then we can apply Binary coding QAM modulator function to obtain the
    %gray coded modulated signal
    modSig = QAMBinModulator(symSigG, M);
end

