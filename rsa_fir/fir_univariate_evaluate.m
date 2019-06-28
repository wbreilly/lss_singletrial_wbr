% First time running univariate with FS and ANTS rois from FIRs. Using
% masked data from rsa toolbox

% save a text file of mean condition contrasts to txt for R
clear all
clc

%% setup and create text file

% analysis name
analysis = 'univariate_FSants_6_28_19';
% you know who
subjects = {'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011' 's015' 's016' 's018' 's019'  's020'...
            's022' 's023' 's024' 's025' 's027' 's028' 's029' 's030' 's032' 's033' 's034' 's035' 's036' 's037' ...
            's038' 's039' 's040' 's041' 's042'};
        


%path to bad betas
bad_beta_path = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/fir_data_10_30_18';

% setup txt to write results into with subject and analysis names
analysis_dat = sprintf('%s.txt', analysis);

if fopen(analysis_dat,'rt') ~= -1 
    fclose('all');
    yes_or_no = input('Data file already exists! Are you sure you want to overwrite the file? (yes:1 no:0) ');
    if yes_or_no == 0 || isempty(yes_or_no)
        error('You screwed up, start over!!');
    end
end

% write analysis file
fid_study = fopen(analysis_dat,'wt');
% write header
fprintf(fid_study,'sub roi condition position seqnum runnum bold\n');

cur_path = pwd;
cd('/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox/')
betas = betaCorrespondence;
cd(cur_path)

% get beta name parts from betas.identifier
beta_name_parts = cell(1440,4);
for ibeta = 1:size(betas,2)
    remain = betas(ibeta).identifier;
    segments = {};
    while isempty(remain) ~= 1
       [token,remain] = strtok(remain, '_');
       segments = [segments ; token];
    end
    
    beta_name_parts(ibeta,:) = segments';
end % ibeta

% cleanup beta name parts
for ibeta = 1:size(betas,2)
    beta_name_parts(ibeta,3) = strrep(beta_name_parts(ibeta,3),'pos','');
end % ibeta


%% loop through each sub
for iRDM = 1:length(subjects)
    tic
    % load up the bad beta identifiers
    beta_txt = fullfile(bad_beta_path,subjects{iRDM}, 'all_gray', 'fir_5ptile_2_23_19.txt');
    bad_betas = textread(beta_txt);
 

    % load the Image Data. This is saved out from running rsa toolbox.
    % Includes a voxel x beta array for every ROI. 1440 columns, one for
    % each FIR beta image (each timepoint is mean of three repetition sequences)
    load(sprintf('/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox/ImageData/%s_FIR_RSA_10_31_18_responsePatterns.mat',subjects{iRDM}));
    
    % get the ROI names
    roi_list = fieldnames(responsePatterns);
   
    % number of rois
    num_rois = size(roi_list,1);
    
    mean_timecourse = zeros(num_rois,1440);
    % take the mean across voxels for every timepoint in every ROI
    for iname = 1:num_rois;
        mean_timecourse(iname,:) = mean(responsePatterns.(roi_list{iname}).(subjects{iRDM}));
    end
     
    % NaN bad betas to be excluded
    % if statement addresses situation where 0 betas excluded. TXT
    % is manaually edited to add a 0 and avoid out of memory error
    
    % this makes NaN for current subject across all rois for bad trial
    if sum(bad_betas) ~= 0
        for ibad = 1:length(bad_betas)
            mean_timecourse(:,bad_betas(ibad)) = NaN;
        end % end ibad
    end

    % 'sub roi condition position seqnum runnum bold\n'
    for iroi=1:num_rois
        for ibeta = 1:1440
        % save data in txt file
            fprintf(fid_study,'%s %s %s %s %s %s %.5f\n', subjects{iRDM}, roi_list{iroi}, beta_name_parts{ibeta,1},beta_name_parts{ibeta,3},beta_name_parts{ibeta,2},beta_name_parts{ibeta,4}, mean_timecourse(iroi,ibeta));
        end %ibeta   
    end % end iroi

    toc
end %end iRDM


