function subject_result_summary_struct = ...
                          summarize_qualitatively(t,Y, fig_id,hormone_plot)
%summarize_qualitatively
%
% Function implement adaptive hierarchical paritioning algorithmn. The
% algorithm extract pulse features, generates figures, and summary tables.
% 
% 
%
%
% --- hormone_plot
%                              t: [215x1 int32]
%                              Y: [215x1 double]
%                              T: 1440
%                     subject_id: 23
%                 subject_id_str: 'cort_23'
%                   group_id_str: 'C'
%                  data_type_str: 'Cortisol'
%                    sleep_start: 0
%                      sleep_end: 480
%              upper_left_corner: [61.4000 76.8769]
%                     time_adj_F: @zero_time
%                      plot_type: 'Segmentation'
%     application_root_directory: [1x121 char]
%     segmentation_result_folder: 'Segmentation'
%    
% Original concept:
% -----------------
% function uses peak finding function to define a recursive definition of
% points that can be used to describe the qualitative features of a hormone
% pulse profile.
%
% The idea is to provide a way to find hormone profiles that have similar
% features and to use these features to guide model development and model
% fitting.
%
% Object oriented peak call
%   Properties:
%                              PEAK: 9
%                       PEAK_RISING: 8
%                    PEAK_DECENDING: 7
%                      VALLEY_RISNG: 6
%                  VALLEY_DECENDING: 5
%                        FLAT_START: 4
%                          FLAT_END: 3
%                     MISSING_START: 2
%                       MISSING_END: 1
%                          NO_LABEL: 0
%                                 Y: []
%                                 t: []
%                         peak_locs: [1x0 double]
%                       valley_locs: [1x0 double]
%                        peak_times: [1x0 double]
%                      valley_times: [1x0 double]
%                         peak_vals: [1x0 double]
%                       valley_vals: [1x0 double]
%                  peak_rising_locs: [1x0 double]
%           peak_rising_locs_exists: 0
%                 peak_rising_times: [1x0 double]
%                  peak_rising_vals: [1x0 double]
%              peak_descending_locs: [1x0 double]
%       peak_descending_locs_exists: 0
%             peak_descending_times: [1x0 double]
%              peak_descending_vals: [1x0 double]
%                valley_rising_locs: [1x0 double]
%         valley_rising_locs_exists: 0
%               valley_rising_times: [1x0 double]
%                valley_rising_vals: [1x0 double]
%            valley_descending_locs: [1x0 double]
%     valley_descending_locs_exists: 0
%           valley_descending_times: [1x0 double]
%            valley_descending_vals: [1x0 double]
%
%
% Revisons:
%    07/03/2012 In release 2012a, structure not defined outside of if block
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

% Program constants
THRESHOLD = 0;
DEBUG_FLAG = 0;
SAVE_FIGURE = 1;
ECHO_TO_CONCOLE = 1;
SUMMARY_FIG_STR = 's';

% Echo input to console
if DEBUG_FLAG == 1
    fprintf('--- hormone_plot\n');
    disp(hormone_plot);
end


% Echo status to console
fprintf('----------------------------------------------------------------- %s %d%s\n',...
    hormone_plot.data_type_str, hormone_plot.subject_id, ...
    hormone_plot.group_id_str);

% Replace Matlab function with object oriented form written for recursive
% analysis
hormone_peaks = getPeaks(t,Y );

% summarize output to cojnsole
Disp(hormone_peaks);fprintf('\n');

% Get peak information
pks = hormone_peaks.peak_vals;
ptimes = hormone_peaks.peak_times;

% Get valley information
vals = hormone_peaks.valley_vals;
vtimes = hormone_peaks.valley_times;

% Plot quality plot that includes missing datapoints, peak identification,
% and valley identification
%
% Plot data, peaks, and valleys
if or(strcmp(hormone_plot.plot_type, 'Quality'),...
      strcmp(hormone_plot.plot_type, 'Both'));
    fig_id = plot_peaks(hormone_peaks, fig_id);
end

% Plot segmentation
recursion_string_summary = [];  % 07/03/2012 Define structure
recursion_summary_results_struct_array = [];
if or(strcmp(hormone_plot.plot_type, 'Segmentation'),...
      strcmp(hormone_plot.plot_type, 'Both'));
    % fig_id = plot_peaks(hormone_peaks, fig_id);
    
    index = find(t<=1440);
    p = pulseSegmentation(t(index),Y(index));
    
    if DEBUG_FLAG == 1
        p.INTERACTIVE_FLAG = 1;
    end
    max_struct.x = 1440;
    max_struct.x_tick_loc = [0:360:max_struct.x];
    max_struct.x_tick_labels = {'0' '6' '12' '18' '24'};
    
    % Segment data
    % segmentation(p, max_struct, fig_id);
    % pulse_segment_struct = segmentation(p, max_struct, fig_id); 
    % Main output is a peak struct created by findPeak
    p.RECURSION_SUMMARY = 0; % plot peak summary
    [segment_results_return, pulse_segment_struct] = ...
                                     segmentation (p, max_struct, fig_id);                           
                                 
    % Process recursion results
    % Peak struct is processed recursively and used to creat the 
    % recursion_summary_results_struct_array which contains information
    % about verified peak-valley pairs which is created by
    % pulseSegmentation information.  A quick estimate of sectretion and
    % clearance rate is also provided.
    p.summarized_segmentation_output ( p, segment_results_return);
    recursion_summary_results_struct_array = ...
        p.summarized_segmentation_output ( p, segment_results_return); 
    
    if DEBUG_FLAG == 1
        save textPulse.mat recursion_summary_results_struct_array hormone_plot
    end
    
    % Plot segmentation feature results 
    % note: that xy plots are used to estimate the secretion and clearance 
    % parameters. The calculation of the clearance parameters is now done 
    % withing the segmentatio summary function.. 
    [segmentation_ouput_figs segmentation_output_fig_fns] = ...
        p.plot_segmentation_output ...
            ( p, recursion_summary_results_struct_array,...
              hormone_plot);

          
    % Recursion plots for pulse parameters derived from segmentation 
    % note: that xy plots are used to estimate the secretion and clearance 
    % parameters. The calculation of the clearance parameters is now done 
    % with the segmentation summary function.
    [recursion_ouput_figs recursion_output_fig_fns recursion_string_summary] = ...
        p.plot_pulse_parameter_recursion ...
            ( p, recursion_summary_results_struct_array,...
              hormone_plot);
          
    % Add identifier to start of file names for ease of summary
    % temporary fix - should use a different folder
    add_prefix_F = @(s)sprintf('%s_%s',SUMMARY_FIG_STR, s);
    recursion_output_fig_fns = cellfun(add_prefix_F, ...
                         recursion_output_fig_fns, 'UniformOutput', 0);

          
    % Collect output figs and filenames
    segmentation_ouput_figs = [segmentation_ouput_figs, recursion_ouput_figs];
    segmentation_output_fig_fns =[segmentation_output_fig_fns,recursion_output_fig_fns];
          
    % Save figures if requested
    if SAVE_FIGURE == 1
        % Echo writing status to console
        fprintf('--- Saving segmentation figures to disk\n');

        % Echo file names to screen
        if DEBUG_FLAG == 1
           % plot secretion, clearance, and interpulse interpulse results
           print_fn_F = @(fn)fprintf('%s\n',fn); 
           a = cellfun(print_fn_F, segmentation_output_fig_fns); 
           segmentation_ouput_figs    
           
           % plot feature results
           print_fn_F = @(fn)fprintf('%s\n',fn); 
           a = cellfun(print_fn_F, recursion_output_fig_fns); 
           recursion_ouput_figs
        end
        
        % Create save structure
        save_fig_struct = struct(...
          'application_root_dir',hormone_plot.application_root_directory,...
          'folder_name',hormone_plot.segmentation_result_folder, ...
          'figure_description','',...
          'subject_id',hormone_plot.subject_id,...
          'subject_id_str',hormone_plot.subject_id_str,...
          'group_id_str',hormone_plot.group_id_str,...
          'data_type_str',hormone_plot.data_type_str,...
          'subject_num',hormone_plot.subject_id,...
          'fig_ids',segmentation_ouput_figs);
         
        % save file
        save_hierarchical_figures(save_fig_struct, ...
            segmentation_output_fig_fns);
    end
end

% Define return summary structure
subject_result_summary_struct = struct(...
    'subject_id',hormone_plot.subject_id, ...
    'group_id_str',hormone_plot.group_id_str, ...
    'hormone_plot',hormone_plot, ...
    'recursion_string_summary', recursion_string_summary, ...
    'recursion_summary_results_struct_array', ...
              recursion_summary_results_struct_array);
end

