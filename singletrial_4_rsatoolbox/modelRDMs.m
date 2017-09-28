%  modelRDMs is a user-editable function which specifies the models which
%  brain-region RDMs should be compared to, and which specifies which kinds of
%  analysis should be performed.
%
%  Models should be stored in the "Models" struct as a single field labeled
%  with the model's name (use underscores in stead of spaces).
%  
%  Cai Wingfield 11-2009

function Models = modelRDMs_searchlight()

Models = struct();
baseMod = zeros(45);

Models.control = baseMod;

% Models.intact = ones(18);
% 
% Models.intact = [Models.intact; zeros(27,18)]; 
% addzeros = zeros(45,27);
% Models.intact(:,19:45) = addzeros;





% Models.RP_rel_cyc1 = baseMod;
% Models.RP_rel_cyc1(13:15,1:3) = [1 0 0
%                                  0 1 0
%                                  0 0 1];

end