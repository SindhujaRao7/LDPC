function [Y,LLR] = BPSK_AWGN_Channel_function(C,R)

%BPSK MODULATION

Sn=C; % Copy the Codeword to create BPSK Signal 
n=size(C,2);
for i =1:n
    Sn(i)=(2*Sn(i))-1;  
end
fprintf('The encoded Codeword after BPSK Modulation is: \n');
disp(Sn)

%Add AWGN noise and store variance for LLR for Decoder


dB=[0:4];                           % range of SNR values in dB that have found to be optimum range 
SNRpbit=10.^(dB/10);                % Taking Eb =1
No_org=1./SNRpbit;             
No=No_org./R;       %Calculate Variance using the Rate of H


for z=1:length(SNRpbit) % loop for testing over range of SNR values  % assumed that the receiver knows sigma for AWGN
        sigma=sqrt(No(z)/2);
        Y=Sn + sigma*randn(1,length(Sn));
end

%fprintf('The encoded Codeword after BPSK Modulation on AWGN channel is: \n');
%disp(Y)

z=length(SNRpbit);

%Quantizing the Received signal within integer values.

Y_max = 4; %Range of AWGN value per bit doesn't go over 4 per bit
%converting between -31 to +31
max_int_limit = 31; 
Y_Quant = floor(Y/Y_max*max_int_limit);
Y_Quant(Y_Quant>max_int_limit) = max_int_limit;
Y_Quant(Y_Quant<-(max_int_limit+1)) = -(max_int_limit+1);

LLR=(4/No(z))*Y_Quant;  %Creating Intial LLR Value for the Decoder, since LLR=(2/sigma^2)*Y_Quant

end