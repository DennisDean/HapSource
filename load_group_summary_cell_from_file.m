function [ partioning_cell_array_collection ...
           group_summary_file_is_loaded ] = ...
      load_group_summary_cell_from_file(group_summary_fn, group_summary_pn)
% load_group_summary_cell_from_file 
% Function loads cell array of results for each subject. Cell array
% contains a complete summary of hieararchially adaptive paritioining
% algorithmn for each individual.
%
% 
% partioning_cell_array_collection{1}
%                                 subject_id: 1
%                             summary_string: ''
%     recursion_summary_results_struct_array: [1x5 struct]
%
%
% partioning_cell_array_collection{1}.recursion_summary_results_struct_array
% 1x5 struct array with fields:
%     num_points
%     num_peaks
%     num_nadirs
%     rise_times
%     peak_times
%     valley_times
%     amplitudes
%     interpulse_intervals
%     rise_duration_sum
%     amplitudes_sum
%     interpulse_intervals_sum
%     are_peaks_and_valleys_proper
%     are_extended_peaks_and_valleys_proper
%     fall_times
%     amplitude_falls
%     rise_times_sum
%     fall_duration_sum
%     amplitude_falls_sum   
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
cd(group_summary_pn);
load(group_summary_fn);

% Variable assignments
is_var_f = @(x)strcmp(x,'partioning_cell_array_collection');
group_summary_file_is_loaded = sum(cellfun(is_var_f,who));
if group_summary_file_is_loaded == 0
    % initialize return variable to empy cell array
    partioning_cell_array_collection = {};
else
    partioning_cell_array_collection = partioning_cell_array_collection;
end

% Reset working directory
cd(old_pwd);

if group_summary_file_is_loaded == 1
    % Echo summary to console   
    fprintf('--- Loading group summary function\n    fn = %s, num subjects = %d\n',...
            group_summary_fn, length(group_summary_fn));
end