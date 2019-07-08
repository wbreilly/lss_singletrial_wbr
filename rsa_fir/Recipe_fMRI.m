% Recipe_fMRI
% this 'recipe' performs region of interest analysis on fMRI data.
% Cai Wingfield 5-2010, 6-2010, 7-2010, 8-2010
%__________________________________________________________________________
% Copyright (C) 2010 Medical Research Council

%%%%%%%%%%%%%%%%%%%%
%% Initialisation %%
%%%%%%%%%%%%%%%%%%%%

clear all
clc

subjects = {'s001' 's002' 's003' 's004' 's007' 's008' 's009' 's010' 's011' 's015' 's016' 's018' 's019'  's020'...
           's022' 's023' 's024' 's025' 's027' 's028' 's029' 's030' 's032' 's033' 's034' 's035' 's036' 's037' ...
           's038' 's039' 's040' 's041' 's042'};


toolboxRoot = '/Users/Documents/Matlab/rsatoolbox'; addpath(genpath(toolboxRoot));

for isub = 1:2 %26:length(subjects)
    try
        userOptions = defineUserOptions(subjects{isub});

        %%%%%%%%%%%%%%%%%%%%%%
        %% Data preparation %%
        %%%%%%spm %%%%%%%%%%%%%%%%

        fullBrainVols = fMRIDataPreparation(betaCorrespondence, userOptions); %need array of beta filenames
        binaryMasks_nS = fMRIMaskPreparation(userOptions);
        responsePatterns = fMRIDataMasking(fullBrainVols, binaryMasks_nS, betaCorrespondence, userOptions);

        %%%%%%%%%%%%%%%%%%%%%
        %% RDM calculation %%
        %%%%%%%%%%%%%%%%%%%%%

        RDMs = constructRDMs(responsePatterns, betaCorrespondence, userOptions);
        
    catch ME
        rethrow(ME)
        warning(sprintf('\n\nproblem with %s\n\n', isub))
    end
end











% s001_cor_mtx = -1*(RDMs.RDM-1);
% x = s001_cor_mtx;
% colormap('redblue')
% plot_s001_cor_mtx = imagesc(s001_cor_mtx,[-1 1]);
% colorbar;

% sRDMs = averageRDMs_subjectSession(RDMs, 'session');
% RDMs = averageRDMs_subjectSession(RDMs, 'session', 'subject');
% Models = constructModelRDMs(modelRDMs(), userOptions);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% First-order visualisation %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figureRDMs(RDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 1));
% figureRDMs(Models, userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 2));
% WBR
% MDSConditions(RDMs, userOptions);
% dendrogramConditions(RDMs, userOptions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% relationship amongst multiple RDMs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pairwiseCorrelateRDMs({RDMs, Models}, userOptions);
% MDSRDMs({RDMs, Models}, userOptions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% statistical inference %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%roiIndex = 1; % index of the ROI for which the group average RDM will serve 
               % as the reference RDM. 
%{
for i=1:numel(Models)
    models{i}=Models(i);
end
userOptions.RDMcorrelationType='Kendall_taua';
userOptions.RDMrelatednessTest = 'subjectRFXsignedRank';
userOptions.RDMrelatednessThreshold = 0.05;
userOptions.figureIndex = [10 11];
userOptions.RDMrelatednessMultipleTesting = 'FDR';
userOptions.candRDMdifferencesTest = 'subjectRFXsignedRank';
userOptions.candRDMdifferencesThreshold = 0.05;
userOptions.candRDMdifferencesMultipleTesting = 'none';
stats_p_r=compareRefRDM2candRDMs(RDMs(roiIndex), models, userOptions);
%}
