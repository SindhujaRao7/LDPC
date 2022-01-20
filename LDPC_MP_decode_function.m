function [cw_new,Code_Errors_count] = LDPC_MP_decode_function(LLR,H,C)


max_iter = input('Enter the maximum number of iterations for the Decoder, generally 5 to 8 = '); % Run the decoder for max_inter iterations

[M,N] = size(H); %Get original size of H back
Lcj = LLR(1:N);  %Use the first LLR for 
%priori probabilities
pn0=1./(1+exp(Lcj)); 
pn1=1-pn0; %For BPSK

% Initialization
dv=max(sum(H)); 
dc=max(sum(H.')); 
Nm=zeros(M,dc); 
Mn=zeros(dv,N);
for i=1:M
   index = 1; 
   for j=1:N
      if H(i,j)==1
        Nm(i,index)=j; 
		index =index+1; 
		qij0(i,j)=pn0(j); 
		qij1(i,j)=pn1(j); 
      end
   end
end
for j=1:N
   temp = find(H(:,j)); 
   lt=length(temp); 
   if lt>0 
   Mn(1:lt,j)=temp; 
   end
end
for iter=1:max_iter   %Run till max_iter
	%Loop through Check Nodes
   for i=1:M 
      NNm = sum(Nm(i,:)~=0);
      for j0=1:NNm
	  j=Nm(i,j0); 
	  dqij(i,j0)=qij0(i,j)-qij1(i,j);  
	  end
      for j0=1:NNm
         j = Nm(i,j0); 
		 drij=1; 
		 temp0=1; 
		 temp1=1;
         for k=1:NNm  
			 if k~=j0
			 drij=drij*dqij(i,k);  %Column Products
			 end  
		 end
         rij0(i,j)=(1+drij)/2; 
		 rij1(i,j)=1-rij0(i,j); 
      end
   end 
   %Loop through Bit Nodes
   for j=1:N 
      NMn = sum(Mn(:,j)~=0); 
      for i0=1:NMn
         i = Mn(i0,j); 
		 pn0_prod_rij0=pn0(j); 
		 pn1_prod_rij1=pn1(j);
         for k=1:NMn
            if k~=i0
              pn0_prod_rij0 = pn0_prod_rij0*rij0(i,j);   %Row Products
              pn1_prod_rij1 = pn1_prod_rij1*rij1(i,j);
            end
         end 
         aij=1/(pn0_prod_rij0+pn1_prod_rij1);   
         qij0(i,j)=aij*pn0_prod_rij0; 
         qij1(i,j)=1-qij0(i,j);  
      end
      %Updating posterior Probabilities and Calculating CodeWord
      pn0_prod_all_rij0 = pn0_prod_rij0*rij0(i,j);
      pn1_prod_all_rij1 = pn1_prod_rij1*rij1(i,j);
      a_j=1/(pn0_prod_all_rij0+pn1_prod_all_rij1);
      qj1(j) = a_j*pn1_prod_all_rij1; 
      cw_new(j)= qj1(j)>0.5;    
   end 
   if sum(rem(cw_new*H.',2))==0 || (iter>30 && cw_new==cw_new_temp)    %Stop when codeword matches 
       break; 
   end
   cw_new_temp = cw_new;
end 
cw_new=(mod(cw_new,2));

    Code_Errors_count=0;

       Code_Errors=zeros(1,length(cw_new));
        Code_Errors(C~=cw_new)=1;
        
        if Code_Errors(C~=cw_new)~=1
            Code_Errors_count=0;
        end
      
        if sum(Code_Errors)~=0
            Code_Errors_count=sum(Code_Errors);         
        end
       
% Count the error bits in codewords sent and received
end