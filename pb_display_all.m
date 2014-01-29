function fig_ids = pb_display_all(varargin)
% pb_display_all
%
% Function to display all figures. Function based on code used to create
% summary figures.  this function generalizes the code so that it can be
% applied to any hormone database. the function does not save the the
% figures as has been done in the past.
%
% Revisions:
%   2009 07 16 Commented out the time
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

if nargin == 1
    hormone_database = varargin{1};
end



fprintf('--- creating figures for %s\n',hormone_database.description);
hormone_plot_spec.hormone_database = hormone_database;
hormone_plot_spec.hormone_database_str = '';
hormone_plot_spec.time_increment = 360;
hormone_plot_spec.max_display_time = 1440;
hormone_plot_spec.figure_description = hormone_database.description;
hormone_plot_spec.folder_name = '';
hormone_plot_spec.time_translation = @zero_time;
hormone_plot_spec.folder_pn = cd;
hormone_plot_spec.plot_scale_function = @set_fig_max_x_xtick;
fig_ids = specify_hormone_database_plots(hormone_plot_spec);

%
% % Program Constant
% hormone_database_str = hormone_database.description;
% TIME_INCREMENT = 360;
% MAX_DISPLAY_TIME = 1440;
% FIGURE_DESCRIPTION = '_first_24_hours';
% TIME_TRANSLATION = @zero_time;
%
%
% % Create plot and zero time
% % [fig_ids vs] = create_individual_hormone_plots(hormone_database, @zero_time);
% [fig_ids vs] = create_individual_hormone_w_sleep_plots(hormone_database, @zero_time);
%
% % Get max figure concentration value
% max_concentration = max(vs(:,4));
%
% % Get max time for each figure
% get_max_times_F = @(data_struct)max(zero_time(getfield(data_struct,'t')));
% max_time = max(cellfun(get_max_times_F,hormone_database.subject_data));
%
% % Create plot and zero time
% % [fig_ids vs] = create_individual_hormone_plots(hormone_database, @zero_time);
% max_struct.x = MAX_DISPLAY_TIME; max_struct.y = max_concentration;
% max_struct.x_tick_loc = 0:TIME_INCREMENT:MAX_DISPLAY_TIME;
% max_struct.x_tick_labels = [0:TIME_INCREMENT:MAX_DISPLAY_TIME]/60;
% [fig_ids vs] = create_individual_hormone_w_sleep_plots(hormone_database, @zero_time, max_struct, fig_ids);
% vs = rescale_figures(fig_ids, @set_fig_max_x_y_xtick, max_struct);
%
%
% % % Save figures as tiff
% % pn = cd;
% % fig_description = FIGURE_DESCRIPTION;
% % subject_info = hormone_database.subject_info;
% % figure_fn = save_figures(subject_info, fig_ids, pn, fig_description);
