% Create sample data:
% load('DVSS_masks.mat', 'all_same_idxs')


% going to mask the mask "by hand" for every square in the 5x5 i'm working
% toward
% ah this is just a mini version of the whole RS matrix mask
% all I have to do is change size of big and start row and column


big = zeros(15,15);
small = [0 1 1;... 
         1 0 1;... 
         1 1 0;];
% Get sizes
[rowsBig, columnsBig] = size(big);
[rowsSmall, columnsSmall] = size(small);
% Specify upper left row, column of where
% we'd like to paste the small matrix.

DVSS_masks = struct;

for irow = [1 4 7 10 13]
    big = zeros(15,15);
    small = [0 1 1;... 
             1 0 1;... 
             1 1 0;];
    row1 = irow;
    column1 = 1;
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
    DVSS_masks(irow).masks = big;
    DVSS_masks(irow).masks = logical(DVSS_masks(irow).masks);
    
end
DVSS_masks = DVSS_masks(~cellfun(@isempty,{DVSS_masks.masks}));
DVSS_masks2 = struct;
for irow = [4 7 10 13]
    big = zeros(15,15);
    small = [0 1 1;... 
             1 0 1;... 
             1 1 0;];
    row1 = irow;
    column1 = 4;
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
%     DVSS_masks(irow).col2 = big;
%     DVSS_masks(irow).col2 = logical(DVSS_masks(irow).col2);
    DVSS_masks2(irow).masks = big;
    DVSS_masks2(irow).masks = logical(DVSS_masks2(irow).masks);
end
DVSS_masks2 = DVSS_masks2(~cellfun(@isempty,{DVSS_masks2.masks}));

DVSS_masks3 = struct;
% DVSS_masks = DVSS_masks(~cellfun(@isempty,DVSS_masks));
for irow = [7 10 13]
    big = zeros(15,15);
    small = [0 1 1;... 
             1 0 1;... 
             1 1 0;];
    row1 = irow;
    column1 = 7;
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
%     DVSS_masks(irow).col3 = big;
%     DVSS_masks(irow).col3 = logical(DVSS_masks(irow).col3);
    DVSS_masks3(irow).masks = big;
    DVSS_masks3(irow).masks = logical(DVSS_masks3(irow).masks);
end
DVSS_masks3 = DVSS_masks3(~cellfun(@isempty,{DVSS_masks3.masks}));

DVSS_masks4 = struct;
for irow = [10 13]
    big = zeros(15,15);
    small = [0 1 1;... 
             1 0 1;... 
             1 1 0;];
    row1 = irow;
    column1 = 10; %%% this and irow = are what I'm changing on all the blocks
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
%     DVSS_masks(irow).col4 = big;
%     DVSS_masks(irow).col4 = logical(DVSS_masks(irow).col4);
    DVSS_masks4(irow).masks = big;
    DVSS_masks4(irow).masks = logical(DVSS_masks4(irow).masks);
end
DVSS_masks4 = DVSS_masks4(~cellfun(@isempty,{DVSS_masks4.masks}));

DVSS_masks5 = struct;
for irow = [13]
    big = zeros(15,15);
    small = [0 1 1;... 
             1 0 1;... 
             1 1 0;];
    row1 = irow;
    column1 = 13; %%% this and irow = are what I'm changing on all the blocks
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
%     DVSS_masks(irow).col4 = big;
%     DVSS_masks(irow).col4 = logical(DVSS_masks(irow).col4);
    DVSS_masks5(irow).masks = big;
    DVSS_masks5(irow).masks = logical(DVSS_masks5(irow).masks);
end
DVSS_masks5 = DVSS_masks5(~cellfun(@isempty,{DVSS_masks5.masks}));



%% now paste the 10 15x15 masks into the 225

mask1 = DVSS_masks(1).masks;
mask2 = DVSS_masks(2).masks;
mask3 = DVSS_masks(3).masks;
mask4 = DVSS_masks(4).masks;
mask5 = DVSS_masks(5).masks;
mask6 = DVSS_masks2(1).masks;
mask7 = DVSS_masks2(2).masks;
mask8 = DVSS_masks2(3).masks;
mask9 = DVSS_masks2(4).masks;
mask10 = DVSS_masks3(1).masks;
mask11 = DVSS_masks3(2).masks;
mask12 = DVSS_masks3(3).masks;
mask13 = DVSS_masks4(1).masks;
mask14 = DVSS_masks4(2).masks;
mask15 = DVSS_masks5(1).masks;


DVSS_masks = struct;

DVSS_masks(1).masks = mask1;
DVSS_masks(2).masks = mask2;
DVSS_masks(3).masks = mask3;
DVSS_masks(4).masks = mask4;
DVSS_masks(5).masks = mask5;
DVSS_masks(6).masks = mask6;
DVSS_masks(7).masks = mask7;
DVSS_masks(8).masks = mask8;
DVSS_masks(9).masks = mask9;
DVSS_masks(10).masks = mask10;
DVSS_masks(11).masks = mask11;
DVSS_masks(12).masks = mask12;
DVSS_masks(13).masks = mask13;
DVSS_masks(14).masks = mask14;
DVSS_masks(15).masks = mask15;


for imask = 1:15
    big = zeros(225,225);
    small = DVSS_masks(imask).masks;
    % Get sizes
    [rowsBig, columnsBig] = size(big);
    [rowsSmall, columnsSmall] = size(small);
    % Specify upper left row, column of where
    % we'd like to paste the small matrix.
    % change step to 3 to include all positions
    for iwin = 1:15:225 % Note change to iwin!!
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
    end % end iwin
    DVSS_masks(imask).masks = big;
    
    
end % end imask 
% 1     4     7    10    13

save('DVSS_bigmasks.mat', 'DVSS_masks')

% save('DVSS_bigmasks.mat', 'DVSS_masks')


