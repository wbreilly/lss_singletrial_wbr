% select and reslice Glasser ROIs
clear all
clc


dataDir     = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/masks';
scriptdir   = '/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox';
subjects    = {'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011'};
b.scriptdir = scriptdir;

newnames = {'glass_ANG_150.nii' 'glass_ANG_149.nii' 'glass_RSC_14.nii' 'glass_PCC_34.nii' 'glass_PCC_33.nii' ...
            'glass_PREC_31.nii' 'glass_PREC_30.nii' 'glass_PREC_27.nii' 'glass_PREC_38.nii' 'glass_PHC_125.nii' ...
            'glass_PHC_126.nii' 'glass_PHC_127.nii' 'glass_VMPFC_88.nii'};

 
        
newnums = regexprep(newnames, '\D', '');      

        
% Loop over subjects
for isub = 1:length(subjects)
    b.curSubj   = subjects{isub};
    b.dataDir   = fullfile(dataDir, b.curSubj, 'Glass2');
    % grab all the complete parcellation
    b.parcel = (spm_select('FPListRec', b.dataDir, '^Glasser.*.nii$'));
    
%     outputdir = fullfile(dataDir, b.curSubj, 'Glass2');
    
    for imask = 1:length(newnames) 
        input_img = b.parcel(1,:);
        output_img = fullfile(b.dataDir, newnames(imask));
        spm_imcalc(char(input_img),char(output_img), sprintf('i1 == %d',str2double(newnums{imask}))); 
    end % imask

    b.masks = cellstr((spm_select('FPListRec', b.dataDir, '^glass_.*.nii$')));
    
%     path1 = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/getbetas_native_10_13_17';
%     path2 = 'beta_4_rsa_singletrial/intact_seq1_pos1_run1 copy.nii';
%     
%     % the beta image used as reference
%     ref_img = fullfile(path1, b.curSubj, path2);
    
    % using the mean image as ref image now instead of a beta
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
        matlabbatch{imask}.spm.spatial.coreg.write.roptions.prefix = 'reslice_near_';
    end % end imask
    
    %run
    spm('defaults','fmri');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
    
    
    
    
end % end isubd