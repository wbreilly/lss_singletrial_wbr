% Reformat link-list for info map. needed to remove .0 from first two colums
% Just used MATLAB gui to import old txt file


analysis_dat = sprintf('thresh_90prc_pearson_6_4_18.txt');
fid_out = fopen(analysis_dat,'wt');
fprintf(fid_out,'#source target weight\n');


for irow = 1:length(source)
    fprintf(fid_out, '%g %g %.3f\n', source(irow), target(irow),  weight(irow));
end

