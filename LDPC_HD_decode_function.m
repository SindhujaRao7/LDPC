function [cw_new,Code_Errors_count] = LDPC_HD_decode_function(Y,C)

%Taking nearest integer value so that Threshold is set at 0 to decide bit values
Y_demod = floor(nearest(Y));

for i=1:size(Y_demod,2)
    if Y_demod(i) < 0
        Y_demod(i)=0;
    elseif Y_demod(i) == 0
        Y_demod(i)=0;
    else
       Y_demod(i)=1;
    end
end

cw_new=Y_demod;
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