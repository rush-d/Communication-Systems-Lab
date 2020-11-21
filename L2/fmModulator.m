function modSig = fmModulator(baseSig, Ac, Fc, freqDev, Fs)
%FMMODULATOR Function for Modulating given Baseband Message Signal using
%Frequency Modulation (FM) Technique
%   Frequency Modulation (FM) Technique Implementation

    %Obtaining the length of input Baseband Message Signal
    sigLen = length(baseSig);
    
    %Creating the Time Vector for Simulation
    tVector = 0:1/Fs:(sigLen-1)/Fs;
    
    %Obtaining the Modulated Signal according the Frequency Modulation
    %Equation
    %Here, cumsum(baseSig) which is Cumulative Summation is actually the
    %Discrete-time equivalent of Integration of Message Signal for
    %Continuous-time
    modSig = Ac*cos(2*pi*Fc*tVector + 2*pi*(freqDev/Fs)*cumsum(baseSig));
end

