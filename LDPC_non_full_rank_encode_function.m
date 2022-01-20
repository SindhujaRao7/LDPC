function [C]= LDPC_non_full_rank_encode_function(H)

[m,n]=size(H);
msg_tx = round(rand(1,(n-(rank(H)))));       % Random input sequence
%msg_tx = round(rand(1,(n-m)));       %This will not work since this is not full rank
fprintf('Random message is \n');
disp(msg_tx)

%H = H(any(H,2),:);
%Get  H = [A T]  into submatrix A and T
A = []; T = []; swap = [];
index1 = 0;
%Work with Submatrix A
for j = n-m+1:n
  if (H(1,j)==1 && j==n-m+1)
    index1 = 1;
    break; 
  elseif (H(1,j)==1 && j>n-m+1)
        index1 = 1;
        H(:,[n-m+1,j]) = H(:,[j,n-m+1]); 
        swap = [swap; n-m+1 j];          
        break;
   end
end 
%Work with Submatrix T
for j = 1:n-m
      if (H(1,j)==1 && index1 == 0) 
        H(:,[j,n-m+1]) = H(:,[n-m+1,j]); 
        index1 = 1;
        swap = [swap; j n-m+1];          
        break; 
      end
end
%Check for rows with 1 in particular column and Add them
for i = 1:m
  j = n-m+i;
    if i==1
      indexOnes = find(H(:,j)==1);
      for iOnes = 1:length(indexOnes)
        if (indexOnes(iOnes)>=i+1)
          H(indexOnes(iOnes),:) = mod(H(indexOnes(iOnes),:) + H(i,:),2);
        end
      end
        %As a result, rows with all 0s can be moved to bottom
         index_zeros = find(all(H==0,2)); %Index of all zero rows.
         if(length(index_zeros)>=1)
           H(index_zeros,:)=[];
           H = [H; zeros(length(index_zeros),n)]; %Remove the 0 rows, similar to removig dependent rows in other method.
         end     
     else         
    %Repeat 
        index2 = 0;
        for j2 = n-m+i:n
          if (H(i,j2)==1 && j2==n-m+i)
            index2 = 1;
            break; 
          elseif (H(i,j2)==1 && j2>n-m+i)
                index2 = 1;
                H(:,[n-m+i,j2]) = H(:,[j2,n-m+i]); 
                swap = [swap; n-m+i j2];          
                break;
          end
          end 
        for j2 = 1:n-m
              if (H(i,j2)==1 && index2 == 0) 
                H(:,[j2,n-m+i]) = H(:,[n-m+i,j2]); 
                index2 = 1;
                swap = [swap; j2 n-m+i];         
                break; 
              end
        end
        indexOnes = find(H(:,j)==1);

          for iOnes = 1:length(indexOnes)%Addition of rows of the matrix that have 1 in a specific column 
            if (indexOnes(iOnes)>=i+1)
              H(indexOnes(iOnes),:) = mod(H(indexOnes(iOnes),:) + H(i,:),2);
            end
            end
     %Move the all zero rows to the end of H********%%
         index_zeros = find(all(H==0,2)); %Index of all zero rows.
         if(length(index_zeros)>=1)
           H(index_zeros,:)=[];%Remove those rows.
           H = [H; zeros(length(index_zeros),n)];%Add all zero rows to the end of H.
         end


        end  
  end


%Remove rows with all zeros from H and specify the matricies A and T*************
%Index of all zero rows.
index_zeros = find(all(H==0,2)); 
r_swap = length(index_zeros); 
if r_swap>=1
  H(index_zeros,:)=[];%Remove those rows.
  A  = [H(:,1:n-m) H(:,n-r_swap+1:n)]; 
  T = H(:,n-m+1:n-r_swap);         
else
  H(index_zeros,:)=[];
  A = H(:,1:n-m);
  T = H(:,n-m+1:n);      
end

%Start Backward Substitution
a = T;
b = mod(A * msg_tx',2); 
l = length(b);
y(l,1) = mod(b(l)/a(l,l),2);
%Get the Parity bits
for i = l-1:-1:1
  y(i,1)=mod((b(i)-a(i,i+1:l)*y(i+1:l,1))./a(i,i),2);
end


C_temp = [msg_tx y']; % The Codeword

%Get Inverse 
if(r_swap>=1)
  C_temp1 = C_temp([1:n-m n-m+r_swap+1:n]);
  C_temp2 = C_temp(n-m+1:n-m+r_swap);
  C_temp  = [C_temp1 C_temp2];
end
if (~isempty(swap))
  for i=size(swap,1):-1:1
    C_temp(:,[swap(i,1),swap(i,2)]) = C_temp(:,[swap(i,2),swap(i,1)]);
  end      
  end  
C= C_temp;

fprintf('The encoded Codeword is: \n');
  disp(C)

end