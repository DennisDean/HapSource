function [pulse_library pulse_library_is_loaded ] = ...
           load_pulse_library_from_file(pulse_library_fn, pulse_library_pn)
% load_pulse_library_from_file
% 
% pulse_library (cell array, struct entry for each subject):
%        pulse_cells: {1x16 cell}
%         num_pulses: 16
%     subject_id_val: 1
%     subject_id_str: {'acth_1'}
%          data_info: [1x1 struct]
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

% Program Constant
DEBUG = 1;

% Initialize return variables
old_pwd = cd;

% Load struct
cd(pulse_library_pn);
load(pulse_library_fn);

% Variable assignments
% Variable assignments
defined_variables = who;
pulse_library_is_loaded = is_var_defined(defined_variables, 'pulse_library');
if pulse_library_is_loaded == 0
    % initialize return variable to empy cell array
    pulse_library = {};
end

% Reset working directory
cd(old_pwd);

if pulse_library_is_loaded == 1
    % Determine number of subjects loaded
    num_subjects = length(pulse_library);
    
    % Echo summary to console   
    fprintf('--- Loading database\n    fn = %s\n--- Data for %d subjects loaded\n',...
            pulse_library_fn, num_subjects);
end