function modSig = dsbModulator(baseSig, Ac, Fc, Fs)
%DSBMODULATOR Function for Modulating Baseband Message Signal according
%to DSB-SC AM Technique
%   DSB-SC AM Implementation

    %Calculating the length of the Message Signal
    sigLen = length(baseSig);
    
    %Creating the Time Vector for Simulation
    timeVector = 0:1/Fs:(sigLen-1)/Fs;
    
    %Generating Carrier Signal according to given Carrier Frequency
    carSig = Ac*cos(2*pi*Fc*timeVector);
    
    %Applying the DSB-SC AM equation on Message Signal
    modSig = carSig.*baseSig;
end