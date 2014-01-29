function [subject_id_str num_pulses_by_subject] = get_subject_id_from_pulse_library(pulse_library)
% get_subject_id_from_pulse_library
%
% Function scans the pulse library database and returns the list of the 
% subject IDs.  Since multiple subject entries are expected, the number of 
% subjects for each subject is also collected.  This information is returned 
% and use as part of the graphical interface.  
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


% get subject strings
get_subject_id_F = @(struct_x)getfield(struct_x, 'subject_id_str');
subject_id_str = cellfun(get_subject_id_F,pulse_library);

% get number of pulses
get_subject_id_F = @(struct_x)getfield(struct_x, 'num_pulses');
num_pulses_by_subject = cellfun(get_subject_id_F,pulse_library);
