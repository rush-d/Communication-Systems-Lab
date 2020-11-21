function demodSig = convAmDemodulator(modSig, Am, Fm, Ac, Fc, Fs)
%CONVAMDEMODULATOR Function for Demodulating to Baseband Message Signal according
%to Conventional AM Demodulation Technique
%   Conventional AM Demodulation Implementation

    %Calculating Message Signal length
    sigLen = length(modSig);
    
    %Setting up Time Vector for Simulation
    timeVector = 0:1/Fs:(sigLen-1)/Fs;
    
    %Carrier Signal Generation according to the given Carrier Frequency
    carSig = Ac*cos(2*pi*Fc*timeVector);
    
    %Multiplying Modulated Signal with Carrier Signal to compute
    %intermediate signal
    intermediateSig = modSig.*carSig;
    
    %Intermediate Signal FFT Computation
    intermediateSigFFT = fftshift(fft(intermediateSig));
    
    %Suppressing the Frequency Response of Carrier Signal in Intermediate
    %Signal FFT Array
    intermediateSigFFT(ceil(sigLen/2)) = 0;
    
    %Obtaining Intermediate Signal with Suppressed Carrier
    intermediateSig = ifft(ifftshift(intermediateSigFFT));
    
    %Setting up Lowpass Butterworth Filter Parameters with cutoff frequency
    %of (Fm+1) Hz
    [b, a] = butter(2, (2*(Fm+1))/Fs, "low");
    
    %Filtering Intermediate Signal with the created Lowpass Butterworth
    %filter
    intermediateSig = filter(b, a, intermediateSig);
    
    %Calculating the average signal value wrt Max and Min peaks
    avgSigVal = (max(real(intermediateSig))+min(real(intermediateSig)))/2;
    
    %Subtracting average signal value to remove the DC Component
    intermediateSig = intermediateSig - avgSigVal;
    
    %Calculating the scaling factor for Intermediate Signal Amplitude wrt to given Message Signal
    %Amplitude
    scaleFactor = max([abs(max(real(intermediateSig))), abs(min(real(intermediateSig)))]);
    
    %Applying the Scaling Factor
    demodSig = Am*intermediateSig/scaleFactor;
end