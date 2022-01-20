%Readme file for assignment

>>One needs to run only the Main File : LDPC_Main_code.m

The Main file has the following steps:

1. Take input for n,wc,wr to generate the LDPC Code (Matrix H) of order (m x n). Only integer values for m can be used. LDPC_Create_H_function(n,wc,wr)

		Returns H, and Code Rate
		
	-------------------------------------------
2. Create LDPC encoder(two choices)

	Choice 1: LDPC_sys_H_G_encode_function(H)
		1.1 Get a full rank Matrix from H
		1.2 Get the Generator Matrix G of order (k x n), such that m>=n-k
		1.3 Encode a random message sequence of order (1xk)
	
		Returns encoded Codeword.
	
	-------------------------------------------
	
	Choice 2: LDPC_non_full_rank_encode_function(H)
		2.1 If Backward Substitution is chosen, Generator Matrix will not be displayed and Non-Full Rank matrix will be operated for encoding the random message.
	
		Returns encoded Codeword.
	
	-------------------------------------------
	
3. Create Decoder (two choices)
	Choice 1: Use simple Hard Decision Decoder using the Threshold of 0 for the noisy output and rounded off to nearest integer and decode the output.
	    LDPC_HD_decode_function(Y_AWGN,Codeword);
		
		Returns Decoded Codeword and Number of Bits in Error between the Transmitted and Received Codeword
	
	Choice 2: Take input of number of maximum iterations to run the Decoder for (max_iter). LDPC_MP_decode_function(LLR,H,Codeword)
		2.1 Create Edges between the Check nodes and bit nodes for the LDPC Matrix H. 
		2.2 Iterate over the size to compute the priori probability values and update them
		2.3 Break the Loop over when a matching codeword is found or Iteration count crosses 40
	
		Returns Decoded Codeword and Number of Bits in Error between the Transmitted and Received Codeword
	
	-------------------------------------------

>>The above code has been performed for BPSK over AWGN channel with 0 to 4 dB SNR values.
>>To calculate the LLR value for the LDPC Decoder using Message-Passing Algorithm, it was tested that using quantization for the AWGN noise gives slightly better results and have used integer range to quantize the values accordingly.

++To keep the Command Window outputs stored into a file, before running the main code, in the command window, use:
>>diary on
++Run the main code once or several times as needed
>>diary off
++This saves a log file in the current working directory with name "diary"

--------------------------
Results for Example Code:
--------------------------

Enter the number of bits in the codeword (n)=  20
Enter the number of ones in each column (Wc)=  3
Enter the number of ones in each row (Wr) [Wr>Wc]=  4
Below is the required LDPC code of order (15 X 20)
     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
     0     0     0     0     1     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0     1     1     1     1     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1     0     0     0     0
     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1
     0     0     1     0     0     0     0     1     0     1     0     1     0     0     0     0     0     0     0     0
     0     1     0     0     0     1     1     0     0     0     0     0     0     0     0     0     1     0     0     0
     0     0     0     0     0     0     0     0     0     0     1     0     0     1     0     0     0     0     1     1
     0     0     0     0     1     0     0     0     1     0     0     0     1     0     0     1     0     0     0     0
     1     0     0     1     0     0     0     0     0     0     0     0     0     0     1     0     0     1     0     0
     0     1     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0     0     1     0
     0     0     1     0     0     0     0     0     0     0     1     0     0     1     0     0     0     0     0     1
     0     0     0     0     0     1     1     0     1     1     0     0     0     0     0     0     0     0     0     0
     0     0     0     0     0     0     0     0     0     0     0     1     1     0     1     0     1     0     0     0
     1     0     0     0     0     0     0     1     0     0     0     0     0     0     0     1     0     1     0     0

This code has Density: 0.200000
The Code Rate for this H is 0.350000 
Enter 1 to see the Generator Matrix or 2 to encode using Backward Substitution algorithm = 1
Below is the LDPC matrix H in systematic form of order (13 X 20), rank 13 and density of 0.207692
     1     1     0     0     0     0     1     1     0     0     0     0     0     0     0     0     0     0     0     0
     0     0     1     0     0     1     1     0     1     0     0     0     0     0     0     0     0     0     0     0
     0     0     0     0     0     1     0     0     0     1     0     0     0     0     0     0     0     0     0     0
     1     1     1     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0     0     0
     1     1     0     0     0     0     1     0     0     0     0     1     0     0     0     0     0     0     0     0
     0     0     1     1     1     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0
     1     1     1     0     1     0     1     0     0     0     0     0     0     1     0     0     0     0     0     0
     0     1     1     0     1     0     0     0     0     0     0     0     0     0     1     0     0     0     0     0
     1     0     0     0     0     1     1     0     0     0     0     0     0     0     0     1     0     0     0     0
     1     0     1     0     1     1     1     0     0     0     0     0     0     0     0     0     1     0     0     0
     1     0     0     0     1     0     1     0     0     0     0     0     0     0     0     0     0     1     0     0
     0     0     1     0     1     0     1     0     0     0     0     0     0     0     0     0     0     0     1     0
     0     0     0     0     1     1     1     0     0     0     0     0     0     0     0     0     0     0     0     1

Below is the required Generator Matrix G in systematic form of order (7 X 20), rank 7 
     1     0     0     0     0     0     0     1     0     0     1     1     0     1     0     1     1     1     0     0
     0     1     0     0     0     0     0     1     0     0     1     1     0     1     1     0     0     0     0     0
     0     0     1     0     0     0     0     0     1     0     1     0     1     1     1     0     1     0     1     0
     0     0     0     1     0     0     0     0     0     0     0     0     1     0     0     0     0     0     0     0
     0     0     0     0     1     0     0     0     0     0     0     0     1     1     1     0     1     1     1     1
     0     0     0     0     0     1     0     0     1     1     0     0     0     0     0     1     1     0     0     1
     0     0     0     0     0     0     1     1     1     0     0     1     0     1     0     1     1     1     1     1

Random message is 
     0     1     0     1     1     0     1

The encoded Codeword is: 
     0     1     0     1     1     0     1     0     1     0     1     0     0     1     0     1     0     0     0     0

The encoded Codeword after BPSK Modulation is: 
    -1     1    -1     1     1    -1     1    -1     1    -1     1    -1    -1     1    -1     1    -1    -1    -1    -1

Enter 1 to use Normal Hard-Decision and 2 to use Message-Passing Decoding Algorithm = 2
Enter the maximum number of iterations for the Decoder, generally 5 to 8 = 6
The decoded codeword for the given H using the selected choice of Decoding is: 
     0     1     0     1     1     0     0     0     1     0     1     0     0     1     0     1     0     0     0     0

The Codeword sent was:
     0     1     0     1     1     0     1     0     1     0     1     0     0     1     0     1     0     0     0     0

There are 1 bits with error in the Tx and Rx Codewords
>> 