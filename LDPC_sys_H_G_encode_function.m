function [C] = LDPC_sys_H_G_encode_function(H)
%Encoder Part, Create Hsystematic and G given the LDPC Matrix H

[m,n]=size(H); %recalculate size
% Check Rank and convert into Full Rank Matrix (H won't be Full Rank in almost
% all cases)
%Transpose H to extract independent columns as it is easier
Ht=H';
tol=1e-10; %tolerance to check rank estimation, default value
if rank(H)==m %H has no non-zeros rows and hence no independent columns
  fprintf('The Matrix is already a Full Matrix\n');
  H_fullrank=H;
else                              %Rank estimation method to remove dependent columns
   [Q, P, E] = qr(Ht,0); 
    if ~isvector(P)
    diagr = abs(diag(P));
   else
    diagr = P(1);   
   end
   %Rank estimation
   r = find(diagr >= tol*diagr(1), 1, 'last'); 
   index=sort(E(1:r));
   Rsub=Ht(:,index);
   H_fullrank=Rsub'; %Get Back H as a full Rank
end
% Gauss-Jordan elimination (works but we get H=I|Pt not the other way!) So, created additional code to rearrange H_fullrank into systematic form

[m_fr,n] = size(H_fullrank);   %Reuse row-size after full rank, Column-size remains same
swaps=zeros(m_fr,2);       
swaps_count=1;
H_fr_temp=H_fullrank;  % Copy H_fullrank to another Matrix
j=1;
index=1;
while index<=m_fr
    i=index;
    while (H_fr_temp(i,j)==0)&&(i<m_fr)
        i=i+1;
    end
    if H_fr_temp(i,j)==1
        temp=H_fr_temp(i,:);
        H_fr_temp(i,:)=H_fr_temp(index,:);
        H_fr_temp(index,:)=temp;
        for i=1:m_fr
            if (index~=i)&&(H_fr_temp(i,j)==1)
                H_fr_temp(i,:)=mod(H_fr_temp(i,:)+H_fr_temp(index,:),2);
            end
        end
        swaps(swaps_count,:)=[index j];
        swaps_count=swaps_count+1;
        index=index+1;
        j=index;
    else
        j=j+1;
    end
end

for i=1:swaps_count-1
    temp=H_fr_temp(:,swaps(i,1));
    H_fr_temp(:,swaps(i,1))=H_fr_temp(:,swaps(i,2));
    H_fr_temp(:,swaps(i,2))=temp;
    %disp(H_fr_temp)
end
%Get Identity and P' separately to rearrage the Matrix

I = H_fr_temp(:,1:m_fr);
A = H_fr_temp(:,(m_fr+1):n);
Hsys =[A I];
fprintf('Below is the LDPC matrix H in systematic form of order (%d X %d), rank %d and density of %f\n', size(Hsys,1),size(Hsys,2),rank(Hsys),(sum(Hsys(:) == 1)/(m_fr*n)));
disp(Hsys)
k=n-m_fr;
G = gen2par(Hsys);  %Generater Matrix from Hsys
fprintf('Below is the required Generator Matrix G in systematic form of order (%d X %d), rank %d \n', size(G,1),size(G,2),rank(G));
disp(G)

%Create Random Message to encode
fprintf('Random message is \n');
msg_tx = round(rand(1,k)) ;
disp(msg_tx)    

%Encode Message with G
C = mod(double(msg_tx)*double(G),2);    
fprintf('The encoded Codeword is: \n');
disp(C)

end