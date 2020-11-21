function [diffSig, demodSig] = fmDemodulator(modSig, Am)
%FMMODULATOR Function for Demodulating given Modulated Signal using
%Envelope Detection Technique
%   Frequency Demodulation Technique Implementation

    %Obtaining the differentiated version of Modulated Signal and padding
    %the first term with zero value to counter any initial uninitialised
    %error values
    diffSig = [0 diff(modSig)];
    
    %Envelope Estimation of Differentiated Modulated Signal using Hilbert
    %Tranform operation
    intermediateSig = abs(hilbert(diffSig));
    
    %Calculating the average signal value wrt Max and Min peaks
    avgSigVal = (max(intermediateSig)+min(intermediateSig))/2;
    
    %Subtracting average signal value to remove the DC Component
    intermediateSig = intermediateSig - avgSigVal;
    
    %Calculating the scaling factor for Intermediate Signal Amplitude wrt to given Message Signal
    %Amplitude
    scaleFactor = (abs(max(intermediateSig))+abs(min(intermediateSig)))/2;
    
    %Applying the Scaling Factor
    demodSig = Am*intermediateSig/scaleFactor;
end

