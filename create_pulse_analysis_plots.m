function fig_ids = create_pulse_analysis_plots ...
  (hormone_database_1, hormone_database_2,pulse_library_1, pulse_library_2,...
   upper_left_corner)
% create_pulse_analysis_plots
% 
% Generate analysis plots from manually extracted pulses. The function
% assumes 
%
% 
% interactive_table_struct:
%     interactive_table.table
%     interactive_table.table_key 
%     interactive_table.data_type
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

% Create interactive display tables
interactive_table_struct_1 = create_interactive_amplitude_plot_table...
                               (hormone_database_1,pulse_library_1, 1);
interactive_table_struct_2 = create_interactive_amplitude_plot_table...
                               (hormone_database_2,pulse_library_2, 2);
                           
% Plot overall histograms
fig_info_1 = plot_histogram_from_inter_table(interactive_table_struct_1,upper_left_corner);
fig_info_2 = plot_histogram_from_inter_table(interactive_table_struct_2,upper_left_corner);

% Create XY Plots
fig_info_3 = plot_xy_from_inter_table(interactive_table_struct_1,upper_left_corner);
fig_info_4 = plot_xy_from_inter_table(interactive_table_struct_2,upper_left_corner);

% Define output argument
fig_ids = [fig_info_1.fig_id_hist;fig_info_2.fig_id_hist;...
           fig_info_3.fig_id_hist;fig_info_4.fig_id_hist];
summary_info = [fig_info_1.fig_fns;fig_info_2.fig_fns;...
                fig_info_3.fig_fns;fig_info_4.fig_fns];

%---------------------------------
% create save structure
save_fig_struct.fig_description = 'amp_anlaysis_';
save_fig_struct.fig_ids = fig_ids;
save_fig_struct.pn = cd;
save_fig_struct.summary_info = summary_info;

% Save summary figures
figure_fn = save_summary_figures(save_fig_struct);
