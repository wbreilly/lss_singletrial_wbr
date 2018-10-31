% Create a mask for every regressor in each sequence. Used a window of 32
% TRs so there are 32 regs per sequence. Betas were organized similarly to
% single trial models such that I can repeat the pattern down the diagonal


%% don't mess with
small = [0 0 0;... 
         1 0 0;... 
         1 1 0;];
big = zeros(96,96);
    
    % Get sizes
[rowsBig, columnsBig] = size(big);
[rowsSmall, columnsSmall] = size(small);
 %%   

 % 32 total indices for thr 32 regs per sequence in FIR model
paste_idx = 1:3:96;
%place to put things
fir_small_masks = struct;

for ipos = 1:32
    
    % reset every for every position
    big = zeros(96,96);
    
    iwin = paste_idx(ipos);
        
    row1 = iwin;
    column1 = iwin;
    % Determine lower right location.
    row2 = row1 + rowsSmall - 1;
    column2 = column1 + columnsSmall - 1;
    % See if it will fit.
    if row2 <= rowsBig
        % It will fit, so paste it.
        big(row1:row2, column1:column2) = small;
    else
        % It won't fit
        warningMessage = sprintf('That will not fit.\nThe lower right coordinate would be at row %d, column %d.',...
            row2, column2);
        uiwait(warndlg(warningMessage));
    end
    
     
    fir_small_masks(ipos).mask = big;
end

clear big small

fir_big_masks = struct;

% now put the smaller mask in the big mask
for ipos = 1:32
    
    small = fir_small_masks(ipos).mask;
    big = zeros(1440,1440);

        % Get sizes
    [rowsBig, columnsBig] = size(big);
    [rowsSmall, columnsSmall] = size(small);
    
    for iwin = 1:96:1440 % Note change to iwin!!
        row1 = iwin;
        column1 = iwin;
        % Determine lower right location.
        row2 = row1 + rowsSmall - 1;
        column2 = column1 + columnsSmall - 1;
        % See if it will fit.
        if row2 <= rowsBig
            % It will fit, so paste it.
            big(row1:row2, column1:column2) = small;
        else
            % It won't fit
            warningMessage = sprintf('That will not fit.\nThe lower right coordinate would be at row %d, column %d.',...
                row2, column2);
            uiwait(warndlg(warningMessage));
        end
    end
    big = logical(big);
    fir_big_masks(ipos).mask = big;
end 

save('masks_32reg_FIR.mat', 'fir_big_masks')

% quick check
% allthem = zeros(1440,1440);
% for ipos = 1:32
%    allthem = allthem + fir_big_masks(ipos).mask; 
% end





