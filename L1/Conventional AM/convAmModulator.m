function modSig = convAmModulator(baseSig, Ac, Fc, Fs)
%CONVAMMODULATOR Function for Modulating Baseband Message Signal according
%to Conventional AM Technique
%   Conventional AM Implementation

    %Calculating the length of the Message Signal
    sigLen = length(baseSig);
    
    %Creating the Time Vector for Simulation
    timeVector = 0:1/Fs:(sigLen-1)/Fs;
    
    %Applying the Conventional AM equation on Message Signal
    modSig = (Ac + baseSig).*cos(2*pi*Fc*timeVector);
end

