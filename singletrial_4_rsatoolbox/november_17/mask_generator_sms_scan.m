% Create sample data:

big = zeros(225,225);
small = [0 0 0;... 
         1 0 0;... 
         1 1 0;];
% Get sizes
[rowsBig, columnsBig] = size(big);
[rowsSmall, columnsSmall] = size(small);
% Specify upper left row, column of where
% we'd like to paste the small matrix.
% change step to 3 to include all positions
for iwin = 13:15:225 % Note change to iwin!!
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

% 1     4     7    10    13

SVSS_p5 = big;
SVSS_p5 = logical(SVSS_p5);
save('SVSS_p5.mat', 'SVSS_p5');