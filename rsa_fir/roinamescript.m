
% used to get just roi names no paths for glasser rois.
% used spm_select which gives you cell array with full paths. pasted that
% into textedit and used alt select to remove paths. selected all and excel
% pasted back into empty cell array in matlab, did below two steps and
% saved

for argh = 1:362
  z{argh} = strrep(z{argh},'.nii,1','');  
end

for argh = 1:362
  z{argh} = strrep(z{argh},' ','');  
end

for argh = 1:361
  z{argh} = strrep(z{argh},'-','_');  
end

