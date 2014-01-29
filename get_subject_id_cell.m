function subject_id_str = get_subject_id_cell(hormone_database)
% subject_id_str = get_subject_id_cell(hormone_database)
%
% function extrats subject Id for each entry in the database

% hormone_database struct:
%      description: 'Adler cortisol data'
%     subject_info: [1x28 struct]
%     subject_data: {28x1 cell}
%                T: 1440
%          delta_t: 10
%       conditions: {'sleep'  'wake'}
%           groups: {'C'  'F'}
%     num_subjects: 28
%
% subject infor id:
%   1x28 struct array with fields:
%     subject_descriptor_text
%     subject_id
%     group_id
%     data_class
%     data_type
%     cond_1
%     cond_1_start
%     cond_1_end
%     cond_1_datafile
%     cond_2
%     cond_2_start
%     cond_2_end
%     cond_2_datafile
%
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

% Load cell array
subject_info = hormone_database.subject_info;
subject_id_str = cell(hormone_database.num_subjects ,1);
for s = 1:hormone_database.num_subjects
     subject_id_str{s} = getfield(hormone_database.subject_info(s), ...
         'subject_descriptor_text');
end