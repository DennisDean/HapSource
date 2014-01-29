function interactive_table = create_interactive_amplitude_plot_table...
                            (hormone_database,pulse_library, data_type_id)
% create_interactive_amplitude_plot_table
%
% Script merges a selection of the hormone database and the pulse library
% to create a table that can be used for interactive visualization.
% Function assumes libraries contain the same information
%
% 10-19 Add pulse peak time to file
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

% Get datbase summary information
get_num_subj_F = @(dbase)dbase.num_subjects;
get_num_pulses_F = @(lib,x)pulse_library{x}.num_pulses;
get_total_pulses_lib_F = @(x)pulse_library{x}.num_pulses;

% Get subject summary information
get_subject_id_F = @(x)hormone_database.subject_info(x).subject_id;
get_group_id_F = @(x)hormone_database.subject_info(x).group_id;
get_data_type_F = @(x)hormone_database.subject_info(x).data_type;
get_sleep_start_F = @(x)hormone_database.subject_info(x).cond_1_start;
get_sleep_end_F = @(x)hormone_database.subject_info(x).cond_1_end;

% Get pulse information function
get_amp_time_F = @(x,y)pulse_library{x}.pulse_cells{y}.pt1(2);
get_pulse_amp_F = @(x,y)pulse_library{x}.pulse_cells{y}.h1;
get_pulse_width_F = @(x,y)pulse_library{x}.pulse_cells{y}.w1;
get_decent_amp_F = @(x,y)pulse_library{x}.pulse_cells{y}.h2;
get_decent_width_F = @(x,y)pulse_library{x}.pulse_cells{y}.w2;

% Helper functions
col_ones_F = @(x)ones(x,1); % helper function

%% ------------------------------------------
% Extract infromation from hormone database
%------------------------------------------

% Get summary information
num_subj = get_num_subj_F(hormone_database);
data_type_str = get_data_type_F(1);
total_pulses_lib = arrayfun(get_total_pulses_lib_F,[1:num_subj])';

% Get descriptive table entry information
subject_ids = arrayfun(get_subject_id_F,[1:num_subj])';
data_type = ones(num_subj, 1)*data_type_id;
group_id = arrayfun(get_group_id_F,[1:num_subj])'; 

% Hormone descriptive information
subject_ids_tab_col = generate_column_id(total_pulses_lib, subject_ids);
data_type_tab_col = generate_column_id(total_pulses_lib, data_type);
group_id_tab_col = generate_column_id(total_pulses_lib, group_id);

%% ------------------------------------------
% Extract infromation from pulse database
%--------------------------------------------

%% Generate sleep column inorder to determine state
sleep_start = arrayfun(get_sleep_start_F,[1:num_subj])';
sleep_end = arrayfun(get_sleep_end_F,[1:num_subj])';

%% Allocate numeric information
total_num_pulses = sum(total_pulses_lib);
pulse_data = zeros(total_num_pulses, 5);
subject_pulse_end = cumsum(total_pulses_lib);
subject_pulse_start = [1; (subject_pulse_end(1:end-1)+1)];
sleep_state_data = zeros(total_num_pulses, 1)*'s';

% Get pulse information function
for s = 1:num_subj
    % Get subject information
    num_pulses = total_pulses_lib(s);
    
    % Generate subject specific function
    get_pulse_time_F   = @(x)pulse_library{s}.pulse_cells{x}.pt1(1);
    get_pulse_amp_F    = @(x)pulse_library{s}.pulse_cells{x}.h1;
    get_pulse_width_F  = @(x)pulse_library{s}.pulse_cells{x}.w1;
    get_decent_amp_F   = @(x)pulse_library{s}.pulse_cells{x}.h2;
    get_decent_width_F = @(x)pulse_library{s}.pulse_cells{x}.w2;
    
    % Generate pulse column
    pulse_data(subject_pulse_start(s):subject_pulse_end(s),1) = ...
        arrayfun(get_pulse_time_F, [1:num_pulses]);
    pulse_data(subject_pulse_start(s):subject_pulse_end(s),2) = ...
        arrayfun(get_pulse_amp_F, [1:num_pulses]);
    pulse_data(subject_pulse_start(s):subject_pulse_end(s),3) = ...
        arrayfun(get_pulse_width_F, [1:num_pulses]);
    pulse_data(subject_pulse_start(s):subject_pulse_end(s),4) = ...
        arrayfun(get_decent_amp_F, [1:num_pulses]);
    pulse_data(subject_pulse_start(s):subject_pulse_end(s),5) = ...
        arrayfun(get_decent_width_F, [1:num_pulses]);
    
    % Generate sleep column
    cur_sleep_state_data = zeros(num_pulses,1);
    pulse_start_time = arrayfun(get_pulse_time_F, [1:num_pulses]);
    wake_pulse_index = find(pulse_start_time > sleep_end(s));
    if length(wake_pulse_index) >= 1
        cur_sleep_state_data(wake_pulse_index) = 'w';
    end
    sleep_pulse_index = find(pulse_start_time <= sleep_end(s));
    if length(sleep_pulse_index) >= 1
        cur_sleep_state_data(sleep_pulse_index) = 's';
    end    
    sleep_state_data(subject_pulse_start(s):subject_pulse_end(s)) = ...
        cur_sleep_state_data;
end

%% ------------------------------------------
% Prepare output for result
%--------------------------------------------
pulse_peak_time = pulse_data(:,1) + pulse_data(:,3);
interactive_table.table = [subject_ids_tab_col, data_type_tab_col, group_id_tab_col, pulse_data, sleep_state_data, pulse_peak_time];
interactive_table.table_key = {'Subject ID','Data Type','Group ID',...
    'Pulse Start', 'Pulse Amplitude', 'Rise Width','Descent Amplitude', 'Descent Width', 'Sleep-Wake State', 'Pulse Peak Time'};
interactive_table.data_type = data_type_str;
interactive_table.units = hormone_database.units;







