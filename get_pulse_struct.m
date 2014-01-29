function pulse_struct = get_pulse_struct(pulse_library, subject_id, pulse_id)
% get_pulse_struct
%
% Function returns pulse structure containing the data for a particular
% pulse
%
% cell_entry = 
% 
%        pulse_cells: {1x11 cell}
%         num_pulses: 11
%     subject_id_val: 1
%     subject_id_str: {'GH_1'}
%          data_info: [1x1 struct]
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

cell_entry = pulse_library{subject_id}
pulse_cells = cell_entry.pulse_cells{pulse_id}
data_info = cell_entry.data_info

pulse_struct ={}


