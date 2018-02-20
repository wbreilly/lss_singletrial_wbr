% prepare text file for infomap
% this starts with your corr matrix loaded into matlab, and your node
% labels somewhere

% the values
% Fisher transform to increase normality (Petersen group)
corrMat = fisherTransform(corrMat);
% put zeros on diag
corrMat = vectorizeRDM(corrMat);
corrMat = squareform(corrMat);

% load the names
load('glass_roi_names.mat');
names = y(2:end);

%%
% thresholds
prctile(vectorizeRDM(corrMat),90)
%%
% now just gotta print to a txt file 
analysis_dat = sprintf('thresh_90prc_spearman_second_order_4infomap.txt');

if fopen(analysis_dat,'rt') ~= -1 
    fclose('all');
    yes_or_no = input('Data file already exists! Are you sure you want to overwrite the file? (yes:1 no:0) ');
    if yes_or_no == 0 || isempty(yes_or_no)
        error('You screwed up, start over!!');
    end
end


% write analysis file
fid_out = fopen(analysis_dat,'wt');
% write header
fprintf(fid_out,'#source target weight\n');
%%

% make a corr mtx of the ROI pairs that make up the second order corr mtx
% strmtx = {};
%  for RDMI1 = 1:length(names)
%     for RDMI2 = 1:length(names)
%         strmtx{RDMI1,RDMI2} = strcat(names{RDMI1}, {' '},names{RDMI2});
%     end
%  end   

 % name nodes with pairs of numbers (the mtx indices)
startcol = 1;
startrow = 2;
for icol = startcol:size(corrMat,2)
    for irow = startrow:size(corrMat,1)
        % the value
        outval = corrMat(irow,icol);
        % don't print NaNs
        if isnan(outval)
            outval = 0;
        elseif outval < .5486
            outval = 0;
        end
        fprintf(fid_out, '%.0f %.0f %.3f\n', irow, icol,  outval);
    end
    startrow = startrow +1;
end
 
 % print string node names
% startcol = 1;
% startrow = 2;
% for icol = startcol:size(corrMat,2)
%     for irow = startrow:size(corrMat,1)
%         % the value
%         outval = corrMat(irow,icol);
%         %the name of the pair that made above outval
%         tempname = strmtx{irow,icol};
%         fprintf(fid_out, '%s %.3f\n', tempname{:}, outval);
%     end
%     startrow = startrow +1;
% end





