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

toolboxRoot = '/Users/Documents/Matlab/rsatoolbox'; addpath(genpath(toolboxRoot));
userOptions = defineUserOptions();

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

% s001_cor_mtx = -1*(RDMs.RDM-1);
% x = s001_cor_mtx;
% colormap('redblue')
% plot_s001_cor_mtx = imagesc(s001_cor_mtx,[-1 1]);
% colorbar;

sRDMs = averageRDMs_subjectSession(RDMs, 'session');
RDMs = averageRDMs_subjectSession(RDMs, 'session', 'subject');
Models = constructModelRDMs(modelRDMs(), userOptions);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% First-order visualisation %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
figureRDMs(RDMs, userOptions, struct('fileName', 'RoIRDMs', 'figureNumber', 1));
% figureRDMs(Models, userOptions, struct('fileName', 'ModelRDMs', 'figureNumber', 2));
% WBR
% MDSConditions(RDMs, userOptions);
% dendrogramConditions(RDMs, userOptions);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% relationship amongst multiple RDMs %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pairwiseCorrelateRDMs({RDMs, Models}, userOptions);
MDSRDMs({RDMs, Models}, userOptions);

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
