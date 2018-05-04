function betas = betaCorrespondence()
%
%  betaCorrespondence.m is a simple function which should combine
%  three things: 
%  - preBeta:	a string which is at the start of each file
%  containing a beta image
%  - betas:	a struct indexed by (session, condition) containing a string 
%  unique to each beta image
%  - postBeta:	a string which is at the end of each file containing a 
%  beta image, not containing the file .suffix
% 
%  use "[[subjectName]]" as a placeholder for the subject's name as found
%  in userOptions.subjectNames if necessary For example, in an experment
%  where the data from subject1 (subject1 name)  is saved in the format:
%  subject1Name_session1_condition1_experiment1.img and similarly for the
%  other conditions, one could use this function to define a general
%  mapping from experimental conditions to the path where the brain
%  responses are stored. If the paths are defined for a general subject,
%  the term [[subjectName]] would be iteratively replaced by the subject
%  names as defined by userOptions.subjectNames.
% 
%  note that this function could be replaced by an explicit mapping from
%  experimental conditions and sessions to data paths.
% 
%  Cai Wingfield 1-2010
%__________________________________________________________________________
% Copyright (C) 2010 Medical Research Council

% dir = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/getbetas_native_4_26_18/s001/SVDP_beta_4_rsa';
dir = '/Users/wbr/walter/fmri/sms_scan_analyses/data_for_spm/getbetas_native_4_26_18/s001/beta_4_rsa_singletrial';
x = spm_select('ExtFPListRec', dir, '^*\.nii');
% need to remove first beta, a duplicate, if using non-resliced betas
% x = x(2:end,:);



for i = 1:size(x,1)
    [q w e] = fileparts(x(i,:));
    betas(1,i).identifier = w;
    
end


preBeta = '';
postBeta = '.nii';
% betas(session, condition).identifier = ???




for session = 1:size(betas,1)
	for condition = 1:size(betas,2)
		betas(session,condition).identifier = [preBeta betas(session,condition).identifier postBeta];
	end%for
end%for

end %end function
