function pulse_plot = ...
   create_pulse_plot_structure ...
           (hormone_database, pulse_database, subject_id_val, pulse_id_val)
% create_pulse_plot_structure
%
% Function takes a pulse database, subject_id_val, and a pulse_id_val to
% extract appropriate information for plotting data.
% 
% Pulse Library cell entry
%
%        pulse_cells: {[1x1 struct]  [1x1 struct]  [1x1 struct] ....
%            num_pulses: [1x1 double]
%     subject_id_val: [1x1 double]
%     subject_id_str: {'GH_1'}
%          data_info: [1x1 struct]
%
% % pulse_cells entry (cell array of pulse structure)
%       pt1: [10 13]
%      idx1: 2
%       pt2: [20 19.9000]
%      idx2: 3
%       pt3: [40 13.5000]
%      idx3: 5
%        w1: 10
%        h1: 6.9000
%        w2: 20
%        h2: 6.4000
%     rect1: [10 13 10 6.9000]
%     rect2: [1x4 double]
%
% Pulse Struct
%     t: [100x1 int32]
%     Y: [100x1 double]
%
% Hormone Database
%           description: 'Adler ACTH data'
%          subject_info: [1x22 struct]
%          subject_data: {22x1 cell}
%                     T: 1440
%               delta_t: 10
%            conditions: {'sleep'  'wake'}
%                groups: {'C'  'F'}
%          num_subjects: 22
%     upper_left_corner: [63.4000 55.3385]
% 
% Subject info structure
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

% Program constants
DEBUG = 0;

if DEBUG == 1
    fprintf('Entering ''create_pulse_plot_structure(subject = %d, pulse = %d''\n',subject_id_val,pulse_id_val)      
end

% The pulse entry value
pulse_library_cell_entry = pulse_database{subject_id_val};
subject_id_str = pulse_library_cell_entry.subject_id_str{1};
data_info = pulse_library_cell_entry.data_info;

% GEt start and stop of pulse. This code fixes a bug in the marking program
% which should have already selected the appropriate text.
pulse_cell = pulse_library_cell_entry.pulse_cells{pulse_id_val};
pt1 = pulse_cell.pt1; % pulse start
pt2 = pulse_cell.pt2; % pulse peak
pt3 = pulse_cell.pt3; % pulse end

% Get appropriate indexes
pulse_indexes = find(and(pt1(1) <= data_info.t,pt3(1) >= data_info.t));

pulse_plot.subject_id_str = subject_id_str;
pulse_plot.t = data_info.t(pulse_indexes);
pulse_plot.Y = data_info.Y(pulse_indexes);
pulse_plot.pulse_id_val = pulse_id_val;

% Get group id from database
subject_info = hormone_database.subject_info;
subject_info = subject_info(subject_id_val);
pulse_plot.group_id = subject_info.group_id;
pulse_plot.sleep_start = subject_info.cond_1_start;
pulse_plot.sleep_end = subject_info.cond_1_end;

% Add selected points to plot structure
pulse_plot.pt1 = pt1; % pulse start
pulse_plot.pt2 = pt2; % pulse peak
pulse_plot.pt3 = pt3; % pulse end

if isfield(hormone_database,'upper_left_corner')
    pulse_plot.upper_left_corner = hormone_database.upper_left_corner;   
end

if isfield(hormone_database,'grp')
    pulse_plot.grp = hormone_database.grp;   
end

