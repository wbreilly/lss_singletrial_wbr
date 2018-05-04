% 
% 
% 
% 
% 
% 
% 
clear all

    
load('singletrial_glass_fs_10_23_17_RDMs.mat');
%loop through each roi
for iroi = 1%:size(RDMs,1) 
    % loop through each sub
    for iRDM = 1 %1:size(RDMs,2)
        
        % clearvars
        clearvars -except RDMs iroi iRDM      

        % grab the RDM
        x = RDMs(iroi,iRDM).RDM;
        
        % NaN betas to be excluded
        % subject numbers **must** be converted to consecutive numbers
        bad_betas = textread(sprintf('s%03d/1.2_bad.txt',iRDM),'%d');
        for ibad = 1:length(bad_betas)
            x(bad_betas(ibad),:) = NaN;
            x(:,bad_betas(ibad)) = NaN;
        end % end ibad
        
        % but remove any NaNs from diag and seto to 0 so I can get rid 
        x(logical(eye(size(x)))) = 0;
        
        % NaN any correlations that equal zero (ones in dissimilarity)
        x(x == 1) = NaN;
        %% convert to similarity, UNLESS USING COSINE
        x = -1*(x-1);
        %% 
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

        
        %% get rid of ones, if using correlation
        x(x == 1) = 0;
        
        %% git rid of zeroes and vectorize
        x_vec = x(x~=0);
        
        if length(x_vec) ~= 225
            error('x_vec is not equal to 225!!')
        end

        % pull out values for each condition
        x_i = x_vec(1:90);
        x_s_r = x_vec(91:135);
        x_s_f = x_vec(136:225);

        % now take the mean of of all correlations
        x_i_mean = nanmean(x_i);
        x_s_r_mean = nanmean(x_s_r);
        x_s_f_mean = nanmean(x_s_f);
        
        save(sprintf('sub%dcondmeans_roi%d.mat', iRDM,iroi), 'x_i_mean', 'x_s_r_mean','x_s_f_mean')
    end % end iRDM

    %set mat
    all_intact = [];
    all_random = [];
    all_scramfix = [];
    % now conc means 
    for isub = 1:iRDM
        load(sprintf('sub%dcondmeans_roi%d.mat', isub,iroi))
        all_intact = [all_intact x_i_mean];
        all_random = [all_random x_s_r_mean];
        all_scramfix = [all_scramfix x_s_f_mean];    
    end

    fprintf('\n%s\n Mean all_intact: %.03f\n', RDMs(iroi,1).name, nanmean(all_intact))
    fprintf('%s\n Mean all_scramfix: %.03f\n', RDMs(iroi,1).name, nanmean(all_scramfix))
    fprintf('%s\n Mean all_random: %.03f\n', RDMs(iroi,1).name, nanmean(all_random))
    [t,p] = ttest(all_intact,all_scramfix)
    
    fprintf('---------------------------------------------\n')
end


