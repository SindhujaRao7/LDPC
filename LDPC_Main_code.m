%Main file to run LDPC

clc; 
clear all;

n = input('Enter the number of bits in the codeword (n)=  '); % Length of the code
wc = input('Enter the number of ones in each column (Wc)=  '); % Number of 1s in each column
wr = input('Enter the number of ones in each row (Wr) [Wr>Wc]=  '); % Number of 1s in each row (Wc<Wr)

[H,Rate] = LDPC_Create_H_function(n,wc,wr);

%Ask Choice for Encoding Method

encode_choice = input('Enter 1 to see the Generator Matrix or 2 to encode using Backward Substitution algorithm = ');
switch encode_choice
    case 1
        [Codeword]=LDPC_sys_H_G_encode_function(H);
    case 2
        [Codeword]=LDPC_non_full_rank_encode_function(H);
    otherwise
        disp('Wrong input! Run the Program again\n');      
end

[Y_AWGN,LLR] = BPSK_AWGN_Channel_function(Codeword,Rate);


Decode_choice = input('Enter 1 to use Normal Hard-Decision and 2 to use Message-Passing Decoding Algorithm = ');
switch Decode_choice
    case 1
        [Decoded_Codeword,Code_Errors_count] = LDPC_HD_decode_function(Y_AWGN,Codeword);
    case 2
        [Decoded_Codeword,Code_Errors_count] = LDPC_MP_decode_function(LLR,H,Codeword);
    otherwise
        disp('Wrong input! Run the Program again\n');      
end


fprintf('The decoded codeword for the given H using the selected choice of Decoding is: \n');
disp(Decoded_Codeword)
fprintf('The Codeword sent was:\n');
disp(Codeword)
fprintf('There are %d bits with error in the Tx and Rx Codewords\n', Code_Errors_count);

%End of the Program