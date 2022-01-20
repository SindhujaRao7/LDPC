function [Parity_check_Matrix,R] = LDPC_Create_H_function(n,wc,wr)
	
    %Gallager Method of Creating the regular Parity Check Matrix

    m = n*wc/wr; % Calculate rows of H as integer, doing the check
    Parity_check_Matrix_sub = zeros(n/wr,n); % Divide the Matrix into sub parts to work with sections

    %First Section to place 1s in repeated order till n/wr rows
 for i = 1:n/wr
        for j = (i-1)*wr+1:i*wr
            Parity_check_Matrix_sub(i,j) = Parity_check_Matrix_sub(i,j) + 1;
        end
 end
    %Repeated sections till m to create random permutations maintaning the distribution
    Parity_check_Matrix_temp = Parity_check_Matrix_sub;
 for t = 2:wc
    x = randperm(n);
    Parity_check_Matrix_sub_perm = Parity_check_Matrix_sub(:,x);
    Parity_check_Matrix_temp = [Parity_check_Matrix_temp Parity_check_Matrix_sub_perm];
 end
    Parity_check_Matrix = zeros(m,n);
 for k = 1:wc
    Parity_check_Matrix((k-1)*(n/wr)+1:(k)*(n/wr),1:n) = Parity_check_Matrix((k-1)*(n/wr)+1:(k)*(n/wr),1:n) + Parity_check_Matrix_temp(:,(k-1)*n+1:k*n);
 end
 
  fprintf('Below is the required LDPC code of order (%d X %d)\n', size(Parity_check_Matrix,1),size(Parity_check_Matrix,2));
  disp(Parity_check_Matrix)
  density = wc/m;
  fprintf('This code has Density: %f\n', density);
  R=1-(rank(Parity_check_Matrix)/n);                              % Rate of the Code for Channel 
  fprintf('The Code Rate for this H is %f \n',R);
  save('Parity_check_Matrix_H.mat','Parity_check_Matrix');
end

