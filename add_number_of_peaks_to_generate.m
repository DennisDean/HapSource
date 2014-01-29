function interactive_table_struct_1 = add_number_of_peaks_to_generate...
    (interactive_table_struct_1, interactive_table_struct_2, ...
    database_1, database_2)
% add_number_of_peaks_to_generate
%
% Function adds columns to interactive table stucture to determine the
% number of peaks from interative 2 during acth pulse in interactive 1 and
% the ratio of each peak in interactive 1 with the immediately preceeding
% peak.
%
% interactive_table_struct_1
%
%         table: [326x9 double]
%     table_key: {1x9 cell}
%     data_type: 'Cortisol'
%         units: 'ug/dL'
%
% Notes:
% It would be clearer if zero time function was passed in.  Decided to keep
% it the same
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

% Program Constants for debugging
DEBUG = 0;
table_entry =5;
data_index = [2:10];

% Column id
SUBJECT_ID = 1;
DATA_TYPE = 2;
GROUP_ID = 3;
PULSE_START = 4;
PULSE_AMPLITUDE = 5;
RISE_WIDTH = 6;
DESCENT_AMPLITUDE = 7;
DESCENT_WIDTH = 8;
SLEEP_WAKE_STATE = 9;
PULSE_PEAK_TIME = 10;
DATABASE_SUBJECT_ID = 11;

% Mark entries where query returned nil
MARK_TO_REMOVE_ENTRY = -1;

% Summary functions
col_count = @(l)size(l,1);
last_index = @(l)l(end);

%-------------------------------------------- Add database lookup id to 
%-------------------------------------------- interactive lookup table id
% This was an oversight in the original specification of the interactive
% lookup table
%

% Define lookup table
subject_column = interactive_table_struct_1.table(:,SUBJECT_ID);
subject_ids = unique(subject_column);
database_subject_ids = [1:1:length(subject_ids)]';
subj_database_lookup = zeros(max(subject_ids),1);
subj_database_lookup(subject_ids)= database_subject_ids;

if DEBUG == 1
    [subject_ids , database_subject_ids]
end

% Define recursive function to perform look up and generate key
return_database_key = @(x)subj_database_lookup(x);
database_lookup_column = arrayfun(return_database_key, subject_column);

% Add column to interactive 1 table struct
interactive_table_struct_1.table = ...
    [interactive_table_struct_1.table,database_lookup_column];
interactive_table_struct_1.table_key{end+1} = 'Database Subject_ID';


% Add column to interactive 2 table struct
% Define lookup table
subject_column = interactive_table_struct_2.table(:,SUBJECT_ID);
subject_ids = unique(subject_column);
database_subject_ids = [1:1:length(subject_ids)]';
subj_database_lookup = zeros(max(subject_ids),1);
subj_database_lookup(subject_ids)= database_subject_ids;

% Define recursive function to perform look up and generate key
return_database_key = @(x)subj_database_lookup(x);
database_lookup_column = arrayfun(return_database_key, subject_column);

% ADD column to interactive 2 table struct
interactive_table_struct_2.table = ...
    [interactive_table_struct_2.table,database_lookup_column];
interactive_table_struct_2.table_key{end+1} = 'Database Subject_ID';

%-------------------------------------------- Define table 1 access functions
% identifying information
get_primary_subj_id = @(x)interactive_table_struct_1.table(x,DATABASE_SUBJECT_ID);

% peak information
get_primary_start_time = @(x)interactive_table_struct_1.table(x,PULSE_START);
get_primary_peak_time = @(x)get_primary_start_time(x)+interactive_table_struct_1.table(x,RISE_WIDTH);
get_primary_rise_amp = @(x)interactive_table_struct_1.table(x,PULSE_AMPLITUDE);
get_primary_rise_width = @(x)interactive_table_struct_1.table(x,RISE_WIDTH);

% Data access functions
get_primary_subj_time_series = @(e)database_1.subject_data{get_primary_subj_id(e)}.t;
get_primary_zero_subj_time_series = @(e)zero_time(get_primary_subj_time_series(e));
get_primary_subj_concentration_series = @(e)database_1.subject_data{get_primary_subj_id(e)}.Y;

get_precursor_subj_time_series = @(e)database_2.subject_data{get_primary_subj_id(e)}.t;
get_precursor_zero_subj_time_series = @(e)zero_time(get_precursor_subj_time_series(e));
get_precursor_subj_concentration_series = @(e)database_2.subject_data{get_primary_subj_id(e)}.Y;

% Data segment access functions
get_primary_subj_time_series_segment = ...
    @(e,x)database_1.subject_data{get_primary_subj_id(e)}.t(x);
get_primary_zero_subj_time_series_segment = ...
    @(e,x)database_1.subject_data{get_primary_subj_id(e)}.t(x)-database_1.subject_data{get_primary_subj_id(e)}.t(1);
get_primary_subj_concentration_series_segment = ...
    @(e,x)database_1.subject_data{get_primary_subj_id(e)}.Y(x);

get_precursor_subj_time_series_segment = ...
    @(e,x)database_2.subject_data{get_primary_subj_id(e)}.t(x);
get_precursor_zero_subj_time_series_segment = ...
    @(e,x)database_2.subject_data{get_primary_subj_id(e)}.t(x)-database_2.subject_data{get_primary_subj_id(e)}.t(1);
get_precursor_subj_concentration_series_segment = ...
    @(e,x)database_2.subject_data{get_primary_subj_id(e)}.Y(x);

if DEBUG == 1
    % check identifying information access
    primary_subj_id = get_primary_subj_id(table_entry)
    primary_start_time = get_primary_start_time(table_entry)
    primary_peak_time = get_primary_peak_time(table_entry)
    
    % check database access functions
    primary_subj_time_series = get_primary_subj_time_series(table_entry)
    primary_zero_subj_time_series = get_primary_zero_subj_time_series(table_entry)
    primary_subj_concentration_series = get_primary_subj_concentration_series(table_entry)
    
    fig_id_1 = figure();
    plot(primary_zero_subj_time_series, primary_subj_concentration_series)
    
    precursor_subj_time_series = ...
        get_precursor_subj_time_series(table_entry)
    precursor_zero_subj_time_series = ...
        get_precursor_zero_subj_time_series(table_entry)
    precursor_subj_concentration_series = ...
        get_precursor_subj_concentration_series(table_entry)

    fig_id_2 = figure();
    plot(precursor_zero_subj_time_series, precursor_subj_concentration_series)
    
    % check database segment access
    primary_subj_time_series_segment = ...
        get_primary_subj_time_series_segment(table_entry,data_index)
    primary_zero_subj_time_series_segment = ...
        get_primary_zero_subj_time_series_segment(table_entry,data_index)
    primary_subj_concentration_series_segment = ...
        get_primary_subj_concentration_series_segment(table_entry,data_index)
 
    fig_id_3 = figure();
    plot(primary_zero_subj_time_series_segment, primary_subj_concentration_series_segment)
    
    % check precursor database segment access
    precursor_subj_time_series = ...
        get_precursor_subj_time_series_segment(table_entry,data_index)
    precursor_zero_subj_time_series = ...
        get_precursor_zero_subj_time_series_segment(table_entry,data_index)
    precursor_subj_concentration_series_segment = ...
        get_precursor_subj_concentration_series_segment(table_entry,data_index)
    
    fig_id_4 = figure();
    plot(precursor_zero_subj_time_series, precursor_subj_concentration_series_segment)
end
%-------------------------------------------- Define Table 2 wide sub querries
% Define search (concurrent peaks during rise
mark_precursor_subj_col = @(e)get_primary_subj_id(e)==interactive_table_struct_2.table(:,DATABASE_SUBJECT_ID);
mark_precursor_peaks_prior_to_start = @(e)get_primary_start_time(e)>= interactive_table_struct_2.table(:,PULSE_PEAK_TIME);
mark_precursor_peaks_prior_to_peak = @(e)get_primary_peak_time(e)>= interactive_table_struct_2.table(:,PULSE_PEAK_TIME);
mark_precursor_peaks_following_start = @(e)get_primary_start_time(e)<=interactive_table_struct_2.table(:,PULSE_PEAK_TIME);

if DEBUG == 1
    precursor_subj_col = ...
        mark_precursor_subj_col(table_entry)
    precursor_peaks_prior_to_start = ...
        mark_precursor_peaks_prior_to_start(table_entry)
    precursor_peaks_prior_to_peak = ...
        mark_precursor_peaks_prior_to_peak(table_entry)
    precursor_peaks_following_start = ...
        mark_precursor_peaks_following_start(table_entry)
end
%-------------------------------------------- Define Table 2 peak level querries
find_precursor_peaks_preceeding_primary_peak = ...
    @(e)find(and(mark_precursor_subj_col(e), mark_precursor_peaks_prior_to_peak(e)));
find_precursor_peaks_preceeding_primary_start = ...
    @(e)find(and(mark_precursor_subj_col(e),mark_precursor_peaks_prior_to_start(e)));
find_precusor_peaks_concurrent_primary_peaks = ...
    @(e)find(and(and(mark_precursor_subj_col(e), ...
                     mark_precursor_peaks_prior_to_peak(e)),...
                     mark_precursor_peaks_following_start(e)));

if DEBUG == 1
    precursor_peaks_preceeding_primary_peak = ...
        find_precursor_peaks_preceeding_primary_peak(table_entry)
    precursor_peaks_preceeding_primary_start = ...
        find_precursor_peaks_preceeding_primary_start(table_entry)
    precusor_peaks_concurrent_primary_peaks = ...
        find_precusor_peaks_concurrent_primary_peaks(table_entry)
end


%-------------------------------------------- Peak Precursor Summary Level Querries
get_last_precursor_peak_time_preceeding_primary = @(e) ...
    interactive_table_struct_2.table(last_index(find_precursor_peaks_preceeding_primary_start(e)),PULSE_PEAK_TIME);
get_last_precursor_peak_time_diff_primary_peak = @(e)interactive_table_struct_1.table(e,PULSE_PEAK_TIME) - ...
    get_last_precursor_peak_time_preceeding_primary(e);
get_last_precursor_peak_amp = @(e) ...
    interactive_table_struct_2.table(last_index(find_precursor_peaks_preceeding_primary_peak(e)),PULSE_AMPLITUDE);
get_last_precursor_peak_scale_to_primary = @(e)...
    interactive_table_struct_1.table(e,PULSE_AMPLITUDE) / get_last_precursor_peak_amp(e);

if DEBUG == 1
    find_precursor_peaks_preceeding_primary_peak(table_entry)
    last_index(find_precursor_peaks_preceeding_primary_peak(table_entry))
    interactive_table_struct_2.table(last_index(find_precursor_peaks_preceeding_primary_peak(table_entry)),PULSE_PEAK_TIME)
    
    last_precursor_peak_time_preceeding_primary = ...
        get_last_precursor_peak_time_preceeding_primary(table_entry)
    last_precursor_peak_time_diff_primary_peak = ...
        get_last_precursor_peak_time_diff(table_entry)
    last_precursor_peak_amp = ...
        get_last_precursor_peak_amp(table_entry)
    last_precursor_peak_scale_to_primary = ...
        get_last_precursor_peak_scale(table_entry)
end

%-------------------------------------------- Define primary data level Querries
mark_primary_data_following_start = @(e)get_primary_start_time(e)<=get_primary_zero_subj_time_series(e);
mark_primary_data_prior_to_amplitude = @(e)get_primary_peak_time(e)>=get_primary_zero_subj_time_series(e);
mark_primary_data_during_rise = ...
    @(e)and(mark_primary_data_following_start(e),mark_primary_data_prior_to_amplitude(e));

get_primary_subj_time_series_segment = ...
    @(e,x)get_primary_subj_time_series_segment(e,x);
get_primary_zero_subj_time_series_segment = ...
    @(e,x)get_primary_zero_subj_time_series_segment(e,x);
get_primary_subj_concentration_series_segment = ...
    @(e,x)get_primary_subj_concentration_series_segment(e,x);

get_primary_times_during_rise = ...
    @(e)get_primary_subj_time_series_segment(e,mark_primary_data_during_rise(e));
get_primary_zero_times_during_rise = ...
    @(e)get_primary_zero_subj_time_series_segment(e,mark_primary_data_during_rise(e));
get_primary_concentrations_during_rise = ...
    @(e)get_primary_subj_concentration_series_segment(e,mark_primary_data_during_rise(e));

if DEBUG == 1
    primary_data_following_start = ...
        mark_primary_data_following_start(table_entry)
    primary_data_prior_to_amplitude = ...
        mark_primary_data_prior_to_amplitude(table_entry)
    primary_data_during_rise = ...
        mark_primary_data_during_rise(table_entry)
    
    primary_times_during_rise = ...
        get_primary_times_during_rise(table_entry)
    primary_zero_times_during_rise = ...
        get_primary_zero_times_during_rise(table_entry)
    primary_concentrations_during_rise = ...
        get_primary_concentrations_during_rise(table_entry)
    
    figure()
    plot(primary_zero_times_during_rise, primary_concentrations_during_rise)
end

%-------------------------------------------- Define precursor data level Querries
mark_precursor_data_following_start = @(e)get_primary_start_time(e) <= get_precursor_zero_subj_time_series(e);
mark_precursor_data_prior_to_amplitude = @(e)get_primary_peak_time(e) >= get_precursor_zero_subj_time_series(e);
mark_precursor_data_during_rise = ...
    @(e)and(get_primary_start_time(e) <= get_precursor_zero_subj_time_series(e),...
            get_primary_peak_time(e) >= get_precursor_zero_subj_time_series(e));

get_precursor_times_during_rise = ...
    @(e)get_precursor_subj_time_series_segment(e,mark_precursor_data_during_rise(e));
get_precursor_zero_times_during_rise = ...
    @(e)get_precursor_zero_subj_time_series_segment(e,mark_precursor_data_during_rise(e));
get_precursor_concentrations_during_rise = ...
    @(e)get_precursor_subj_concentration_series_segment(e,mark_precursor_data_during_rise(e));

if DEBUG == 1
    mark_precursor_data_following_start = mark_precursor_data_following_start(table_entry)
    mark_precursor_data_prior_to_amplitude = mark_precursor_data_prior_to_amplitude(table_entry)
    mark_precursor_data_during_rise = mark_precursor_data_during_rise(table_entry)

    get_precursor_times_during_rise = get_precursor_times_during_rise(table_entry)
    get_precursor_zero_times_during_rise = get_precursor_zero_times_during_rise(table_entry)
    get_precursor_concentrations_during_rise = get_precursor_concentrations_during_rise(table_entry)
    
    figure()
    plot(primary_zero_times_during_rise, primary_concentrations_during_rise)
end

%-------------------------------------------- Define data level summary Querries
get_num_primary_peaks_in_rise = ...
    @(e)num_peaks_safe(get_primary_concentrations_during_rise(e));
get_num_precursor_peaks_in_rise = ...
    @(e)num_peaks_safe(get_precursor_concentrations_during_rise(e));

if DEBUG == 1
    get_precursor_concentrations_during_rise(table_entry)
    
    num_primary_peaks_in_rise = get_num_primary_peaks_in_rise(table_entry)
    num_precursor_peaks_in_rise = get_num_precursor_peaks_in_rise(table_entry)    
end

%-------------------------------------------- Prepare to search for peaks
num_pulses = length(interactive_table_struct_1.table(:,DATABASE_SUBJECT_ID));

% Allocate Memory
last_precursor_peak_preceeding_start_diff = ones(num_pulses,1)*MARK_TO_REMOVE_ENTRY;
last_precursor_peak_preceeding_start_scale = ones(num_pulses,1)*MARK_TO_REMOVE_ENTRY;
num_precursor_peaks_during_primary_rise = ones(num_pulses,1)*MARK_TO_REMOVE_ENTRY;
num_local_precursor_max_during_primary_rise = ones(num_pulses,1)*MARK_TO_REMOVE_ENTRY;
num_local_primary_max_during_primary_rise = ones(num_pulses,1)*MARK_TO_REMOVE_ENTRY;

% Process each peak in pulse table
for p = 1:num_pulses
    
    if DEBUG == 1
        fprintf('--- (%d)\n',p);
    end
    
    % check that a vallid rise has been selected
    primary_rise_amp = get_primary_rise_amp(p);
    primary_rise_width = get_primary_rise_width(p);
    
    if primary_rise_amp*primary_rise_width ~=0
        % Find precursor peak information in library 2 relative to the current
        % primary peak
        precursor_peaks_preceeding_primary_start = ...
            find_precursor_peaks_preceeding_primary_start(p);
        precusor_peaks_concurrent_primary_peaks = ...
            find_precusor_peaks_concurrent_primary_peaks(p);
        
        % If peaks from library 2 exist prior to start of pulse in library,
        % (1)Compute difference in time from peak in library 2 prior to peak
        %    in library 1.
        % (2)Computer relative scale of peaks from library 2 and library 1.
        if isempty(precursor_peaks_preceeding_primary_start)==0
            last_precursor_peak_preceeding_start_diff(p) = ...
                get_primary_peak_time(p) - get_last_precursor_peak_time_preceeding_primary(p);
            last_precursor_peak_preceeding_start_scale(p) = ...
                get_last_precursor_peak_scale_to_primary(p);
            
            if DEBUG >= 2
               %subject_ids
               fprintf('%d, %d, %.2f, %.2f, %.2f, %.2f, %.2f\n',...
                   p, subject_ids(get_primary_subj_id(p)), primary_rise_amp, primary_rise_width/60, get_primary_peak_time(p)/60, ...
                   get_last_precursor_peak_time_preceeding_primary(p)/60, last_precursor_peak_preceeding_start_diff(p)/60);

            end
            
        else
            last_precursor_peak_preceeding_start_diff(p) = MARK_TO_REMOVE_ENTRY;
            last_precursor_peak_preceeding_start_scale(p) = MARK_TO_REMOVE_ENTRY;
        end
        
        % (3) Add the number of peaks from library 2 during the rise of the pulse
        % in library 1
        if isempty(precusor_peaks_concurrent_primary_peaks)==0
            num_precursor_peaks_during_primary_rise(p) = ...
                col_count(precusor_peaks_concurrent_primary_peaks);
        else
            num_precursor_peaks_during_primary_rise(p) = 0;
        end
        
        % (4) Number of local primary peaks during rise
        num_local_primary_max_during_primary_rise(p) = get_num_primary_peaks_in_rise(p);
        
        % (5) Number of local precursor peaks during rise
        num_local_precursor_max_during_primary_rise(p) = get_num_precursor_peaks_in_rise(p);
    else
        % not a vallid rise
        last_precursor_peak_preceeding_start_diff(p)   = MARK_TO_REMOVE_ENTRY;
        last_precursor_peak_preceeding_start_scale(p)  = MARK_TO_REMOVE_ENTRY;
        num_precursor_peaks_during_primary_rise(p)     = MARK_TO_REMOVE_ENTRY;
        num_local_primary_max_during_primary_rise(p)   = MARK_TO_REMOVE_ENTRY;
        num_local_precursor_max_during_primary_rise(p) = MARK_TO_REMOVE_ENTRY;
    end
end

% create table addendum
table_add = [ last_precursor_peak_preceeding_start_diff, ... 
              last_precursor_peak_preceeding_start_scale, ...
              num_precursor_peaks_during_primary_rise, ...
              num_local_primary_max_during_primary_rise, ...
              num_local_precursor_max_during_primary_rise];
label_add = { 'last precursor peak preceeding start diff', ...
              'last precursor peak preceeding_start scale', ...
              'num precursor peaks during_primary rise', ...
              'num local primary max during primary rise', ...
              'num local precursor max_during_primary rise'};

% return
num_table_entries = length(interactive_table_struct_1.table_key);
interactive_table_struct_1.table = ...
    [interactive_table_struct_1.table, table_add];
for c = num_table_entries+1:num_table_entries+length(label_add)
    interactive_table_struct_1.table_key{c} = ...
        label_add{c-num_table_entries};
end
