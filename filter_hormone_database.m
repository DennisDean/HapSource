function [hormone_database_1r, hormone_database_2r ] = filter_hormone_database ...
           (hormone_database_1, hormone_database_2, overlaping_data)
% filter_hormone_database
%
% Redefines the functions to include only overlapping data as defined in
% the overlapping data.
%
% Revisions:
%  02-16-10 checked from plot_one
%
% File is part of the HAP analysis program
%
% The methods are described in detail in:
%
% Dean II, D. A. (2011) Integrating Formal Language Theory with Mathematical 
% Modeling to Solve Computational Issues in Sleep and Circadian Applications 
% [dissertation]. University of Massachusetts. 239 p.
%
%
% Informatician: Dennis A. Dean, II, Ph.D 
%
% Divison of Sleep Medicine
% Brigham and Women's Hospital
% Harvard Medical School
% 221 Longwood Ave
% Boston, MA  02149
%
% Release: 0.8 Beta
%
% Copyright © [2012] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%


% Get overlapping indexes
db_1_indexes = overlaping_data.db_1_indexes;
db_2_indexes = overlaping_data.db_2_indexes;

% Redefine hormone database 1
hormone_database_1r.description = hormone_database_1.description; 
hormone_database_1r.subject_info = hormone_database_1.subject_info(db_1_indexes);
for d = 1:length(db_1_indexes)
	hormone_database_1r.subject_data{d,1} = hormone_database_1.subject_data{db_1_indexes(d)};
end
hormone_database_1r.T = hormone_database_1.T;
hormone_database_1r.delta_t = hormone_database_1.delta_t;
hormone_database_1r.conditions = hormone_database_1.conditions;
hormone_database_1r.groups = hormone_database_1.groups;
hormone_database_1r.num_subjects = length(db_1_indexes);
hormone_database_1r.units = hormone_database_1.units;

% Redefine homone datbase 2
hormone_database_2r.description = hormone_database_2.description; 
hormone_database_2r.subject_info = hormone_database_2.subject_info(db_2_indexes);
for d = 1:length(db_2_indexes)
	hormone_database_2r.subject_data{d,1} = hormone_database_2.subject_data{db_2_indexes(d)};
end
hormone_database_2r.T = hormone_database_2.T;
hormone_database_2r.delta_t = hormone_database_2.delta_t;
hormone_database_2r.conditions = hormone_database_2.conditions;
hormone_database_2r.groups = hormone_database_2.groups;
hormone_database_2r.num_subjects = length(db_2_indexes);
hormone_database_2r.units = hormone_database_2.units;

% check if there are any other flags to add
if isfield(hormone_database_1,'plot_one')
    % for plot_oone to be specified, the data has to already be filtered.
    % code just passes data along
    hormone_database_1r.plot_one = hormone_database_1.plot_one;
end