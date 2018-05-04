% make 15x5 15 matrices

idx = {'p1r1' 'p1r2' 'p1r3' 'p2r1' 'p2r2' 'p2r3' 'p3r1' 'p3r2' 'p3r3' 'p4r1' 'p4r2' 'p4r3' 'p5r1' 'p5r2' 'p5r3'};

mtx = {};
for i = 1:15
    for j = 1:15
        mtx(i,j) = cellstr(strcat(idx{j},'XX', idx{i}));
    end
end

%initiate
all_exclude = logical(zeros(15,15));
% exclude same run comparisons
for irun = 1:3
    target = sprintf('p.r%dXXp.r%d',irun,irun);
    exclude = regexp(mtx, target);
    exclude_idxs = ~cellfun(@isempty,exclude);
    all_exclude = logical(all_exclude + exclude_idxs);
end % end irun
same_run_idxs = all_exclude;

%initiate
all_exclude = logical(zeros(15,15));
%exclude same position comparisons
for ipos = 1:5
    target = sprintf('p%dr.XXp%dr.',ipos,ipos);
    exclude = regexp(mtx, target);
    exclude_idxs = ~cellfun(@isempty,exclude);
    all_exclude = logical(all_exclude + exclude_idxs);
end %end ipos
same_pos_idxs = all_exclude;

% add the the same run and same pos mask
all_same_idxs = logical(same_pos_idxs + same_run_idxs);





allmatches = zeros(15);
for irun = [2 3]
    target = sprintf('p1r1XXp5r%d',irun);
    matches_r1 = regexp(mtx, target);
    empty = cellfun('isempty',matches_r1);
    matches_r1(empty) = {0};
    matches_r1 = cell2mat(matches_r1);
    keyboard
    allmatches = allmatches + matches_r1;
end







matches_last = regexp(mtx, 'p.r.XXp1r.');
empty = cellfun('isempty',matches_last);
matches_first(empty) = {0};


