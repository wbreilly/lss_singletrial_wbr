% hierachical clustering scratch and Infomap mtx reordering

roi_dist = corrMat;
%remova NaNs
for irow = 1:size(roi_dist,1)
    if isnan(roi_dist(irow,1))
        roi_dist(irow,:) = [];
    end
end

for icol = 1:size(roi_dist,2)
    if isnan(roi_dist(1,icol))
        roi_dist(:,icol) = [];
    end
end

roi_link = linkage(roi_dist,'average');
dendrogram(roi_link, 'ColorThreshold',.4)

%%

% info map cluster import 

fid = fopen('~/walter/netWork/infomap/output/nodes_n_clusters_2_18_18.txt');
data = textscan(fid,'%d%d%f','delimiter','\t');
idxs = cell2mat(data(1,1));

%%

% get vectorized RDMs from RDMs.RDM. The raw RDMs as it were.
raw_roi_mtxs = [];
for irow = 1:360
    raw_roi_mtxs(irow,:) = vectorizeRDM(RDMs(irow).RDM);
end

[a_sorted, a_order] = sort(idxs);
RDMs_bareVecs = raw_roi_mtxs(a_order,:);


%% WBR copied from RDMCorrMat.m
type = 'Spearman';
[nRDMs,ncols]=size(RDMs_bareVecs);
RDMs_cols = RDMs_bareVecs';

% RDMs_cols=permute(RDMs_bareVecs,[2 3 1]); % This is of size [utv nRDMs (1)]
% For each pair of RDMs, ignore missing data only for this pair of RDMs
% (unlike just using corr, which would ignore it if ANY RDM had missing
% data at this point).
%corrMat=corrcoef(RDMs_cols)
corrMat = [];
if isequal(type,'Kendall_taua')
    for RDMI1 = 1:nRDMs
        for RDMI2 = 1 : nRDMs
            corrMat(RDMI1,RDMI2)=rankCorr_Kendall_taua(RDMs_cols(:,RDMI1), RDMs_cols(:,RDMI2));
        end
    end
else
    for RDMI1 = 1:nRDMs
        for RDMI2 = 1 : nRDMs
            corrMat(RDMI1,RDMI2)=corr(RDMs_cols(:,RDMI1), RDMs_cols(:,RDMI2), 'type', type, 'rows', 'complete');
        end
    end
end
    
for RDMI1 = 1:nRDMs
	corrMat(RDMI1,RDMI1) = 1; % make the diagonal artificially one
end

