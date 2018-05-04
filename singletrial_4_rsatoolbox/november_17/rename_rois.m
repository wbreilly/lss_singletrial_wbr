% rename each subjects masks with same names

clear all
clc

dataDir     = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/masks';
scriptdir   = '/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox';
subjects    = {'s009' 's020' 's022' 's023' 's024' 's025'};%{'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011'};
b.scriptdir = scriptdir;

newnames = {'resliced_hipp_body_L.nii' 'resliced_hipp_body_R.nii'  'resliced_hipp_head_L.nii' 'resliced_hipp_head_R.nii' ...
            'resliced_hipp_tail_L.nii' 'resliced_hipp_tail_R.nii'   'resliced_phc_ant_L.nii' 'resliced_phc_ant_R.nii' ...
            'resliced_prc_L.nii' 'resliced_prc_R.nii' 'resliced_VMPFC.nii'};

% Loop over subjects
for isub = 1:length(subjects)
    b.curSubj   = subjects{isub};
    b.dataDir   = fullfile(dataDir, b.curSubj, 'ANTS_MTL');
    b.masks     = spm_select('FPListRec', b.dataDir, '.*.nii$');
    keyboard

    for imask = 1:size(b.masks,1) 
        [x,y,z] = fileparts(b.masks(imask,:));
        source = [y,z];
        source = strrep(source, ' ', '');
        movefile(fullfile(b.dataDir, source), fullfile(b.dataDir,newnames{imask}));
    end % imask
end % end isub