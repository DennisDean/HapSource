function pulse_panel_fig_id = create_hormone_pulse_panel_plot...
    (hormone_database, pulse_library, subject_id_val, ...
     pulse_id_values, display_width_val)
% create_hormone_pulse_plot
%
%
%
%        subject_id_str: 'GH_1'
%                     t: [100x1 int32]
%                     Y: [100x1 double]
%          pulse_id_val: 1
%              group_id: 'F'
%           sleep_start: 0
%             sleep_end: 480
%     upper_left_corner: [63.4000 55.3385]
%
% fig_id = create_hormone_subject_plot(hormone_plot)
%
% Function takes a hormone function sturcture and plots the data. If a
% sleep region is specified, it is idenitified in gray.
%
%     % Subject data (data ssumed in minutes)
%     hormone_plot.t = subject_data{s}.t;
%     hormone_plot.Y = subject_data{s}.Y;
%     hormone_plot.T = T;
%
%     % Identifying information
%     hormone_plot.subject_id = subject_info(s).subject_id;
%     hormone_plot.group_id = subject_info(s).group_id;
%     hormone_plot.data_type = subject_info(s).data_type;
%
%     % Specify sleep region
%     hormone_plot.sleep_start = hormone_databasecond_1_start';
%     hormone_plot.sleep_end = hormone_databasecond_1_end';
%
% Revisons:
%    2009 07 16 Problem has been revised so that the the program isn't
%    rescaled in y.  No needed for a pass analysis where we want to
%    determine individual differences.
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
DEBUG = 0;
num_cols = display_width_val;

% determine number of row
num_pulses = length(pulse_id_values);
num_rows = ceil(num_pulses/num_cols);

% Generate cell array of hormone plot structures
create_pulse_plot_structure_F = @(pulse_id)create_pulse_plot_structure...
   (hormone_database, pulse_library, subject_id_val, pulse_id);
pulse_plot_struct_cell_array = ...
   arrayfun(create_pulse_plot_structure_F,pulse_id_values);

% Add same figure id to pulse_plot_struct_cell_array
fig_id = figure('InvertHardcopy','off','Color',[1 1 1]);
add_fig_id_F = @(struct_x)setfield(struct_x,'fig_id',fig_id);
pulse_plot_struct_cell_array = ...
    arrayfun(add_fig_id_F, pulse_plot_struct_cell_array);

% Add approprate subplot for each figure 
add_fig_id_F = @(struct_x)setfield(struct_x,'sub_plot',1);
pulse_plot_struct_cell_array = ...
    arrayfun(add_fig_id_F, pulse_plot_struct_cell_array);

% Add approprate subplot for each figure 
add_num_cols_F = @(struct_x)setfield(struct_x,'num_cols',num_cols);
pulse_plot_struct_cell_array = ...
    arrayfun(add_num_cols_F, pulse_plot_struct_cell_array);

% Add approprate subplot for each figure 
add_num_rows_F = @(struct_x)setfield(struct_x,'num_rows',num_rows);
pulse_plot_struct_cell_array = ...
    arrayfun(add_num_rows_F, pulse_plot_struct_cell_array);

% Add approprate subplot for each figure 
add_num_rows_F = @(struct_x)setfield(struct_x,'grp',1);
pulse_plot_struct_cell_array = ...
    arrayfun(add_num_rows_F, pulse_plot_struct_cell_array);

% Generate plot
% [pulse_fig_id v] = create_hormone_pulse_plot(pulse_plot);
create_indv_plot_return_values = ...
   arrayfun(@create_hormone_pulse_plot,pulse_plot_struct_cell_array);

% Assign return value
pulse_panel_fig_id = fig_id;



