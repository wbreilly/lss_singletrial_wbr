% 
% 
% 
% 
% 
% 
% 

% eliminate:
    % columns that are multiples of 3 
    % diagonal and everything above it 

    
% get only lower diagonal    
x = tril(x);

% eliminate every third column

% all col idxs
w = 1:225;
% cols idxs I want to delete
z = 3:3:225;
% diff of the two
idxs = setdiff(w,z);

% final step to delete cols
x = x(:,idxs);



%for selecting appropriate rows to set to 0
pad = 3;
pad2 = 2;

for icol = 1:150
    % if odd number icol
    if mod(icol,2)
        x(icol+pad:end,icol) = 0; 
        pad = pad + 1;
    else
        x(icol+pad2:end,icol) = 0; 
        pad2 = pad2 + 1;
    end
end % end iseq

% get rid of ones
x(x == 1) = 0;
%git rid of zeroes and vectorize
x_vec = x(x~=0);

% pull out values for each condition
x_i = x_vec(1:90);
x_s_r = x_vec(91:135);
x_s_f = x_vec(136:225);

% now take the mean of the abs of all correlations
x_i_mean = mean(abs(x_i))
x_s_r_mean = mean(abs(x_s_r))
x_s_f_mean = mean(abs(x_s_f))