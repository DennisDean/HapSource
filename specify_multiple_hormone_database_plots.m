function fig_ids = specify_multiple_hormone_database_plots(hormone_plot_spec)
% specify_hormone_database_plots
%
% Function is a generic function for displaing generic hormone data that is
% structured in a database format.
%
% A typical hormone database:
%
% The hormone description is as follows:
%         hormone_database.description = 'Adler cortisol data';
%         hormone_database.subject_info = subject_info;
%         hormone_database.subject_data = subject_data;
%         hormone_database.T = 1440;
%         hormone_database.delta_t = 10;
%         hormone_database.conditions = {'sleep' 'wake'};
%         hormone_database.groups = {'C' 'F'};
%         hormone_database.num_subjects = length(cort_file_info);
%
% Hormone plot specification:
%         hormone_plot_spec.hormone_database_str = 'adler_cortisol_database.mat';
%         hormone_plot_spec.time_increment = 360;
%         hormone_plot_spec.max_display_time = 2880;
%         hormone_plot_spec.figure_description = '_first_24_hours';
%         hormone_plot_spec.folder_name = '_first_24_hours';
%         hormone_plot_spec.time_translation = @zero_time;
%         hormone_plot_spec.folder_pn = 'cd';
%
% Revisons:
%   2009 07 17 commented out save all function. This allows for greater
%      flexibility of use in teh gui version.
%   2009 10 01 added check for user defined y scale.
%   2009 10 01 passed intire homone_plot_spec structure
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
hormone_database_str = hormone_plot_spec.hormone_database_str;
time_increment = hormone_plot_spec.time_increment;
max_display_time = hormone_plot_spec.max_display_time;
figure_description = hormone_plot_spec.figure_description;
folder_name = hormone_plot_spec.folder_name;
time_translation = hormone_plot_spec.time_translation;
folder_pn = hormone_plot_spec.folder_pn;

% Load hormone database structure
if isfield (hormone_plot_spec,'hormone_database')
    hormone_database = hormone_plot_spec.hormone_database;
elseif isfield (hormone_plot_spec,'hormone_database_1')
    hormone_database = hormone_plot_spec.hormone_database_1; 
    
    hormone_database_1 = hormone_plot_spec.hormone_database_1;
    hormone_database_2 = hormone_plot_spec.hormone_database_2; 
    overlaping_data = hormone_plot_spec.overlaping_data; 
    
    % get line styles if they exist
    line_styles = hormone_plot_spec.line_styles; 
    line_style_1 = line_styles{1};
    line_style_2 = line_styles{2};
else
    load(hormone_database_str)
    if ~isvarname('hormone_database')
        error('''hormone_database'' variable not found in database mat file');
        return
    end
end

% Check if y scaling is specified
if isfield(hormone_plot_spec, 'figure_limits')
   % yscaling is specified
      % [fig_ids vs] = create_individual_hormone_plots(hormone_database, @zero_time);
   [fig_ids vs ax1s ax2s] = create_multiple_individual_hormone_w_same_scale_sleep_plots...
    (hormone_database, hormone_database_2, hormone_plot_spec);   
else
   % Create plot and zero time
   % [fig_ids vs] = create_individual_hormone_plots(hormone_database, @zero_time);
   [fig_ids vs ax1s ax2s] = create_multiple_individual_hormone_w_sleep_plots...
    (hormone_database, hormone_database_2, time_translation);   
end


% Get max figure concentration value
max_concentration = max(vs(:,4));

% Get max time for each figure
get_max_times_F = @(data_struct)max(zero_time(getfield(data_struct,'t')));
max_time = max(cellfun(get_max_times_F,hormone_database.subject_data));

% Create plot and zero time
% [fig_ids vs] = create_individual_hormone_plots(hormone_database, @zero_time);
max_struct.x = max_display_time; max_struct.y = max_concentration;
max_struct.x_tick_loc = 0:time_increment:max_display_time;
max_struct.x_tick_labels = [0:time_increment:max_display_time]/60;

plot_scale_function = hormone_plot_spec.plot_scale_function;
if isfield(hormone_plot_spec, 'scale_y')
    if hormone_plot_spec.scale_y == 1
        max_y = max(vs(:,4));
        max_struct.max_y = max_y;
        max_struct.fig_ids = fig_ids;
        
        [fig_ids vs] = create_multiple_individual_hormone_w_sleep_plots...
            (hormone_database, time_translation, max_y, fig_ids);
    else
        % [fig_ids vs] = create_individual_hormone_w_sleep_plots(hormone_database, time_translation);
    end
else
    % [fig_ids vs] = create_individual_hormone_w_sleep_plots(hormone_database, time_translation);
end

% rescaling turns of factor
% vs = rescale_m_figures(fig_ids, ax1s, plot_scale_function, max_struct);

% % Save figures as tiff
% save_fig_struct.pn = folder_pn;
% save_fig_struct.fig_description = figure_description;
% save_fig_struct.subject_info = hormone_database.subject_info;
% save_fig_struct.folder_name = folder_name;
% save_fig_struct.fig_ids = fig_ids;
%
% figure_fn = save_figures(save_fig_struct);



