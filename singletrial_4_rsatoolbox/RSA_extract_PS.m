% This script takes the output matrices from the RSA toolbox by Nili et al.
%  and extracts RSA values by ROI by model.  This is ideal for RSA on 
%  examining pairs of trials.
% The mean RSA values for each subject for each ROI for each model are
%  output in long format in a single csv

clear all;
restoredefaultpath;
addpath('/Users/trjonker/MatlabWork/Retriev01/scripts'); % add any necessary paths (e.g., to initialize_vars)
addpath('/Users/trjonker/MatlabWork/Matlab_Scripts');
addpath(genpath('~/MatlabWork/spm12'));

outDir = '/Users/trjonker/MatlabWork/Retriev01/Analysis/RSA/RDMs/';
savedir = '/Users/trjonker/Box Sync/Experiments/RIFA/fMRIStudy/Results/'; %the location where your csv will be saved
regdir = '/Users/trjonker/Box Sync/Experiments/RIFA/fMRIStudy/Behav/'; %the location where your csv will be saved
matricesIn = dir([outDir, 'retriev01RSA_Cortex_RDMs.mat']);
modelsIn = dir([outDir, 'retriev01RSA_Cortex_Models.mat']);
final_csv_name = 'allRSA_cortex.csv';

% List all subject names.  These should match the format provided in your RDMs
subjID = {'retriev01_S02' 'retriev01_S04' 'retriev01_S05' 'retriev01_S06' ...
          'retriev01_S07' 'retriev01_S08' 'retriev01_S10' 'retriev01_S11' ...
          'retriev01_S12' 'retriev01_S13' 'retriev01_S15' 'retriev01_S16' ...
          'retriev01_S17' 'retriev01_S18' 'retriev01_S19' 'retriev01_S20' ...
          'retriev01_S21' 'retriev01_S22' 'retriev01_S23' 'retriev01_S24' ...
          'retriev01_S25' 'retriev01_S26' 'retriev01_S27' 'retriev01_S28' ...
          'retriev01_S29' 'retriev01_S30' 'retriev01_S31' 'retriev01_S33'};

% Load Data
disp(['Reading file ',matricesIn.name])
load([outDir, matricesIn.name]);
load([outDir, modelsIn.name]);

% Create necessary global variables and output structure
subCounter = 1;  %creates a counter to track S names through RDM matrix
outCSV = cell(1,4); %prep cell for long data, which will be converted to csv

% Loop through subjects
for iSub = 1:length(subjID)
    % get the right subject out of RDM - compares the current subject name subjID to RDM name 
    subStringLoc = strfind(RDMs(1).name,'retriev');
    currSubj = char(subjID(iSub));
    
    % Load .mat for curr subject
    load([regdir, currSubj, '.mat']);
    
    if mean(RDMs(1,subCounter,1).name(subStringLoc:(subStringLoc + 12)) == currSubj) ~= 1
        subCounter = subCounter + 1;  %subCounter is used to reference RDM structure 
    end 
    
    disp(['Generating mean RDM scores for ' currSubj])
    
    for iROI = 1:size(RDMs,1)
        currROI = strtok(RDMs(iROI).name); %extract name for current ROI
        currROI(regexp(currROI,'[-]'))=[]; %remove the '-' from currROI
          
        for iModel = 1:length(Models) %swaping iModel and iRun would reduce
                                      %the number of loads of RDMs and increase speed 
                                      %of the script, but it would not
                                      %allow for varying number of models
            
            currMod = logical(Models(iModel).RDM);
            %figure; imagesc(currMod); 
            
            for iRun = 1:size(RDMs,3)
                
                %Create mask for bad betas for this run
                currRunLog = (regs.run == iRun);
                goodBetas = double(regs.bad_betas(currRunLog) ~= 1);
                goodBetaMask = logical(goodBetas * goodBetas');
         
                %Load current RDM
                currRDM = RDMs(iROI, subCounter, iRun).RDM;
                
                %Apply model and beta mask to RDM and extract mean PS score         
                tempMean = mean(currRDM(currMod & goodBetaMask));
                %figure; imagesc(currMod & goodBetaMask);
                
                outCSV = [outCSV; {currSubj(end-1:end) currROI Models(iModel).name ...
                    tempMean}];
                
            end %iRun
           
            
        end %iModel
            
    end %iROI
   
end %iSub

% Save cell data as csv to Results in Box Sync folder
longData = num2cell(outCSV(2:end,:));
longData = cell2table(longData,'VariableNames', {'subject','roi','model','rsa_mean'});
writetable(longData,[savedir, final_csv_name])

disp(['Extraction complete! csv saved to ' savedir])