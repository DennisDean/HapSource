function fig_info = plot_xy_from_inter_table_with_comparison ...
    (interactive_table_struct,interactive_table_struct_2, upper_left_corner)
% plot_xy_from_inter_table
%
% Function creates plots similar to analysis function except color coding
% is added to show features of the precursor hormone on the same graph.
% 
%       table: [446x8 double]
%     table_key: {1x8 cell}
%     data_type: 'ACTH'
%         units: 'pg/mL'
% 
% char(67) = C, char(70) = H
%
% Columns addes as part of comparison
% label_add = { 'last precursor peak preceeding start diff', ...
%               'last precursor peak preceeding_start scale', ...
%               'num precursor peaks during_primary rise', ...
%               'num local primary max during primary rise', ...
%               'num local precursor max_during_primary rise'}
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

%----------------------------------------------------------------------
% Program Constant
%

% Table column description
subject_id = 1;
data_type = 2;
GROUP_ID = 3;
PULSE_START = 4;
PULSE_AMPLITUDE = 5;
RISE_WIDTH = 6;
DECENT_AMPLITUDE = 7;
DECENT_WIDTH = 8;
SLEEP_WAKE_STATE = 9;
PULSE_PEAK_TIME = 10;
DATABASE_SUBJECT_ID = 11;
LAST_PRECURSOR_PEAK_PRECEDDING_START_DIFF = 12;
LAST_PRECURSOR_PEAK_PRECEEDING_START_SCALE = 13;
NUM_PRECURSOR_PEAKS_DURING_PRIMARY_RISE = 14;
NUM_LOCAL_PRIMARY_MAX_DURING_PRIMARY_RISE = 15;
NUM_LOCAL_PRECURSOR_MAX_DURING_PRIMARY_RISE = 16;

% table entry contstant
C_CHAR = 67;
H_CHAR = 70;
W_CHAR = 'w';
S_CHAR = 's';

% color descrotion
CONTROL_COLOR = [0 0 1]; % blue
FIBRYMYALGIA_COLOR = [1 0 1]; % magenta

% Hardcoded distribution limits
ACTH_Y_LIMIT = [0.1 50];
CORT_Y_LIMIT = [0.1 50];
ACTH_X_LIMIT = [0 140];
CORT_X_LIMIT = [0 250];    

% Get datatype information, set graph limits
data_type = interactive_table_struct.data_type;
if strcmp(data_type, 'Cortisol');
    Y_LIMIT = CORT_Y_LIMIT;
    X_LIMIT = CORT_X_LIMIT;
else
    Y_LIMIT = ACTH_Y_LIMIT;
    X_LIMIT = ACTH_X_LIMIT;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% delete me

% Create return variables
% redefine to 1 and let function redisplay automatically
fig_info.fig_fns = cell(1,1);
fig_info.fig_id_hist = zeros(1,1);

% Define data subsets
control_data = find(interactive_table_struct.table(:,GROUP_ID) == C_CHAR);
fibromyalgia_data = find(interactive_table_struct.table(:,GROUP_ID) == H_CHAR);
all_data = [1:length(interactive_table_struct.table(:,GROUP_ID))];

% color by group id
all_data_color = zeros(length(interactive_table_struct.table(:,1)),1);
all_data_color(control_data) = 'b';
all_data_color(fibromyalgia_data) = 'm';

% color by subject id
individual_subject_colors = generate_individual_subject_colors...
                 (interactive_table_struct.table(:,subject_id));
indiv_control_subject_colors = individual_subject_colors(control_data);           
indiv_fibryo_subject_colors = individual_subject_colors(fibromyalgia_data); 

% determine color by sleep-wake state
sleep_control_data = find(and(interactive_table_struct.table(control_data,GROUP_ID) == C_CHAR,...
                              interactive_table_struct.table(control_data,SLEEP_WAKE_STATE) == S_CHAR));
wake_control_data = find(and(interactive_table_struct.table(control_data,GROUP_ID) == C_CHAR,...
                              interactive_table_struct.table(control_data,SLEEP_WAKE_STATE) == W_CHAR));
sleep_fibromyalgia_data = find(and(interactive_table_struct.table(fibromyalgia_data,GROUP_ID) == H_CHAR,...
                              interactive_table_struct.table(fibromyalgia_data,SLEEP_WAKE_STATE) == S_CHAR));
wake_fibromyalgia_data = find(and(interactive_table_struct.table(fibromyalgia_data,GROUP_ID) == H_CHAR,...
                              interactive_table_struct.table(fibromyalgia_data,SLEEP_WAKE_STATE) == W_CHAR));
                              
% Set color by sleep wake state
sleep_wake_control_color = zeros(length(control_data),1);
sleep_wake_control_color(sleep_control_data) = 'k';
sleep_wake_control_color(wake_control_data) = 'g';

sleep_wake_fibromyalgia_color = zeros(length(fibromyalgia_data),1);
sleep_wake_fibromyalgia_color(sleep_fibromyalgia_data) = 'k';
sleep_wake_fibromyalgia_color(wake_fibromyalgia_data) = 'g';

% Get pharacokinetic proxies
amp_rise = interactive_table_struct.table(:,PULSE_AMPLITUDE);
amp_width = interactive_table_struct.table(:,RISE_WIDTH);
amp_decent = interactive_table_struct.table(:,DECENT_AMPLITUDE);
amp_decent_width = interactive_table_struct.table(:,DECENT_WIDTH);
amp_time = interactive_table_struct.table(:,PULSE_START)+interactive_table_struct.table(:,RISE_WIDTH);

%--------------------------------- Plot precursor factor histograms
% % Plot histogram 
% fig_info_1 = plot_histogram_from_inter_table_with_comparison ...
%                   (interactive_table_struct_1,upper_left_corner);
    
%--------------------------------- Plot Pulse Rise XP with precursor info

data_col = [ LAST_PRECURSOR_PEAK_PRECEDDING_START_DIFF, ...
             LAST_PRECURSOR_PEAK_PRECEEDING_START_SCALE, ...
             NUM_PRECURSOR_PEAKS_DURING_PRIMARY_RISE, ...
             NUM_LOCAL_PRIMARY_MAX_DURING_PRIMARY_RISE, ...
             NUM_LOCAL_PRECURSOR_MAX_DURING_PRIMARY_RISE];
data_descr = { 'ACTH Time Diff', ...
               'ACTH-F scale', ...
               'ACTH Peak', ...
               'F Local F max', ...
               'ACTH Local Max'};
selected_data = { all_data, all_data, all_data, all_data, all_data};
create_color_col = @(x)interactive_table_struct.table(:,x);
selected_color = cellfun(create_color_col, num2cell(data_col), 'UniformOutput', 0);

%% Create rise run plots
for f = 1:length(data_col)
    
    % Plot amp_width vs. amp_rise control only
    fig_descr = 'xy_rise_';
    plot_type = sprintf('Accumulation - %s',data_descr{f}) ;
    [fig_info.fig_id_hist(f) fig_info.fig_fns{f}] = rise_run_plots_w_comparison...
        (data_type,    amp_width,     amp_rise,   interactive_table_struct,...
        all_data, selected_color{f}, data_descr{f},  Y_LIMIT,  plot_type, X_LIMIT);
end

%% Create amplitude vs. time plots
% Change limit to plot y axis
X_LIMIT = [0 1440];  
Y_LIMIT = [0.1 50];
for f = 1:length(data_col)
    % Plot amp_width vs. amp_rise control only
    fig_descr = 'time_amplitude_';
    plot_type = sprintf('Accumulation - %s',data_descr{f}) ;
    [fig_info.fig_id_hist(f+length(data_col)) fig_info.fig_fns{f+length(data_col)}] = amp_time_plots_w_comparison...
        (data_type,    amp_time,     amp_rise,   interactive_table_struct,...
        all_data, selected_color{f}, data_descr{f},  Y_LIMIT,  plot_type, X_LIMIT);
end


    
% % Plot amp_width vs. amp_rise control only
% fig_descr = 'xy_decent_';
% plot_type = 'Clearance Proxy';
% [fig_info.fig_id_hist(2) fig_info.fig_fns{2}] = rise_run_plots...
%     (data_type,    amp_decent_width,     amp_decent,   interactive_table_struct,...
%      all_data, all_data_color, fig_descr,  Y_LIMIT,  plot_type, X_LIMIT);
% 
%  
% %--------------------------------- Plot control
% 
% % Plot amp_width vs. amp_rise control only
% fig_descr = 'xy_rise_control';
% plot_type = 'Secretion Proxy';
% [fig_info.fig_id_hist(3) fig_info.fig_fns{3}] = rise_run_plots...
%     (data_type,    amp_width,     amp_rise,   interactive_table_struct,...
%      control_data, CONTROL_COLOR, fig_descr,  Y_LIMIT,  plot_type, X_LIMIT);
% 
% 
% % Plot amp_width vs. amp_rise control only
% fig_descr = 'xy_decent_amp_control';
% plot_type = 'Clearance Proxy';
% [fig_info.fig_id_hist(4) fig_info.fig_fns{4}] = rise_run_plots...
%     (data_type,    amp_decent_width,     amp_decent,   interactive_table_struct,...
%      control_data, CONTROL_COLOR, fig_descr,  Y_LIMIT,  plot_type, X_LIMIT);
% 
% 
% %--------------------------------- Plot Fibromyalgia
% 
% % Plot amp_width vs. amp_rise fibrymyalgia only
% fig_descr = 'xy_rise_fibryo';
% plot_type = 'Secretion Proxy';
% [fig_info.fig_id_hist(5) fig_info.fig_fns{5}] = rise_run_plots...
%     (data_type,         amp_width,          amp_rise, interactive_table_struct,...
%      fibromyalgia_data, FIBRYMYALGIA_COLOR, fig_descr, Y_LIMIT,  plot_type, X_LIMIT);
% 
% 
% % Plot amp_width vs. amp_rise fibrymyalgia only
% fig_descr = 'xy_decent_width_fibryo';
% plot_type = 'Clearance Proxy';
% [fig_info.fig_id_hist(6) fig_info.fig_fns{6}] = rise_run_plots...
%     (data_type,         amp_decent_width,   amp_decent,  interactive_table_struct,...
%      fibromyalgia_data, FIBRYMYALGIA_COLOR, fig_descr, Y_LIMIT,  plot_type, X_LIMIT);
%  
%  %--------------------------------- Plot control individual colors
% 
% % Plot amp_width vs. amp_rise control only
% fig_descr = 'xy_rise_control_indiv';
% plot_type = 'Secretion Proxy';
% [fig_info.fig_id_hist(7) fig_info.fig_fns{7}] = rise_run_plots...
%     (data_type,    amp_width,     amp_rise,   interactive_table_struct,...
%      control_data, indiv_control_subject_colors, fig_descr,  Y_LIMIT,  plot_type, X_LIMIT);
% 
% % Plot amp_width vs. amp_rise control only
% fig_descr = 'xy_decent_amp_control_indiv';
% plot_type = 'Clearance Proxy';
% [fig_info.fig_id_hist(8) fig_info.fig_fns{8}] = rise_run_plots...
%     (data_type,    amp_decent_width,     amp_decent,   interactive_table_struct,...
%      control_data, indiv_control_subject_colors, fig_descr,  Y_LIMIT,  plot_type, X_LIMIT);
 
% %--------------------------------- Plot Fibromyalgia individual colors
% 
% % Plot amp_width vs. amp_rise fibrymyalgia only
% fig_descr = 'xy_rise_fibryo_indiv';
% plot_type = 'Secretion Proxy';
% [fig_info.fig_id_hist(9) fig_info.fig_fns{9}] = rise_run_plots...
%     (data_type,         amp_width,          amp_rise, interactive_table_struct,...
%      fibromyalgia_data, indiv_fibryo_subject_colors, fig_descr, Y_LIMIT,  plot_type, X_LIMIT);
% 
% 
% % Plot amp_width vs. amp_rise fibrymyalgia only
% fig_descr = 'xy_decent_width_fibryo_indiv';
% plot_type = 'Clearance Proxy';
% [fig_info.fig_id_hist(10) fig_info.fig_fns{10}] = rise_run_plots...
%     (data_type,         amp_decent_width,   amp_decent,  interactive_table_struct,...
%      fibromyalgia_data, indiv_fibryo_subject_colors, fig_descr, Y_LIMIT,  plot_type, X_LIMIT);
%  
% %--------------------------------- Plot control sleep wake colors
% 
% % Plot amp_width vs. amp_rise control only
% fig_descr = 'xy_rise_control_sleep_wake';
% plot_type = 'Secretion Proxy';
% [fig_info.fig_id_hist(11) fig_info.fig_fns{11}] = rise_run_plots...
%     (data_type,    amp_width,     amp_rise,   interactive_table_struct,...
%      control_data, sleep_wake_control_color, fig_descr,  Y_LIMIT,  plot_type, X_LIMIT);
% 
% % Plot amp_width vs. amp_rise control only
% fig_descr = 'xy_decent_amp_control_sleep_wake';
% plot_type = 'Clearance Proxy';
% [fig_info.fig_id_hist(12) fig_info.fig_fns{12}] = rise_run_plots...
%     (data_type,    amp_decent_width,     amp_decent,   interactive_table_struct,...
%      control_data, sleep_wake_control_color, fig_descr,  Y_LIMIT,  plot_type, X_LIMIT);
%  
% %--------------------------------- Plot Fibromyalgia sleep_wake colors
% 
% % Plot amp_width vs. amp_rise fibrymyalgia only
% fig_descr = 'xy_rise_fibryo_sleep_wake';
% plot_type = 'Secretion Proxy';
% [fig_info.fig_id_hist(13) fig_info.fig_fns{13}] = rise_run_plots...
%     (data_type,         amp_width,          amp_rise, interactive_table_struct,...
%      fibromyalgia_data, sleep_wake_fibromyalgia_color, fig_descr, Y_LIMIT,  plot_type, X_LIMIT);
% 
% 
% % Plot amp_width vs. amp_rise fibrymyalgia only
% fig_descr = 'xy_decent_width_fibryo_sleep_wake';
% plot_type = 'Clearance Proxy';
% [fig_info.fig_id_hist(14) fig_info.fig_fns{14}] = rise_run_plots...
%     (data_type,         amp_decent_width,   amp_decent,  interactive_table_struct,...
%      fibromyalgia_data, sleep_wake_fibromyalgia_color, fig_descr, Y_LIMIT,  plot_type, X_LIMIT);

%------------------------------------------Move figures
% Move figure to designated position
% % Need to fix at some point
% 
% for f = 1:size(fig_info.fig_id_hist,1)
%     set(fig_info.fig_id_hist(f),'Units','pixels');
%     pos = get(fig_info.fig_id_hist(f),'Position');
%     pos([1:2]) = upper_left_corner;
%     set(fig_info.fig_id_hist(f),'Position',pos);
% end
