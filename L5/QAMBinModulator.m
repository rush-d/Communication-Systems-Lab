function modSig = QAMBinModulator(symSig, M)
%QAMBINMODULATOR Summary of this function goes here
%   Detailed explanation goes here
    rootM = sqrt(M);
    iComp = 2.*floor(symSig./rootM) - rootM + 1;
    qComp = -2.*mod(symSig, rootM) + rootM - 1;
    modSig = iComp + 1i.*qComp;
end

