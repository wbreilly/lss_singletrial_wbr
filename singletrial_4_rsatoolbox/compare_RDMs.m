

% load the stuff
load('/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox/RDMs/singletrial_native_10_16_17_.2thresh_RDMs.mat')
thresh_RDMs = RDMs;
clear RDMs;
load('/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox/RDMs/singletrial_native_reslicedbetas_10_15_17_RDMs.mat')
reslice_RDMs = RDMs;
clear RDMs;

% % average between subs
% for i = 1:size(thresh_RDMs,1)
%     thresh_RDMs(i,3).RDM = (thresh_RDMs(i,1).RDM + thresh_RDMs(i,2).RDM)/2;
%     thresh_RDMs(i,3).RDM = -1*(thresh_RDMs(i,3).RDM-1);
% end
% 
% % average between subs
% for i = 1:size(reslice_RDMs,1)
%     reslice_RDMs(i,3).RDM = (reslice_RDMs(i,1).RDM + reslice_RDMs(i,2).RDM)/2;
%     reslice_RDMs(i,3).RDM = -1*(reslice_RDMs(i,3).RDM-1);
% end 

% correlate between different approaches for each sub and roi 
corr_sums = zeros(11,1);
for isub = 1:2
    for i = 1:size(reslice_RDMs,1)
        corr_sums(i,isub) = mean(mean(corr(reslice_RDMs(i,isub).RDM, thresh_RDMs(i,isub).RDM)));
    end 
end

