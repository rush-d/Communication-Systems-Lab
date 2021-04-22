function demodSig = QAMBinDemodulator(channelSig, M)
%QAMGRAYDEMODULATOR Summary of this function goes here
%   Detailed explanation goes here

    %Demodulating wrt to gray coding
    demodSig = QAMGrayDemodulator(channelSig, M);
    
    %Changing the mapping accordinf to the differences in gray mapping and
    %binary mapping
    for index = 1:length(demodSig)
        currentSym = demodSig(index);
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
        %Changin the current symbol here
        demodSig(index) = currentSym;
    end
end

