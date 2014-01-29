function overlaping_data = get_overlapping_data ...
              (hormone_database_1, hormone_database_2)
% get_overlapping_data
%
% Function determines which subjects are present in both subjects. The
% function returns the overlap and the corresponding indexes for the data.
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

% Data access functions
get_db1_subject_id_F = @(x)hormone_database_1.subject_info(x).subject_id;
get_db2_subject_id_F = @(x)hormone_database_2.subject_info(x).subject_id;
get_db1_subj_descr_txt_F = ...
    @(x)hormone_database_1.subject_info(x).subject_descriptor_text;
get_db2_subj_descr_txt_F = ...
    @(x)hormone_database_2.subject_info(x).subject_descriptor_text;

% Define database subjects
database_1_subjects = ...
    arrayfun(get_db1_subject_id_F, [1:hormone_database_1.num_subjects]);
database_2_subjects = ...
    arrayfun(get_db2_subject_id_F, [1:hormone_database_2.num_subjects]);

% Get overlapping dataset
[joint_subject_id db_1_indexes db_2_indexes ] = ...
     intersect(database_1_subjects, database_2_subjects);
 
% Get desription text
num_overlaping_subjects = length(joint_subject_id);
joint_subject_descriptor_text = cell(num_overlaping_subjects,1);
for s = 1:1:num_overlaping_subjects 
    joint_subject_descriptor_text{s} =  ...
        get_db1_subj_descr_txt_F(db_1_indexes(s));   
end

% Define return
overlaping_data.joint_subject_ids = joint_subject_id;
overlaping_data.db_1_indexes = db_1_indexes;    
overlaping_data.db_2_indexes = db_2_indexes;
overlaping_data.joint_subject_descriptor_text = ...
    joint_subject_descriptor_text;    
overlaping_data.num_overlaping_subjects = num_overlaping_subjects;