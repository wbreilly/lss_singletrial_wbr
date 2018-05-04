% reslice gray matter masks
clear all
clc


dataDir     = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/getbetas_native_10_20_17_duplicate';
scriptdir   = '/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox';
subjects    = {'s009' 's020' 's022' 's023' 's024' 's025'}; %'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011' 's015' 's016' 's018' 's019'};
b.scriptdir = scriptdir;


% Loop over subjects
for isub = 1:length(subjects)
    b.curSubj   = subjects{isub};
    b.dataDir   = fullfile(dataDir, b.curSubj);
    b.mask    = cellstr(spm_select('ExtFPListRec', b.dataDir, 'allgray.nii'));
    
    % mean image as the reference 
    path1 = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/batch_preproc_native_2_28_18/';
    path2 = sprintf('Rifa_1/meanslicetime_%s.Rifa_1.bold.nii', b.curSubj);
    ref_img = fullfile(path1, b.curSubj, path2);
    
    %loop through masks
    for imask = 1:size(b.mask,1)
        matlabbatch{imask}.spm.spatial.coreg.write.ref = cellstr(ref_img);
        matlabbatch{imask}.spm.spatial.coreg.write.source = b.mask(imask,:);
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.interp = 0;
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.mask = 0;
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.prefix = 'reslice_';
    end % end imask
    
    %run
    spm('defaults','fmri');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
end % end isubd

