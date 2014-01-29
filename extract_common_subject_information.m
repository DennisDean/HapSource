function [dblet dblet_name] = extract_subject_information ...
                     (subj_index, hormone_database_1, hormone_database_2)
%extract_common_subject_information function returns a single subject data
%   the goal is to create detailed structures that can be passed modelig
%   structures.
%
% Hormone Database:
%      description: 'Adler cortisol data'
%     subject_info: [1x28 struct]
%     subject_data: {28x1 cell}
%                T: 1440 (Data to include)
%          delta_t: 10
%       conditions: {'sleep'  'wake'}
%           groups: {'C'  'F'}
%     num_subjects: 28
%            units: 'ug/dL'
%         plot_one: 1
%
% Subject Info:
%     subject_descriptor_text: 'cort_1'
%                  subject_id: 1
%                    group_id: 'F'
%                  data_class: 'Hormone'
%                   data_type: 'Cortisol'
%                      cond_1: 'sleep'
%                cond_1_start: 0
%                  cond_1_end: 480
%             cond_1_datafile: 'CORTAD01.2'
%                      cond_2: 'wake'
%                cond_2_start: 480
%                  cond_2_end: 1440
%             cond_2_datafile: 'CORTAD01.3'
%                       units: 'ug/dL'
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

% Program Constants
DEBUG_FLAG = 0;

% Copy information from first database into dblet 1
dblet.description_1 = hormone_database_1.description;
subject_info_1 =  hormone_database_1.subject_info(subj_index);
dblet.subject_info_1 =  subject_info_1;

dblet.subject_data_1 =  hormone_database_1.subject_data{subj_index};
dblet.T_1 =  hormone_database_1.T;
dblet.delta_t_1 =  hormone_database_1.delta_t;
dblet.conditions_1 =  hormone_database_1.conditions;
dblet.groups_1 =  hormone_database_1.groups;
dblet.num_subjects_1 =  hormone_database_1.num_subjects;
dblet.units_1 =  hormone_database_1.units;

% Copy infomration from second database into dblet 1
dblet.description_2 = hormone_database_2.description;
dblet.subject_info_2 =  hormone_database_2.subject_info(subj_index);
dblet.subject_data_2 =  hormone_database_2.subject_data{subj_index};
dblet.T_2 =  hormone_database_2.T;
dblet.delta_t_2 =  hormone_database_2.delta_t;
dblet.conditions_2 =  hormone_database_2.conditions;
dblet.groups_2 =  hormone_database_2.groups;
dblet.num_subjects_2 =  hormone_database_2.num_subjects;
dblet.units_2 =  hormone_database_2.units;
        
% Echo status to console during DEBUG
if DEBUG_FLAG == 1
    dblet.subject_info_1.subject_id
    dblet.subject_info_2.subject_id
end

% create dblet name
dblet.fn = lower( strcat('dblet_',dblet.subject_info_1.data_type,...
                         '_',...
                         dblet.subject_info_2.data_type,...
                         '_',...
                         dblet.subject_info_2.group_id,...
                         '_',...
                         num2str(dblet.subject_info_2.subject_id)));
              

end

