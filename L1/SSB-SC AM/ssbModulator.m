function modSig = ssbModulator(baseSig, Am, Fm, Ac, Fc, Fs)
%SSBMODULATOR Function for Modulating Baseband Message Signal according
%to SSB-SC AM Technique
%   SSB-SC AM Implementation

    %Calculating the length of the Message Signal
    sigLen = length(baseSig);
    
    %Creating the Time Vector for Simulation
    tVector = 0:1/Fs:(sigLen-1)/Fs;
    
    %Here, using only the Lower Sideband of the DSB Signal
    %Since the Carrier is suppressed
    %So the Modulated Signal equation reduces to the follwing
    %Therefore, generating the SSB-SC Modulated Signal for given Baseband
    %Message Signal
    modSig = (Am*Ac/2)*cos(2*pi*(Fc-Fm)*tVector);
end