% reslice, threshold, rename, each subjects' masks
clear all
clc


dataDir     = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/masks';
scriptdir   = '/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox';
subjects    = {'s009' 's020' 's022' 's023' 's024' 's025'};%{'s001' 's002' 's003' 's004' 's007' 's008' 's010' 's011' 's015' 's016' 's018' 's019'}; 
b.scriptdir = scriptdir;

% newnames = {'lh_ACC' 'lh_ANG' 'lh_MPFC' 'lh_PCC' 'lh_PHG' 'lh_Prec' 'lh_RSC' ...
%     'lh_TPole' 'lh_VMPFC' 'lh_occ_pole' 'rh_ACC' 'rh_ANG' 'rh_MPFC' ...
%     'rh_PCC' 'rh_PHG' 'rh_Prec' 'rh_RSC' 'rh_TPole' 'rh_VMPFC' 'rh_occ_pole'};
% 
% newnames = strcat(newnames, '.nii');

% Loop over subjects
for isub = 1:length(subjects)
    b.curSubj   = subjects{isub};
    b.dataDir   = fullfile(dataDir, b.curSubj, 'all_glass');
    b.masks     = cellstr(spm_select('ExtFPListRec', b.dataDir, '.*.nii'));
    
    % mean image as the reference 
    path1 = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/batch_preproc_native_2_28_18/';
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
%     b.sliced = (spm_select('FPListRec', b.dataDir, '^reslice.*.nii'));
    
%     for imask = 1:size(b.sliced,1) 
%         [x,y,z] = fileparts(b.sliced(imask,:));
%         input_img = b.sliced(imask,:);
%         output_img = fullfile(b.dataDir, newnames(imask));
%         spm_imcalc(char(input_img),char(output_img), 'i1 ~= 0'); 
%     end % imask
end % end isub

% y = {};
% for iroi = 1:size(b.masks,1)
%     [x,y{iroi},z] = fileparts(b.masks{iroi,:});
% end
