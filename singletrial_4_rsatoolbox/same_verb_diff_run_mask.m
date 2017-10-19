% 
% 
% 
% 
% 
% 
% 
clear all

% eliminate:
    % columns that are multiples of 3 
    % diagonal and everything above it 
    
load('/Users/wbr/walter/fmri/sms_scan_analyses/rsa_singletrial/singletrial_4_rsatoolbox/RDMs/singletrial_glass_10_17_17_RDMs.mat');
%loop through each roi
for iroi = 1:13 %1:size(RDMs,1)  %[1 2 3 4  7 8 9 10 11]
    % loop through each sub
    for iRDM = 1:9 % 2 3 4 5 6 7 8 9] 
        
        clearvars -except RDMs iroi iRDM 
        
        x = -1*(RDMs(iroi,iRDM).RDM-1);
        % get only lower diagonal    
        x = tril(x);

        % eliminate every third column

        % all col idxs
        w = 1:225;
        % cols idxs I want to delete
        z = 3:3:225;
        % diff of the two
        idxs = setdiff(w,z);

        % final step to delete cols
        x = x(:,idxs);

        %for selecting appropriate rows to set to 0
        pad = 3;
        pad2 = 2;

        for icol = 1:150
            % if odd number icol
            if mod(icol,2)
                x(icol+pad:end,icol) = 0; 
                pad = pad + 1;
            else
                x(icol+pad2:end,icol) = 0; 
                pad2 = pad2 + 1;
            end
        end % end iseq

        
        % get rid of ones
        x(x == 1) = 0;
        % git rid of zeroes and vectorize
        x_vec = x(x~=0);

        % pull out values for each condition
        x_i = x_vec(1:90);
        x_s_r = x_vec(91:135);
        x_s_f = x_vec(136:225);

        % now take the mean of of all correlations
        x_i_mean = mean(x_i);
        x_s_r_mean = mean(x_s_r);
        x_s_f_mean = mean(x_s_f);
        save(sprintf('sub%dcondmeans.mat', iRDM), 'x_i_mean', 'x_s_r_mean','x_s_f_mean')
    end % end iRDM

    %set mat
    all_intact = [];
    all_random = [];
    all_scramfix = [];
    % now conc means 
    for isub = 1:9
        load(sprintf('sub%dcondmeans.mat', isub))
        all_intact = [all_intact x_i_mean];
        all_random = [all_random x_s_r_mean];
        all_scramfix = [all_scramfix x_s_f_mean];    
    end

    fprintf('\n%s\n Mean all_intact: %.03f\n', RDMs(iroi,1).name, mean(all_intact))
    fprintf('%s\n Mean all_scramfix: %.03f\n', RDMs(iroi,1).name, mean(all_scramfix))
    fprintf('%s\n Mean all_random: %.03f\n', RDMs(iroi,1).name, mean(all_random))
    [t,p] = ttest(all_intact,all_scramfix)
    
    fprintf('---------------------------------------------\n')
end


