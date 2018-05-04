% reslice, threshold, rename, each subjects' masks
clear all
clc


dataDir     = '/Users/wbr/walter/fmri/sms_scan_analyses/crick_imac/FreeSurfer_sms_scan3/MMP1_native';
scriptdir   = '/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox';
subjects    = {'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011'};
b.scriptdir = scriptdir;

% newnames = {'glass_ANG_150.nii' 'glass_ANG_149.nii' 'glass_RSC_14.nii' 'glass_PCC_34.nii' 'glass_PCC_33.nii' ...
%             'glass_PREC_31.nii' 'glass_PREC_30.nii' 'glass_PREC_27.nii' 'glass_PREC_38.nii' 'glass_PHC_125.nii' ...
%             'glass_PHC_126.nii' 'glass_PHC_127.nii' 'glass_VMPFC_88.nii'}; 
        
newnames = {'L_PGi_ROI.nii' 'L_PFm_ROI.nii' 'L_RSC_ROI' 'L_d23ab_ROI.nii' 'L_v23ab_ROI' ...
            'L_POS1_ROI.nii' 'L_7m_ROI.nii' 'L_PCV_ROI' 'L_23c_ROI.nii' 'L_A5_ROI.nii' ...
            'L_PHA1_ROI.nii' 'L_PHA3_ROI.nii' 'L_10v_ROI.nii' ...
            'R_PGi_ROI.nii' 'R_PFm_ROI.nii' 'R_RSC_ROI' 'R_d23ab_ROI.nii' 'R_v23ab_ROI' ...
            'R_POS1_ROI.nii' 'R_7m_ROI.nii' 'R_PCV_ROI' 'R_23c_ROI.nii' 'R_A5_ROI.nii' ...
            'R_PHA1_ROI.nii' 'R_PHA3_ROI.nii' 'R_10v_ROI.nii'};        
       

% Loop over subjects
for isub = 1:length(subjects)
    b.curSubj   = subjects{isub};
    b.dataDir   = fullfile(dataDir, b.curSubj, 'masks');

    for iidx = 1:length(newnames)
        s = newnames(iidx);
        b.masks(iidx,1)     = cellstr(spm_select('ExtFPListRec', b.dataDir, s));
    end 

    % mean image as the reference 
    path1 = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/batch_preproc_native_10_12_17/';
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
    
%     % grab all the resliced masks
%     b.sliced = (spm_select('FPListRec', b.dataDir, '^reslice.*.nii'));
    
%     for imask = 1:size(b.sliced,1) 
%         [x,y,z] = fileparts(b.sliced(imask,:));
%         input_img = b.sliced(imask,:);
%         output_img = fullfile(b.dataDir, newnames(imask));
%         spm_imcalc(char(input_img),char(output_img), 'i1 ~= 0'); 
%     end % imask
end % end isubd

% y = {};
% for iroi = 1:size(b.masks,1)
%     [x,y{iroi},z] = fileparts(b.masks{iroi,:});
% end
