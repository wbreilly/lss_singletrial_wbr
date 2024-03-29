% reslice, threshold, rename, each subjects masks

clear all
clc

dataDir     = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/ants_from_clust_10_23_18/';
scriptdir   = '/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox';
subjects    = {'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011' 's015' 's016' 's018' 's019'  's020'...
               's022' 's023' 's024' 's025' 's027' 's028' 's029' 's030' 's032' 's033' 's034' 's035' 's036' 's037' ...
               's038' 's039' 's040' 's041' 's042' 's043'};
b.scriptdir = scriptdir;

% newnames = {'near_hipp_body_L.nii' 'near_hipp_body_R.nii'  'near_hipp_head_L.nii' 'near_hipp_head_R.nii' ...
%             'near_hipp_tail_L.nii' 'near_hipp_tail_R.nii' 'near_phc_ant_L.nii' 'near_phc_ant_R.nii' ...
%             'near_prc_L.nii' 'near_prc_R.nii' 'near_VMPFC.nii'};
        
% no more vmpfc from neurosynth
newnames = {'near_hipp_body_L.nii' 'near_hipp_body_R.nii'  'near_hipp_head_L.nii' 'near_hipp_head_R.nii' ...
    'near_hipp_tail_L.nii' 'near_hipp_tail_R.nii' 'near_phc_ant_L.nii' 'near_phc_ant_R.nii' ...
    'near_prc_L.nii' 'near_prc_R.nii'};

% Loop over subjects
for isub = 2:length(subjects)
    b.curSubj   = subjects{isub};
%     b.dataDir   = fullfile(dataDir, b.curSubj, 'ANTS_MTL');
    b.dataDir   = fullfile(dataDir, b.curSubj, 'mprage_sag_NS_g3');
    b.masks     = cellstr(spm_select('ExtFPListRec', b.dataDir, '.*mask.*.nii'));
    
    
%     path1 = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/getbetas_native_10_13_17';
%     path2 = 'beta_4_rsa_singletrial/intact_seq1_pos1_run1 copy.nii';
%     
%     % the beta image used as reference
%     ref_img = fullfile(path1, b.curSubj, path2);

    % mean image as the reference 
    path1 = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/mean_epi_from_clust_preproc_10_22_18/';
    path2 = sprintf('Rifa_1/meanslicetime_%s.Rifa_1.bold.nii', b.curSubj);
    ref_img = fullfile(path1, b.curSubj, path2);
    
    %loop through masks
    for imask = 1:size(b.masks,1)
        matlabbatch{imask}.spm.spatial.coreg.write.ref = cellstr(ref_img);
        matlabbatch{imask}.spm.spatial.coreg.write.source = b.masks(imask,:);
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.interp = 0;
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.mask = 0;
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.prefix = 'reslice_';
    end % end imask
    
    %run
    spm('defaults','fmri');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
    % grab all the resliced masks
    b.sliced = (spm_select('FPListRec', b.dataDir, '^reslice.*.nii'));
    
    for imask = 1:size(b.sliced,1) 
        [x,y,z] = fileparts(b.sliced(imask,:));
        input_img = b.sliced(imask,:);
        output_img = fullfile(b.dataDir, newnames(imask));
        spm_imcalc(char(input_img),char(output_img), 'i1 ~= 0'); 
    end % imask
end % end isubd