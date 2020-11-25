%QPSK Simulation for BER Calculation wrt Non-Gray Coding of Symbols

%Defining the number of symbols to be sent for simulation
nSymbols = 1000000;

%Calculating the number of bits accordingly
nBits = 2 * nSymbols;
%%
%Defining the SNR Values
SNRdB = 0:1:10;
%%
%Simulation with custom created qpskNonGraySimulator function
qpskNonGraySimulator(nSymbols, SNRdB);
%%
%Plotting the original symbols and Non-Gray Coding Map of symbols
figure(length(SNRdB)+2);
scatter(polarSymbolSpaceI, polarSymbolSpaceQ, 'red', "filled");
text(polarSymbolSpaceI(1), polarSymbolSpaceQ(1), '00');
text(polarSymbolSpaceI(2), polarSymbolSpaceQ(2), '11');
text(polarSymbolSpaceI(3), polarSymbolSpaceQ(3), '10');
text(polarSymbolSpaceI(4), polarSymbolSpaceQ(4), '01');
plotTitle = strcat('Constellation with original symbols wrt Non-Gray Coding');
title(plotTitle);
xlabel('I Component');
ylabel('Q Component');