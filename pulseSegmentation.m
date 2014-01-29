classdef pulseSegmentation
% pulseSegmentation Class for partitioning a time series.
%   The program implements hierarhcally adaptive paritioning which is
%   used to identify hierarchially organized pulses. pulseSegmentation
%   relies on getPeaks to identify features in the data set for whic
%   to run recursively. 
%
% Revisions
%   2010-08-30 The two call to getPeak were revised to insure that the
%     features identified at the ends of the time series are included
%     in the recursion. This required reivsion of Get Peak
%   2010-09-20 Recurse on vallid peak-valley pair or extended
%     peak-valley pair.  Will use features added to Get Peak. We can
%     relax the requirement to recurse on less than three points.    
%   2010-09-21 Pass vallid peak-valley pairs up the chain for analysis
%   2012-07-03 Converted array to double explicily.
%
% Features to add:
%   1. Add summarize qualitatively to PulseSegmentation file
%   2. Create recursion level box plot of secretion rate, clearance
%      rate and interpulse interval
%   3. Compute interpulse interval for terminal recursion
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
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Properties
    %-------------------------------------------------------------- Private
    properties  (GetAccess='private',SetAccess='private')
        % Define algorithmn initial values
        MAX_RECURSION_LEVEL = 100;
        START_LINE_COLOR = [0 0 1];
        END_LINE_COLOR = [0 1 1];
        NUM_COLOR_LEVELS = 5;
        RECURSION_SUMMARY_DEFAULT = 1;
        
        % write latex to console        
        show_latex = 1;
        
        % default color map string, stored in root directory
        %   sleep_colormap_name = 'sleep_colormap_2';
        %   load (sleep_colormap_name);
        % original color map
        % temporal_color_map_str = 'sleep_colormap_2.mat'; 
        
        % Current figure colormap
        temporal_color_map_str = 'sleep_colormap_2.mat'; 
        recursion_marker_size = 125;
        jitter_scale = 0.33;
        marker_type_array = ...
                {'o','s','^','v','d','p','h','+','x','*','^','v','>','<'};
            
        % Color Map
        % 07/19/2012 Removed file loading of color map for release
        temporal_color_map_in = [...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0         0    1.0000];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
                 [0    0.4980         0];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000];...
            [1.0000    1.0000    1.0000]];
    
    end
    %--------------------------------------------------------------- Public
    properties
        % Peaks requires a time series of values.  Time is optionally
        % provided and is assumed to be in the form of [t Y]. If time is
        % not provided, t is automatically generated with an index value
        % for each time point.
        
        % Primary data
        Y
        t
        
        % Structure for returning sementation
        pulse_segment_struct = struct([]);
        max_recursion_level;
        
        % Summary figure - eventually will extend figure from getPeak
        fid
        num_color_levels
        
        % Control variables
        % Function Constants
        DEBUG_FLAG = 0;
        DISPLAY_START_FLAG = 1;
        DISPLAY_RECURSION_FLAG = 1;
        RECURSION_TRACKING_FLAG = 1;
        USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS = 1;
        INTERACTIVE_FLAG = 0;
        PAUSE_TIME = 2;
        RECURSION_SUMMARY = 0; 
        
        % Color Map
        temporal_color_map
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Methods
    %--------------------------------------------------------------- Public
    methods
        %------------------------------------------------------ constructor
        function obj = pulseSegmentation(varargin)
            % pulseSegmentation constructor is used to define the object.
            % If only column of data is added then t is automatically
            % generated. If two column data is entered the first column is
            % assigned to time and the second to Y. t and Y can also be
            % sent in separetly.
            %
            
            if nargin == 2
                % Process two columns
                obj.t = varargin{1};
                obj.Y = varargin{2};
            elseif nargin == 1
                % check single argument for 2 column array)
                if size(varargin{1},2) == 2
                    % two columns found
                    data = varargin{1};
                    obj.Y = data(:,2);
                    obj.t = data(:,1);
                elseif size(varargin{1},1)*size(varargin{1},2) == 1
                    % if value entered is an integer
                    num_points = varargin{1};
                    obj.Y = rand(num_points,1);
                    obj.t = [1:length(obj.Y)]';
                else
                    % process single columne
                    obj.Y = varargin{1};
                    obj.t = [1:length(obj.Y)]';
                end
            elseif nargin == 0
                obj.Y = rand(50,1);
                obj.t = [1:length(obj.Y)]';
            else
                fprintf('--- pulseSegmentation(Y))\n');
                fprintf('--- pulseSegmentation(t,Y)\n');
                error('function prototype not found');
            end
            
            % Initialize properties
            obj.fid = -1;
            obj.max_recursion_level = obj.MAX_RECURSION_LEVEL;
            obj.num_color_levels = obj.NUM_COLOR_LEVELS;
            obj.RECURSION_SUMMARY = obj.RECURSION_SUMMARY_DEFAULT;
            
            % Load colormap
            % 2012_07_19 removed loading code
            % sleep_colormap_name = obj.temporal_color_map_str;
        	% color_map = load (sleep_colormap_name);
            obj.temporal_color_map = obj.temporal_color_map_in;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Segment
        %----------------------------------------------------- segmentation
        function varargout = segmentation(varargin)
            % pulseSegmentation constructor is used to define the object.
            % If only column of data is added then t is automatically
            % generated. If two column data is entered the first column is
            % assigned to time and the second to Y. t and Y can also be
            % sent in separetly.
            %
            % Input 
            %     segmentation(obj)
            %     segmentation(obj, max_struct)
            %     segmentation(obj, max_struct, fig_id)
            %
            % Output
            %     segmentation (...)
            %          set up to plot results
            %     pulse_segment_struct = segmentation (...)
            %          returns last pulse_segment struct
            %     [segment_results_return pulse_segment_struct] = ...
            %                                          sementation (...)
            %          Returns cell array structure of results by recursion 
            %          level. Last pulse segment is included from for
            %          legacy.
            %
            
            % Function Constants
            DEBUG_FLAG = 0;
            fid = -1;
            
            % Proocess input
            if nargin == 1
                % process object and don't scale output
                obj = varargin{1};
                max_struct = [];
            elseif nargin == 2
                % process object and max_structure to scale input
                obj = varargin{1};
                max_struct = varargin{2};
            elseif nargin == 3
                % process object and max_structure to scale input
                obj = varargin{1};
                max_struct = varargin{2};
                fig_id = varargin{3};
            end
            
            if DEBUG_FLAG == 1
                obj
                max_struct
                fig_id  
            end
            
            % Define peak object
            % peak_obj = getPeaks(obj.t, obj.Y);
            % 
            peak_obj = getPeaks(obj.t, obj.Y, 0, 0);
            peak_struct = summarize(peak_obj);
            
            % Create figure to display if flag set appropraitely
            if  or(obj.DEBUG_FLAG == 1, obj.DISPLAY_START_FLAG==1)
                if nargin == 3
                    fid = plot_peaks(peak_obj, fig_id);
                else 
                    fid = plot_peaks(peak_obj);
                end
                obj.fid = fid;
                
                if ~isempty(max_struct)
                    % scale acording to structure values
                    v = set_fig_max_x_xtick(fid, max_struct);
                end
            end
            
            % Summarize peaks and nadirs of selected points
            if obj.RECURSION_SUMMARY == 1
                peak_nadir_summary(peak_obj); 
            end
            
            % Create line colors to plot
            num_color_levels = obj.num_color_levels;
            line_colors = [ ...
                flipud(ones(num_color_levels,1).*[0:1/(num_color_levels-1):1]'),...
                ones(num_color_levels,1).*[0:1/(num_color_levels-1):1]', ...
                ones(num_color_levels,1)];
            
            % Prepare structure for recursive segmentation
            segment_struct = struct('peak_struct',peak_struct, ...
                'current_depth', 1, 'max_depth', obj.max_recursion_level,...
                'peak_obj', peak_obj,'fid', fid, 'line_colors', line_colors,...
                'prev_peak_obj', []);
            
            
            % Perform depth recursion
            segment_results_return = {};
            [segment_results_return segment_results] = ...
                            obj.apply_segmentation(segment_struct, ...
                                                   segment_results_return);
            % Debug 
%             segment_results.segment_results_cell_array {segment_struct.current_depth}...
%                 = segment_struct;
            
            % Process result of recursion
            recursion_summary = generate_recursion_string...
                (obj, segment_results);
            
            % Create and store return value
            pulse_segment_struct = struct('peak_obj', []);
            pulse_segment_struct.peak_obj = peak_obj;
            pulse_segment_struct.peak_struct = peak_struct;
            pulse_segment_struct.segment_struct = segment_struct;
            % pulse_segment_struct.segment_results = segment_results;
            
            % Save results inside object, may be used later.
            obj.pulse_segment_struct = pulse_segment_struct;
            
            
            % prepare output depending on number of outputs
            if DEBUG_FLAG >= 2
                   fprintf('------------ processing %d return values\n',nargout);
            end
            if nargout == 0
                % assume figure is displayed
                vargout = {};
            elseif nargout == 1
                % return most recent resuts
                varargout = {pulse_segment_struct};
            elseif nargout == 2
                % retrun hierarchical results and most recent result
                varargout = {segment_results_return, pulse_segment_struct};
            end
        end
        
    end % (methods)
    %-------------------------------------------------------------- Private
    methods (Access ='private')
        %----------------------------------------------- apply_segmentation
        function [segment_results_return segment_results] = ...
                                               apply_segmentation(varargin)
            % function performs a higharchical recursion based on regions
            % identified by 'getPeaks'. Although function is guarenteed to
            % end, a public global variable is set to define the recursion
            % depth.
            %
            % The public global variable will provide a way for which to
            % have the program return strings of a particular depth.
            %
            % segment_struct = struct('peak_struct',peak_struct, ...
            %   'current_depth', 1, 'max_depth', obj.max_recursion_level);
            
            % Process entering objects
            if nargin == 3
                obj = varargin{1};
                segment_struct = varargin{2};
                
                % should be handled below 2010_09-05
                segment_results_return = varargin{3};
            else
                error('Error calling function: segment(obj, segment_struct)');
            end
            
            % Function Constants
            DEBUG_FLAG = 0;
            RECURSION_TRACKING = 0;
            INTERACTIVE = 0;
            MINIMUM_NUM_POINTS_TO_RECURSE = 1;
            
            % Echo results to console
            if RECURSION_TRACKING == 1;
                fprintf('------------------ Starting recursion level: %d\n',...
                    segment_struct.current_depth);
            end
            if INTERACTIVE == 1
                fprintf('----- press any key to continue\n');
                pause(obj.PAUSE_TIME)
                
            end
            
            
            % Return results explicitly
            if DEBUG_FLAG >= 2
               fprintf('--------- storing input for recursion depth: %d\n',...
                                       segment_struct.current_depth);
            end
            segment_results_return{segment_struct.current_depth}  = ...
                                                            segment_struct;
            
            
            % Initialize recursion results
            segment_results = struct('terminal_recursion_level',[]);
            
            % Process incoming structure:
            % Verify features in the data and that maximum recusion has not
            % been reached
            %
            % Continue recursion if the following is true:
            %     (1) Number of points greater than 
            %         MINIMUM_NUM_POINTS_TO_RECURSE which is set to 1.
            %         Peak finding algorithmn will operate correctlt
            %     (2) Recursed on vallid peak-valley pair found
            %     (3) The maximum number of recursions have not been
            %         reareached.
            % if and( ...
            %   segment_struct.peak_struct.num_points > MINIMUM_NUM_POINTS_TO_RECURSE, ...
            %   and(~isempty(segment_struct.peak_struct.data_features_found_array), ...
            %   obj.max_recursion_level>segment_struct.current_depth));
            if prod(double((...
                   [segment_struct.peak_struct.num_points > MINIMUM_NUM_POINTS_TO_RECURSE, ...
                    ~isempty(segment_struct.peak_struct.data_features_found_array), ...
                    obj.max_recursion_level>segment_struct.current_depth,...
                    or(segment_struct.peak_struct.are_peaks_and_valleys_proper,...
                    segment_struct.peak_struct.are_extended_peaks_and_valleys_proper)])))==1; 
                % Feature found in the data prepare next recursion
                
                %------------------------------------------- process intput
                % Get feature lists
                peak_struct = segment_struct.peak_struct;

                %------------------------------------ prepare for recursion       
                % construct data for next iteration
                selected_locs = peak_struct.extended_valley_locs;
                Y = peak_struct.Y(selected_locs);
                t = peak_struct.t(selected_locs);
                
                % Create new peak object
                plot_missing_data = 0;
                new_peak_obj = getPeaks(t,Y, plot_missing_data,0);
                new_peak_struct = summarize(new_peak_obj);
                new_peak_struct.plot_missing_data = 0;
                
                % Plot the algorithmns intermediate steps if the the DEBUG
                % flag is set and the number of points are greater than
                % three.
                if  or( obj.RECURSION_TRACKING_FLAG == 1,...
                        and(obj.DEBUG_FLAG == 1, ...
                        new_peak_struct.num_points > MINIMUM_NUM_POINTS_TO_RECURSE ))
                    % select next line color which depends on a user set
                    % number of parameters
                    line_colors = segment_struct.line_colors;
                    num_colors = size(line_colors,1);
                    next_color_id = segment_struct.current_depth+1;
                    if next_color_id > num_colors
                        next_color_id = mod(next_color_id, num_colors-1)+1;
                    end
                    line_color = ...
                        line_colors(next_color_id,:);
                    
                    
                    % Plot current minimum on top current figure
                    new_fid = plot_peaks...
                        (new_peak_obj, segment_struct.fid,line_color);
                    if obj.INTERACTIVE_FLAG == 1
                        fprintf('--- Press any key to resume parititing algorithmn\n');
                        pause(obj.PAUSE_TIME)
                    end
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Returning from recursion                               %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Prepare structure for recursive segmentation
                current_depth = segment_struct.current_depth;
                segment_struct = struct('peak_struct',new_peak_struct, ...
                    'current_depth', (segment_struct.current_depth+1), ...
                    'max_depth', obj.max_recursion_level,...
                    'peak_obj', new_peak_obj, 'fid', segment_struct.fid, ...
                    'line_colors', segment_struct.line_colors,...
                    'prev_peak_obj', segment_struct.peak_obj);
                
                %------------------------------------------------ recursion
                % Continue recursion
                [segment_results_return segment_results] = ...
                            obj.apply_segmentation...
                                  (segment_struct, segment_results_return);
                
                %------------------------------------------ Collate Results
                % Collate results for post processing
                % Redundant, trying to phase out
%                 segment_results.segment_results_cell_array {segment_struct.current_depth}...
%                     = segment_struct;
                
                if DEBUG_FLAG >= 2
                    segment_results_return
                end

            else
                % terminal sequence found, end recursions, and build hormone
                % descriptor
                
                % Draw result for terminal condition
                peak_struct = segment_struct.peak_struct;
                if  or( obj.RECURSION_TRACKING_FLAG == 1,...
                        and(obj.DEBUG_FLAG == 1, ...
                        peak_struct.num_points > 1 ))
                    % select next line color which depends on a user set
                    % number of parameters
                    line_colors = segment_struct.line_colors;
                    num_colors = size(line_colors,1);
                    next_color_id = segment_struct.current_depth+1;
                    if next_color_id > num_colors
                        next_color_id = mod(next_color_id, num_colors-1)+1;
                    end
                    line_color = ...
                        line_colors(next_color_id,:);
                    
                    % Plot current minimum on top current figure
                    plot(peak_struct.t,...
                         peak_struct.Y,...
                         '.k','LineWidth',2, 'MarkerSize', 14 );
                    hold on;
                    
                    if DEBUG_FLAG >= 1
                       fprintf('Input:\n');
                       fprintf('segment_struct:\n');disp(segment_struct)
                       fprintf('segment_results_return:\n');disp(segment_results_return)
                       fprintf('peak_struct:\n');disp(segment_struct.peak_struct)
                       
                       fprintf('Data:\n');
                       fprintf('--- Y = '); obj.display_vector(peak_struct.Y);
                       fprintf('--- t = '); obj.display_vector(peak_struct.t);   
                       DEBUG_FLAG_FIG = figure();
                       plot(peak_struct.t,peak_struct.Y);
                       close(DEBUG_FLAG_FIG)
                    end
                end
                
                % Commented out to add terminal recursion. The goal is to
                % add infomration about the termnial casee for summary
%                   % Cutoff terminal pulse segment structure
%                   segment_results_return = segment_results_return...
%                            (1,1:(segment_struct.current_depth-1));
                
                  if RECURSION_TRACKING == 1
                    fprintf('------------------ Partioning completed in %d recursions \n',...
                        segment_struct.current_depth)
                  end
            end % (end if)
            
            
        end

        %---------------------------------------- generate_recursion_string
        function recursion_summary = generate_recursion_string(varargin)
            % Function processes recursion output to produce machine and 
            % human readable summaries. 
            % 
            % Generate_recursion_string function takes values from the data
            % segmentation and returns a summary string.
            %
            % Step 1: Create a boolean array by recursion level
            
            % Function Constants
            DEBUG_FLAG = 0;
            
            % Process input
            if nargin == 2
                obj = varargin{1};
                segment_results = varargin{2};
                
                if DEBUG_FLAG >= 1
                   obj
                   segment_results
                   obj.pulse_segment_struct
                end
            else
                error('Template for processing aruments not defined')
            end
            
            % Define Recursion Boolean Array
            
            
            % Plot Data
            if DEBUG_FLAG
                fig_id = figure();
                plot(obj.t, obj.Y);
                hold on;
            end  
           
                              
            % Define output
            recursion_summary = struct('descriptive_str','');
            
        end
        
    end % (private methods)
    %------------------------------------------------------- Static Methods
    methods (Static)
        %-------------------------------------------- summarize_peak_struct
        function peak_struct_summary = summarize_peak_struct(varargin)
            % Summarize_peak_struct
            %
            % Summarize peak stucture take a peak summary from peak object
            % and created a summary of key  features of the data data
            % 
            % peak_struct
            %                                 Y: [145x1 double]
            %                                 t: [145x1 int32]
            %                            fig_id: []
            %                        num_points: 145
            %                 min_time_interval: 10
            %                         peak_locs: [27x1 double]
            %                  peak_locs_exists: 1
            %                        peak_times: [27x1 int32]
            %                         peak_vals: [27x1 double]
            %                       valley_locs: [26x1 double]
            %                valley_locs_exists: 1
            %                      valley_times: [26x1 int32]
            %                       valley_vals: [26x1 double]
            %              extended_valley_locs: [26x1 double]
            %        extended_valley_locs_exist: 1
            %             extended_valley_times: [26x1 int32]
            %         extended_valley_locs_vals: [26x1 double]
            %              extended_valley_type: [26x1 double]
            %                  peak_rising_locs: [0x1 double]
            %           peak_rising_locs_exists: 0
            %                 peak_rising_times: [0x1 int32]
            %                  peak_rising_vals: [0x1 double]
            %              peak_descending_locs: [0x1 double]
            %       peak_descending_locs_exists: 0
            %             peak_descending_times: [0x1 int32]
            %              peak_descending_vals: [0x1 double]
            %                valley_rising_locs: [0x1 double]
            %         valley_rising_locs_exists: 0
            %               valley_rising_times: [0x1 int32]
            %                valley_rising_vals: [0x1 double]
            %            valley_descending_locs: [0x1 double]
            %     valley_descending_locs_exists: 0
            %           valley_descending_times: [0x1 int32]
            %            valley_descending_vals: [0x1 double]
            %                  missing_segments: [0x2 int32]
            %             missing_segments_locs: [0x1 double]
            %      missing_segments_start_times: [0x1 int32]
            %           missing_segments_exists: 0
            %                num_missing_points: 0
            %              num_missing_segments: 0
            %           missing_data_start_time: -1
            %                missing_data_times: []
            %         data_features_found_array: [2x1 double]
            %           data_features_found_str: {'PEAK'  'VALLEY'}
            %
            % peak_struct_summary:
            %                   num_points
            %                    num_peaks
            %                   num_nadirs
            %                   rise times
            %                   peak_times
            %                   amplitudes
            %         interpulse_intervals
            %               rise times_sum
            %               peak_times_sum
            %               amplitudes_sum
            %     interpulse_intervals_sum 
            %
            % Revisions:
            % 2010_09_14 Added peak_valley check variables and extended 
            %      peak-valley definitions added to GetPeaks. Restructured
            %      computation to use the extended definitions which are
            %      validated within getPeaks.
            %
            
            
            % Function Constants
            DEBUG_FLAG = 0;
            
            % Process input
            if nargin == 1 
                peak_struct = varargin{1};
                peak_struct = peak_struct{1};
                
                if DEBUG_FLAG >= 1
                   disp(peak_struct)
                   figure()
                   plot(peak_struct.t,peak_struct.Y)
                end
            else
                error('Template for processing aruments not defined')
            end
            
            % Define Recursion Boolean Array
            peak_struct_summary = struct(...
                'num_points', length(peak_struct.Y),  ...
                'num_peaks', length(peak_struct.peak_locs), ...
                'num_nadirs', length(peak_struct.valley_locs), ...
                'rise_times', [], ...
                'peak_times', peak_struct.peak_times, ...
                'valley_times', peak_struct.valley_times,...
                'amplitudes', [], ...
                'interpulse_intervals', [], ...
            	'rise_duration_sum', [], ...
                'amplitudes_sum', [], ...
            	'interpulse_intervals_sum', [], ...
                'are_peaks_and_valleys_proper', [], ...
            	'are_extended_peaks_and_valleys_proper', [],...
                'forward_interpulse_intervals',[],...
                'forward_interpulse_intervals_end_times',[],...
                'forward_secretion_rates',[],...
                'forward_secretion_rates_cum_time',[],...
                'backward_clearance_rates',[],...
                'backward_clearance_rates_cum_times',[]...
                );
            
            %------------------------ Include time and concentration values
            peak_struct_summary.Y = peak_struct.Y;
            peak_struct_summary.t = peak_struct.t;
            %--------------------------- Include extended peaks and valleys
            peak_struct_summary.extended_peaks_times = ...
                peak_struct.extended_peaks_times;
            peak_struct_summary.extended_valley_times = ...
                peak_struct.extended_valley_times; 
            peak_struct_summary.extended_peaks_locs = ...
                peak_struct.extended_peaks_locs;
            peak_struct_summary.extended_valley_locs = ...
                peak_struct.extended_valley_locs; 
            %------------------------------Compute forward pulse parameters
            % Always use extended peak times since they are designed to be
            % the best estimate of pulsatility
            local_peaks_times = peak_struct.extended_peaks_times;
            local_valleys_times = peak_struct.extended_valley_times;
            local_peaks_times_locs = peak_struct.extended_peaks_locs;
            local_valleys_times_locs = peak_struct.extended_valley_locs;              
            
            % Get peaks vallid for secrete calculation
            p_obj = pulseSegmentation(); % Klude to get static functions
            [p_loc v_loc] = p_obj.return_secrete_vallid(local_peaks_times, ...
                local_valleys_times, local_peaks_times_locs, ...
                local_valleys_times_locs);

            % Use selected locations
            local_peaks_times = peak_struct.t(p_loc);
            local_valleys_times = peak_struct.t(v_loc);
            local_peaks_times_locs = p_loc;
            local_valleys_times_locs = v_loc;   
            
            % Calculate secrete parameters
            peak_struct_summary.amplitudes = ...
                peak_struct.Y(local_peaks_times_locs) -...
                peak_struct.Y(local_valleys_times_locs);
            peak_struct_summary.forward_interpulse_intervals = ...
                diff(peak_struct.extended_valley_times);
            peak_struct_summary.forward_interpulse_intervals_start_times = ...
                peak_struct.extended_valley_times(1:end-1);
            peak_struct_summary.forward_interpulse_intervals_end_times = ...
                peak_struct.extended_valley_times(2:end);
            peak_struct_summary.rise_times = robust_minus...
                (local_peaks_times,local_valleys_times) ;
            
            % Set cumulative start time
            peak_struct_summary.rise_times = robust_minus...
                (local_peaks_times,local_valleys_times) ;            
            
            % Store computation for analysis
            peak_valley_pair_struct = struct(...
            	'forward_peak_times', local_peaks_times,...
                'forward_valley_times', local_valleys_times,...
                'forward_peak_locs', local_peaks_times_locs,...
                'forward_valley_locs', local_valleys_times_locs,...
                'forward_amplitudes', peak_struct_summary.amplitudes,...
                'forward_interpulse_interval', peak_struct_summary.interpulse_intervals,...
                'forward_rise_times', peak_struct_summary.rise_times,...
                'forward_secretion_rates',[]);  
        
            % Calculate secretion rates if peak-valley is vallid
            if peak_struct.are_extended_peaks_and_valleys_proper
                peak_struct_summary.forward_secretion_rates = ...
                    double(peak_struct_summary.amplitudes) ./ ...
                    double(peak_struct_summary.rise_times);
                peak_struct_summary.forward_secretion_rates_cum_time = ...
                    local_valleys_times;
                
                % Save results in structure
                peak_valley_pair_struct.forward_secretion_rates = ...
                    peak_struct_summary.forward_secretion_rates;
            else
                peak_struct_summary.forward_secretion_rates = [];
            end
            
            %-------------------------- Calculate backward pulse parameters
            % Assume properly structured pulses (reset local variables)
            local_peaks_times = peak_struct.extended_peaks_times;
            local_valleys_times = peak_struct.extended_valley_times;
            local_peaks_times_locs = peak_struct.extended_peaks_locs;
            local_valleys_times_locs = peak_struct.extended_valley_locs;   
            
            % Get peaks vallid for secrete calculation
            p_obj = pulseSegmentation(); % Kludge to get static functions
            if length(local_peaks_times_locs) ~= length(local_valleys_times_locs)
                fprintf('\n');
            end
            [p_loc v_loc] = p_obj.return_clearance_vallid(local_peaks_times, ...
                local_valleys_times, local_peaks_times_locs, ...
                local_valleys_times_locs);

            % Use selected locations
            local_peaks_times = peak_struct.t(p_loc);
            local_valleys_times = peak_struct.t(v_loc);
            local_peaks_times_locs = p_loc;
            local_valleys_times_locs = v_loc;  
            
            % Calculate backward parameters            
            peak_struct_summary.fall_times = robust_minus ...
                (local_valleys_times, local_peaks_times);
            peak_struct_summary.amplitude_falls = robust_minus...
                (peak_struct.Y(local_peaks_times_locs), ...
                 peak_struct.Y(local_valleys_times_locs));
             
            % Store peak-valley backward parameters
            peak_valley_pair_struct.backward_peak_times = ...
                local_peaks_times;
            peak_valley_pair_struct.backward_valley_times = ...
                local_valleys_times;
            peak_valley_pair_struct.backward_peak_locs = ...
                local_peaks_times_locs;
            peak_valley_pair_struct.backward_valley_locs = ...
                local_valleys_times_locs;
            peak_valley_pair_struct.backward_fall_times = ...
                peak_struct_summary.fall_times;
            peak_valley_pair_struct.backward_amplitude_falls = ...
                peak_struct_summary.amplitude_falls;
            
            % Calculate secretion rates if peak-valley is vallid
            if peak_struct.are_extended_peaks_and_valleys_proper
                peak_struct_summary.backward_clearance_rates = ...
                    double(peak_valley_pair_struct.backward_amplitude_falls) ./ ...
                    double(peak_valley_pair_struct.backward_fall_times);
                peak_struct_summary.backward_clearance_rates_cum_times = ...
                    local_peaks_times;
                
                % Save results in structure
                peak_valley_pair_struct.backward_clearance_rates = ...
                    peak_struct_summary.backward_clearance_rates;
            else
                peak_struct_summary.backward_clearance_rates = [];
            end

            %---------------------------- Calculate paired pulse parameters
            % Assume properly structured pulses (reset local variables)
            local_peaks_times = peak_struct.extended_peaks_times;
            local_valleys_times = peak_struct.extended_valley_times;
            local_peaks_times_locs = peak_struct.extended_peaks_locs;
            local_valleys_times_locs = peak_struct.extended_valley_locs;   
            
            % Get peaks vallid for secrete calculation
            p_obj = pulseSegmentation(); % Kludge to get static functions
            if length(local_peaks_times_locs) ~= length(local_valleys_times_locs)
                fprintf('\n');
            end
            [p_loc v_loc] = p_obj.return_vallid_peak_valley_pairs(local_peaks_times, ...
                local_valleys_times, local_peaks_times_locs, ...
                local_valleys_times_locs);            
            if and(length(v_loc) - length(p_loc) ~= 1, ...
                    and(~isempty(p_loc), ~isempty(v_loc)))
                v_loc
                p_loc 
            end
            
            % Use selected locations
            paired_forward_peaks_times = peak_struct.t(p_loc);
            paired_forward_valleys_times = peak_struct.t(v_loc);
            paired_forward_peaks_times_locs = p_loc;
            paired_forward_valleys_times_locs = v_loc;  
            
            % Calculate backward parameters            
            peak_struct_summary.paired_fall_times = robust_minus ...
                (paired_forward_valleys_times(2:end), paired_forward_peaks_times);
            peak_struct_summary.paired_amplitude_falls = robust_minus...
                (peak_struct.Y(paired_forward_peaks_times_locs), ...
                 peak_struct.Y(paired_forward_valleys_times_locs(2:end)));
             
            % Store peak-valley backward parameters
            peak_valley_pair_struct.paired_backward_peak_times = ...
                paired_forward_peaks_times;
            peak_valley_pair_struct.paired_backward_valley_times = ...
                paired_forward_valleys_times;
            peak_valley_pair_struct.paired_backward_peak_locs = ...
                paired_forward_peaks_times_locs;
            peak_valley_pair_struct.paired_backward_valley_locs = ...
                paired_forward_valleys_times_locs;
            peak_valley_pair_struct.paired_backward_fall_times = ...
                peak_struct_summary.paired_fall_times;
            peak_valley_pair_struct.paired_backward_amplitude_falls = ...
                peak_struct_summary.paired_amplitude_falls;
            

            % Calculate secrete parameters (forward)
            peak_struct_summary.paired_amplitudes = robust_minus(...
                peak_struct.Y(paired_forward_peaks_times_locs),...
                peak_struct.Y(paired_forward_valleys_times_locs(2:end)));
            peak_struct_summary.paired_interpulse_intervals = ...
                diff(peak_struct.extended_valley_times);
            peak_struct_summary.paired_rise_times = robust_minus...
                (paired_forward_peaks_times,paired_forward_valleys_times(1:end-1)) ;
           
            % Calculate pair 
            % Calculate secretion rates if peak-valley is vallid
            if peak_struct.are_extended_peaks_and_valleys_proper
                peak_struct_summary.paired_secretion_rates = ...
                    double(peak_struct_summary.paired_amplitudes) ./ ...
                    double(peak_struct_summary.paired_rise_times);
                                
                peak_struct_summary.paired_clearance_rates = ...
                    double(peak_struct_summary.paired_amplitude_falls) ./ ...
                    double(peak_struct_summary.paired_fall_times);
                
                % Save results in peak_valley_structure
                peak_struct_summary.paired_secretion_rates = ...
                    peak_struct_summary.paired_secretion_rates;
                peak_struct_summary.paired_clearance_rates = ...
                    peak_struct_summary.paired_clearance_rates;
                 
                % Save corresponding cumulative times
                peak_struct_summary.paired_secretion_rates_cum_times = ...
                    double(paired_forward_valleys_times(1:end-1));
                peak_struct_summary.paired_clearance_rates_cum_times = ...
                    double(peak_struct.t(paired_forward_peaks_times_locs));
                peak_struct_summary.paired_interpulse_intervals_cum_times = ...
                    peak_struct.extended_valley_times(1:end-1);
            else
                % Create empty array so variable is defined
                peak_struct_summary.paired_secretion_rates = [];             
                peak_struct_summary.paired_clearance_rates = [];  
                peak_struct_summary.paired_secretion_rates_cum_times = [];
                peak_struct_summary.paired_clearance_rates_cum_times = [];
                peak_struct_summary.paired_interpulse_intervals_cum_times = ...
                   [];                
            end
            
            % Copy values from peak valley pair struct into peak valley 
            % struct   
            peak_struct_summary.paired_forward_peaks_times = ...
                paired_forward_peaks_times;
            peak_struct_summary.paired_forward_valleys_times = ...
                paired_forward_valleys_times;
            peak_struct_summary.paired_forward_peaks_times_locs = ...
                paired_forward_peaks_times_locs;
            peak_struct_summary.paired_forward_valleys_times_locs = ...
                paired_forward_valleys_times_locs;  
            
            peak_struct_summary.paired_amplitudes = ...
                peak_struct_summary.paired_amplitudes;
            peak_struct_summary.paired_interpulse_intervals = ...
                peak_struct_summary.paired_interpulse_intervals;
            peak_struct_summary.paired_rise_times = ...
                peak_struct_summary.paired_rise_times;
            
            peak_struct_summary.paired_backward_peak_times = ...
                peak_valley_pair_struct.paired_backward_peak_times;
            peak_struct_summary.paired_backward_valley_times = ...
                peak_valley_pair_struct.paired_backward_valley_times;
            peak_struct_summary.paired_backward_peak_locs = ...
                peak_valley_pair_struct.paired_backward_peak_locs;
            peak_struct_summary.paired_backward_valley_locs = ...
                peak_valley_pair_struct.paired_backward_valley_locs;
            
            peak_struct_summary.paired_backward_fall_times = ...
                peak_valley_pair_struct.paired_backward_fall_times;
            peak_struct_summary.paired_backward_amplitude_falls = ...
                peak_valley_pair_struct.paired_backward_amplitude_falls;           
            
            % copy peak valley properties from peak structure
            peak_struct_summary.are_peaks_and_valleys_proper = ... 
                peak_struct.are_peaks_and_valleys_proper;
            peak_struct_summary.are_extended_peaks_and_valleys_proper = ...
                peak_struct.are_extended_peaks_and_valleys_proper;
            
            %-------------------------------------------- Robust Minus Sign
            function minus_r = robust_minus(op1, op2)
                % robust minu return empty array if empty
                if length(op1) ~= length(op2)
                    minus_r = op1-op2;
                elseif and(~isempty(op1), ~isempty(op2))
                    minus_r = op1-op2;
                else
                    minus_r = [];
                end
            end
            %-------------------------------------------- Robust Minus Sign
            function divide_r = robust_divide(op1, op2)
                % robust minu return empty array if empty
                if and(~isempty(op1), ~isempty(op2))
                    divide_r = op1 ./ op2;
                else
                    divide_r = [];
                end
            end
            %-------------------------------- Calculate parameter summaries
            % Define summary function 
            function snn_struct = summarized_non_normal_f(A)
                % summarize non-normal array 
                DEBUG_FLAG = 0;
                
                % echo input to console
                if DEBUG_FLAG == 1
                   A 
                end
                
                % Summaraize function
                if ~isempty(A)
                    % 2012/07/03 Revisons
                    % snn_struct = struct('min_value',min(A),...
                    %    'median_value',median(A),'max_value',max(A));
                    snn_struct = struct('min_value',min(double(A)),...
                        'median_value',median(double(A)),...
                        'max_value',max(double(A)));
                else
                    snn_struct = struct('min_value',nan,...
                        'median_value',nan,'max_value',nan);                    
                end
            
            end
            
            % Calculate forward summary
            peak_struct_summary.rise_times_sum = ...
                       summarized_non_normal_f...
                            (peak_struct_summary.rise_times);   
            
            % Compute pulse summary
            peak_struct_summary.rise_duration_sum = ...
                       summarized_non_normal_f...
                            (peak_struct_summary.rise_times);
            peak_struct_summary.amplitudes_sum = ...
                       summarized_non_normal_f ...
                           (peak_struct_summary.amplitudes);
            peak_struct_summary.interpulse_intervals_sum = ...
                       summarized_non_normal_f...
                           (peak_struct_summary.paired_interpulse_intervals);  
            peak_struct_summary.fall_duration_sum = ...
                       summarized_non_normal_f ...
                           (peak_struct_summary.fall_times);
            peak_struct_summary.amplitude_falls_sum = ...
                       summarized_non_normal_f...
                           (peak_struct_summary.amplitude_falls); 

            
            % Plot Data
            if DEBUG_FLAG
                peak_struct_summary
            end  
            
        end
        %------------------------------------ Summarize segmentation method
        function varargout  = ...
                     summarized_segmentation_output ...
                        (obj, segment_results_return)
            % function take the output of the segmentation run and creates
            % a summaries by recursion level
            % 
            % If no return is given the summary is written to the console
            %
            % segment_struct:
            %          peak_struct: [1x1 struct]
            %        current_depth: 1
            %            max_depth: 100
            %             peak_obj: [1x1 getPeaks]
            %                  fid: 11
            %          line_colors: [5x3 double]
            %        prev_peak_obj: []
            %
            
            % Function Constant
            DEBUG_FLAG = 0;
            MAX_NUM_POINTS_TO_ECHO = 200;
            
            % Echo input to screen
            if DEBUG_FLAG >= 1
                disp(obj)
                fprintf('segment_results_return:\n');
                                   disp(segment_results_return);
                fprintf('num of recursions:%d\n',...
                                   length(segment_results_return));
                fprintf('segment_results_return\n')               
                               disp(segment_results_return{1})
            end
            
            % Get peak struct arrays
            get_peak_struct = @(x_struct)getfield(x_struct,'peak_struct');
            peak_struct_cell = cellfun(get_peak_struct, segment_results_return,...
                'UniformOutput', 0);

            % Process peak summary arrays
            for p = 1:length(peak_struct_cell)
                recursion_summary_results_struct_array{p} = ...
                    obj.summarize_peak_struct(peak_struct_cell(p));
            end
            
            % Prepare for dynamic debug
            % obj.summarize_peak_struct(peak_struct_cell(end))
            recursion_max = length(peak_struct_cell);
            
            % Create output
            if nargout == 0
                % Write summary to console
                for r = 1:length(recursion_summary_results_struct_array)
                    
                    if r == recursion_max
                       DEBUG_FLAG = 1; 
                    end
                    
                    % Create current recusion level structure
                    sum_struct = recursion_summary_results_struct_array{r};
                   
                    % Echo simple constants to console - num_points,
                    % num_peaks, num_nadirs
                    fprintf('Recursion Level - %d\n',r)
                    fprintf('--------------------\n',r)
                    fprintf('num points =  %d, num_peaks = %d, num nadirs = %d\n',...
                       sum_struct.num_points, sum_struct.num_peaks, ...
                       sum_struct.num_nadirs); 
                    fprintf('are_peaks_and_valleys_proper =  %d, are_extended_peaks_and_valleys_proper = %d\n',...
                       sum_struct.are_peaks_and_valleys_proper, ...
                       sum_struct.are_extended_peaks_and_valleys_proper); 
                   
                    % write point to console if there are only a few
                    % numbers
                    if sum_struct.num_points <= MAX_NUM_POINTS_TO_ECHO
                        % plot all the point, used to look for terminal 
                        % \
                        fprintf('times: '); ...
                        obj.display_vector(peak_struct_cell{r}.t,2, 10);
                        fprintf('concentration values: '); ...
                        obj.display_vector(peak_struct_cell{r}.Y,2, 10);
                     end
                 
                    % Display arrays: rise times, peak times, valley times
                    %  amplitudes, interpulse intervals
                    fprintf('rise times: '); ...
                        obj.display_vector(sum_struct.rise_times,2, 10);
                    fprintf('peak times: '); ...
                        obj.display_vector(sum_struct.peak_times,2, 10);         
                    fprintf('valley times: '); ...
                        obj.display_vector(sum_struct.valley_times,2, 10);   
                    fprintf('amplitudes: '); ...
                        obj.display_vector(sum_struct.amplitudes,2, 10);                       
                     fprintf('interpulse intervals: '); ...
                        obj.display_vector...
                            (sum_struct.paired_interpulse_intervals, 2, 10);                                          
                    fprintf('fall times: '); ...
                        obj.display_vector(sum_struct.fall_times,2, 10);                       
                    fprintf('amplitude falls: '); ...
                        obj.display_vector...
                            (sum_struct.amplitude_falls, 2, 10); 
                        
                    % rise_times_sum, peak_times_sum, amplitudes_sum
                    % interpulse_intervals_sum                        
                    printf_check('rise duration sum',...
                        sum_struct.rise_duration_sum.min_value,...
                        sum_struct.rise_duration_sum.median_value, ...
                        sum_struct.rise_duration_sum.max_value);
                    printf_check('amplitudes sum',...
                        sum_struct.amplitudes_sum.min_value,...
                        sum_struct.amplitudes_sum.median_value, ...
                        sum_struct.amplitudes_sum.max_value);                   
                    printf_check('interpulse intervals sum',...
                        sum_struct.interpulse_intervals_sum.min_value,...
                        sum_struct.interpulse_intervals_sum.median_value, ...
                        sum_struct.interpulse_intervals_sum.max_value);                        

                    % fall_duration_sum,amplitude_falls_sum
                    printf_check('fall duration summary',...
                        sum_struct.fall_duration_sum.min_value,...
                        sum_struct.fall_duration_sum.median_value, ...
                        sum_struct.fall_duration_sum.max_value);
                    printf_check('amplitude fall summary',...
                        sum_struct.amplitude_falls_sum.min_value,...
                        sum_struct.amplitude_falls_sum.median_value, ...
                        sum_struct.amplitude_falls_sum.max_value);

            
                    % Add space
                    fprintf('\n',r)
                end
                fprintf('\n')
            elseif nargout == 1
                %  Create return structure                
                varargout = {recursion_summary_results_struct_array};
            else
                error('pulseSegmentation:summarize_segmentation_output',...
                    'Number of output arguments not supported');
            end
            
            %----------------------------------------------------------
            % check prior to print
            function printf_check...
                    (description, var_min, var_median, var_max)
                if  isnan(var_min*var_median*var_max)
                    fprintf('%s ( )\n',description),
                else
                    fprintf('%s (%.2f, %.2f, %.2f)\n',...
                        description, var_min, var_median, var_max);
                end
            end
        end
        %----------------------------------------- Plot segmentation method
        function varargout  = ...
                     plot_segmentation_output ...
                          (obj, recursion_summary_results_struct_array,...
                           hormone_plot)
            % plot_segmentation_output
            % function take the output summarize segmentation output and creates
            % figures
            % 
            % recursion_summary_results_struct_array:
            %       num_points
            %       num_peaks
            %       num_nadirs
            %       rise_times
            %       peak_times
            %       valley_times
            %       amplitudes
            %       interpulse_intervals
            %       rise_duration_sum
            %       amplitudes_sum
            %       interpulse_intervals_sum
            %       fall_times
            %       amplitude_falls
            %       rise_times_sum
            %       fall_duration_sum
            %       amplitude_falls_sum
            %
            % hormone_plot
            %                     t: [215x1 int32]
            %                     Y: [215x1 double]
            %                     T: 1440
            %            subject_id: 23
            %        subject_id_str: 'cort_23'
            %          group_id_str: 'C'
            %         data_type_str: 'Cortisol'
            %           sleep_start: 0
            %             sleep_end: 480
            %     upper_left_corner: [61.4000 76.8769]
            %            time_adj_F: @zero_time
            %             plot_type: 'Segmentation'   

  
            
            % Function Constant
            DEBUG_FLAG = 0;
            
            % Echo input to screen
            if DEBUG_FLAG >= 1
                fprintf('recursion_summary_results_struct_array:\n');
                            disp(recursion_summary_results_struct_array);
                fprintf('hormone_plot:\n');
                            disp(hormone_plot);
            end
            
            % Create title
            title_str = sprintf('%s %d%s',hormone_plot.data_type_str, ...
                                  hormone_plot.subject_id,...
                                  hormone_plot.group_id_str);
            
            % Create single variable histograms           
            create_historgram_stuct = struct(...
                'variables', {'rise_times', 'amplitudes', 'fall_times',...
                              'amplitude_falls', 'forward_interpulse_intervals'},...
                'titles', {sprintf('%s Rise Duration',title_str), ...
                           sprintf('%s Rise',title_str), ...
                           sprintf('%s Fall Duration',title_str), ...
                           sprintf('%s Fall',title_str), ...
                           sprintf('%s Interpulse Intervals',title_str)}, ...
                'xlabels', {'Duration (Min)', 'Amplitudes (ug/dL)', ...
                            'Duration (min)', 'Amplitude Descent (ug/dL)', ...
                            'Interpulse Intervals (min)'},...                          
                'ylabels', {'Count', 'Count', 'Count', 'Count', 'Count'}, ...
                'result_figure_file_path', hormone_plot.application_root_directory);

            [hist_fig_ids hist_fig_fns] = ...
                obj.Create_single_variable_histograms_from_recursion...
                    (recursion_summary_results_struct_array, ...
                    create_historgram_stuct);
            
            % Create xy plots
            create_xy_struct = struct(...
                'variables', {{'rise_times', 'amplitudes'},...
                              {'fall_times', 'amplitude_falls'}},...
                'titles', {sprintf('%s - Rise', title_str), ...
                           sprintf('%s - Fall', title_str)},...
                'xlabels', {'Duration (Min)', 'Duration (min)'},...                          
                'ylabels', ...
                    {'Amplitudes (ug/dL)', 'Amplitude Descent (ug/dL)'},...
                'title', sprintf('%s (blue-rise, red-fall)',title_str),...
                'fit_data', 1,...
                'title_str',title_str);
                
           [xy_fig_ids xy_figs_fn]= obj.Create_xy_plots_from_recursion...
                (recursion_summary_results_struct_array, create_xy_struct);           
            
            % Create mulit-scatter plot
             create_multiscatter_struct = struct(...
                'variables', {'rise_times', 'amplitudes',...
                              'fall_times', 'amplitude_falls'},...
                'var_labels', {'Rise Times', 'Amplitudes',...
                              'Fall Times', 'Amplitude Falls'},...
                'var_units', {'Duration (Min)', 'Amplitudes (ug/dL)',...
                    'Duration (min)', 'Amplitude Descent (ug/dL)'},...                          
                'title', sprintf('%s',title_str),...
                'title_str',title_str);       
            
           [ms_fig_ids ms_figs_fn] = obj.Create_multiscatter_from_recursion...
                (recursion_summary_results_struct_array, ...
                     create_multiscatter_struct,...
                     hormone_plot);            
 
             % Create gplot
             create_gplot_struct = struct(...
                'variables', {'rise_times', 'amplitudes',...
                              'fall_times', 'amplitude_falls'},...
                'var_labels', {'Rise Times', 'Amplitudes',...
                              'Fall Times', 'Amplitude Falls'},...
                'var_units', {'Duration (Min)', 'Amplitudes (ug/dL)',...
                    'Duration (min)', 'Amplitude Descent (ug/dL)'},...    
                'time_loc_var','extended_valley_locs',...
                'time_var','t',...
                'title', sprintf('%s',title_str),...
                'title_str',title_str);       
            
           [ms_fig_ids ms_figs_fn] = obj.Create_gplot_from_recursion...
                (recursion_summary_results_struct_array, ...
                     create_gplot_struct,...
                     hormone_plot);   
                 
            % Prepare output argument
            if nargout == 0
                varargout = {};
            elseif nargout == 1
                fig_ids = [hist_fig_ids,xy_fig_ids,ms_fig_ids];
                varargout = {fig_ids};
            elseif nargout == 2
                fig_ids = [hist_fig_ids,xy_fig_ids,ms_fig_ids];
                fig_fns = [hist_fig_fns, xy_figs_fn,ms_figs_fn];
                varargout = {fig_ids, fig_fns};
            end
            
        end
        %----------------------------------- plot_pulse_parameter_recursion
        function varargout  = ...
                     plot_pulse_parameter_recursion ...
                          (obj, recursion_summary_results_struct_array,...
                           hormone_plot)
            % plot_segmentation_output
            % function take the output summarize segmentation output and creates
            % figures
            % 
            % recursion_summary_results_struct_array:
            %       num_points
            %       num_peaks
            %       num_nadirs
            %       rise_times
            %       peak_times
            %       valley_times
            %       amplitudes
            %       interpulse_intervals
            %       rise_duration_sum
            %       amplitudes_sum
            %       interpulse_intervals_sum
            %       fall_times
            %       amplitude_falls
            %       rise_times_sum
            %       fall_duration_sum
            %       amplitude_falls_sum
            %
            % hormone_plot
            %                     t: [215x1 int32]
            %                     Y: [215x1 double]
            %                     T: 1440
            %            subject_id: 23
            %        subject_id_str: 'cort_23'
            %          group_id_str: 'C'
            %         data_type_str: 'Cortisol'
            %           sleep_start: 0
            %             sleep_end: 480
            %     upper_left_corner: [61.4000 76.8769]
            %            time_adj_F: @zero_time
            %             plot_type: 'Segmentation'   

  
            
            % Function Constant
            DEBUG_FLAG = 0;
            
            % Echo input to screen
            if DEBUG_FLAG >= 1
                fprintf('recursion_summary_results_struct_array:\n');
                            disp(recursion_summary_results_struct_array);
                fprintf('recursion_summary_results_struct:\n');
                           disp(recursion_summary_results_struct_array{1});
                fprintf('hormone_plot:\n');
                            disp(hormone_plot);
            end
            
            % Initialize return value while functionis under constructon
            fig_ids = [];
            fig_fns = [];        
            
            % Create title
            title_str = sprintf('%s %d%s',hormone_plot.data_type_str, ...
                                  hormone_plot.subject_id,...
                                  hormone_plot.group_id_str);
            
            % Create single variable recursion plots          
            create_recursion_jitter_plot_stuct = struct(...
                'variables', {  'forward_secretion_rates',...
                                'backward_clearance_rates',...
                                'forward_interpulse_intervals'}, ...
                'time_variables', {'forward_secretion_rates_cum_time',...
                                   'backward_clearance_rates_cum_times',...
                                   'forward_interpulse_intervals_end_times'},...
                'titles', {sprintf('%s',title_str) }, ...
                'xlabels', {'Recursion Number'},...                          
                'ylabels', {'Accumulation Rates (ug/(dL Min))', ...
                            'Dissipation Rates (ug/(dL Min))', ...
                            'Interpulse Interval (Min)'},...         
                'result_figure_file_path', ...
                    hormone_plot.application_root_directory,...
                'data_color',[[0 0 1];[1 0 0];[0 0 1]],...
                'yscale',{'log', 'log','log'},...
                'temporal_color_map', obj.temporal_color_map,...
                'USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS',...
                    obj.USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS);
            
            [rp_fig_ids rp_fig_fns] = ...
                obj.Create_variable_recursion_plot_with_jitter...
                    (obj, recursion_summary_results_struct_array, ...
                     create_recursion_jitter_plot_stuct, ...
                     hormone_plot);
            
            % Create xy plots
            create_recursive_xy_struct = struct(...
                'variables',{{'paired_secretion_rates', ...
                              'paired_clearance_rates', ...
                              'paired_interpulse_intervals'}},...
                'time_variables', {'paired_secretion_rates_cum_times',...
                                   'paired_clearance_rates_cum_times',...
                                   'paired_interpulse_intervals_cum_times'},...
                'titles', {sprintf('%s', title_str)},...
                'xlabels', {'Accumulation Rate (ug/(dL Min))'},...                          
                'ylabels', {'Dissipation Rate (ug/(dL Min))'},...
                'yscale', {'log'},...
                'xscale', {'log'},...
                'data_color',[[0 0 1]],...
                'temporal_color_map', obj.temporal_color_map,...
                'USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS',...
                    obj.USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS);
           
           [xy_fig_ids xy_figs_fn]= obj.Create_recursion_summary_xy_plots...
                (obj,...
                 recursion_summary_results_struct_array, ...
                 create_recursive_xy_struct,...
                 hormone_plot);           

            % Create mulit-scatter plot
             create_multiscatter_struct = struct(...
                'variables', {'paired_secretion_rates', ...
                              'paired_clearance_rates',...
                              'paired_interpulse_intervals'},...
                'var_labels', {'Secretion', 'Clearance',...
                              'IP Interval'},...
                'plot_labels', {'Accumulattion', 'Dissipation',...
                              'Inter-nadir Interval'},...
                'var_units', {'(ug/(dL Min)', '(ug/(dL Min)',...
                    'Min'},...                          
                'title', sprintf('%s',title_str),...
                'title_str',title_str);       
            
           [ms_fig_ids ms_figs_fn] = obj.Create_multiscatter_from_recursion...
                (recursion_summary_results_struct_array, ...
                 create_multiscatter_struct,...
                 hormone_plot);           

             
             % Create figures of text representation of each recursion
             % level
             create_pulse_text_fig_struct = struct(...
                'variables', {'paired_secretion_rates', ...
                              'paired_clearance_rates',...
                              'paired_interpulse_intervals'},...
                'var_labels', {'Secretion', 'Clearance',...
                              'IP Interval'},...
                'var_units', {'(ug/(dL Min)', '(ug/(dL Min)',...
                    'Min'},...                          
                'title', sprintf('%s',title_str),...
                'title_str',title_str);       
            
           [ms_fig_ids ms_figs_fn recursion_string_summary] = ...
               obj.Create_hormone_text_figure_from_recursion...
                (recursion_summary_results_struct_array, ...
                 create_pulse_text_fig_struct,...
                 hormone_plot);  
             
            % Prepare output argument
            if nargout == 0
                varargout = {};
            elseif nargout == 1
                fig_ids = [rp_fig_ids,xy_fig_ids,ms_fig_ids];
                varargout = {fig_ids};
            elseif nargout == 2
                fig_ids = [rp_fig_ids,xy_fig_ids,ms_fig_ids];
                fig_fns = [rp_fig_fns,xy_figs_fn,ms_figs_fn];
                varargout = {fig_ids, fig_fns};
            elseif nargout == 3
                fig_ids = [rp_fig_ids,xy_fig_ids,ms_fig_ids];
                fig_fns = [rp_fig_fns,xy_figs_fn,ms_figs_fn];
                varargout = {fig_ids, fig_fns, recursion_string_summary};
            end
            
        end
        %----------------------- Create_variable_recursion_plot_with_jitter
        function [rp_figs, rp_fns] = ...
        Create_variable_recursion_plot_with_jitter ...
                   (obj, recursion_summary_results_struct_array, ...
                    create_recursion_jitter_plot_stuct, ...
                    hormone_plot)
          % for the save of time writing in sequential form. Recursive and 
          % structure manipulation more powerful but slower to write and
          % debug.
            
            % define number of variables and recursions
            num_plot = max(size(create_recursion_jitter_plot_stuct));
            num_recursions = length(recursion_summary_results_struct_array);
            
            % Create variable storage location
            rp_figs = [];
            rp_fns = {};
            
            % Create each plot
            for p = 1:num_plot
                % define recursive plot structure
                recursive_plot_struct = struct(...
                    'var',create_recursion_jitter_plot_stuct(p).variables,...
                    'plot_title',create_recursion_jitter_plot_stuct(p).titles,...
                    'xlabel',create_recursion_jitter_plot_stuct(p).xlabels,...
                    'ylabel',create_recursion_jitter_plot_stuct(p).ylabels,...
                    'result_figure_file_path',...
                        create_recursion_jitter_plot_stuct(p).result_figure_file_path,...
                    'data',[],...
                    'data_color',...
                        create_recursion_jitter_plot_stuct(p).data_color(p,:),...
                    'data_color_array',[],...
                    'time_var',...
                        create_recursion_jitter_plot_stuct(p).time_variables,...
                    'yscale',...
                        create_recursion_jitter_plot_stuct(p).yscale,...
                    'tmax', hormone_plot.T,...
                    'USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS', [],...
                    'temporal_color_map', []);
                  temp = create_recursion_jitter_plot_stuct.USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS;
                  recursive_plot_struct.USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS = temp;
                
                % Initialize variables
                data = [];
                time = [];
                
                % Get data from cell array and put into an xy array
                for d = 1: num_recursions
                    % Get data
                    rec_struct = recursion_summary_results_struct_array{d};
                    r_data = getfield(rec_struct,recursive_plot_struct.var);
                    r_data = [ones(length(r_data),1)*d, r_data];
                    t_data = getfield(rec_struct,...
                                            recursive_plot_struct.time_var);
                    t_data = [ones(length(t_data),1)*d, t_data];
                    
                    data = [data;r_data];
                    time = [time;t_data];
                end
                recursive_plot_struct.data = data;
                recursive_plot_struct.time = time;
                
                % Create color based on time
                % Caclulate marker color
                ch_bool = getfield(create_recursion_jitter_plot_stuct, ...
                    'USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS');
                if  ch_bool == 1
                    time_range = [0 recursive_plot_struct.tmax];
                    cmap = create_recursion_jitter_plot_stuct.temporal_color_map;
                    sleep_scatter_color = ...
                        get_color_array(time(:,2), time_range, cmap);
                    recursive_plot_struct.data_color_array = ...
                        sleep_scatter_color;
                    recursive_plot_struct.temporal_color_map = cmap;
                end  
                
                % Create recursive plot
                rp_fig = create_recursive_plot_w_jitter ...
                    (obj, recursive_plot_struct);

                % Generate file name
                rp_fn = '';
                rp_fn = sprintf('recurssion_plot_%s',...
                    create_recursion_jitter_plot_stuct(p).variables);
                
                % Store figure information
                rp_figs(p) = rp_fig; % use comma seperators
                rp_fns{p} = rp_fn; % use comma seperators
            end
            
            %------------------------------- create_recursive_plot_w_jitter
            function rp_fig = create_recursive_plot_w_jitter ...
                    (obj, recursive_plot_struct)
                % function plot catgorical data with gitter   
              
                % function constants
                marker_size = obj.recursion_marker_size;
                jitter_scale = obj.jitter_scale;
                     
                % plot(recursive_plot_struct.data);
                data = recursive_plot_struct.data;
                num_recursions = double(max(data(:,1)));
                
                % Create Figure
                rp_fig = figure();
                
                % set axes parameters
                h = findobj(gca,'Type','patch');
                set(h,'LineWidth',2, 'FaceColor','flat')
                set(gca,'LineWidth',2)
                set(gca,'FontSize',14)
                set(gca,'FontWeight','bold') 
                set(gca,'yscale',recursive_plot_struct.yscale)
                hold(gca,'all');
                
                % Plot each iteration with a different symbol 
                for r = 1:num_recursions
                    cur_r_indexes = find(data(:,1)==r);
                    if recursive_plot_struct.USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS == 1
                        scatter(jitter(data(cur_r_indexes,1),jitter_scale),...
                            data(cur_r_indexes,2),...
                            marker_size, ...
                            recursive_plot_struct.data_color_array(cur_r_indexes,:),...
                            'filled',...
                            'MarkerEdgeColor','k',...
                            'Marker',obj.marker_type_array{r});
                        set(h,'Colormap',recursive_plot_struct.temporal_color_map);
                    else
                        scatter(jitter(data(cur_r_indexes,1),jitter_scale),...
                            data(cur_r_indexes,2),...
                            marker_size, ...
                            recursive_plot_struct.data_color(cur_r_indexes,:),...
                            'filled',...
                            'MarkerEdgeColor','k',...
                            'Marker',obj.marker_type_array{r});
                    end
                end
                
                set(h,'yscale',recursive_plot_struct.yscale) 
                hold on;
                xlim([0.5 (0.5+num_recursions)]);
                
                % Set text x axis labels
                set(gca,'XTick',[1:num_recursions]);  
                x_axis_vals = [1:1:num_recursions];
                x_label_cell = cell(1, length(x_axis_vals));
                for c = 1:length(x_axis_vals)
                    x_label_cell(c) = {num2str(c)};
                end
                set(gca,'XTickLabel',x_label_cell);               
                box on;  

                % set figure attributes
                title(recursive_plot_struct.plot_title,'FontWeight','bold',...
                    'FontSize',19.6);
                xlabel(recursive_plot_struct.xlabel,...
                    'FontWeight','bold','FontSize',19.6);
                ylabel(recursive_plot_struct.ylabel,...
                    'FontWeight','bold','FontSize',19.6);     
          
                %---------------------------------------Draw line at median
                % 2012/07/03
                % data_fun_F = @(x)median(data((find((data(:,1)==x))),2));
                data_fun_F = ...
                    @(x)median(double(data((find((data(:,1)==x))),2)));
                recursion_medians = arrayfun(data_fun_F,[1:num_recursions]);
                plot([1:num_recursions],recursion_medians,'--k+');                
                
                % Create horizontal jitter
                function jdata = jitter(data, scale)
                % adapted from visualization of data, clevand
                % modeled after:
                % Copyright (c) 1998-2000 by Datatool
                    jdata = double(data)+rand(size(data))*scale - scale/2;
                end
            end
        end
        %%%%%
        %-------------------------------- Create_recursion_summary_xy_plots
        function [xy_fig_ids xy_figs_fn] = ...
            Create_recursion_summary_xy_plots...
                (obj,...
                 recursion_summary_results_struct_array, ...
                 create_recursive_xy_struct,...
                 hormone_plot)
            % Create_recursion_summary_xy_plots
            %
            % Create secretion vs clearance plots that are color coded with
            % interpulse interval
            %
            % Inputs
            %   recursion_summary_results_struct_array
            %   create_xy_struct
            %   hormone_plot
            %
            % Output
            %   xy_fig_ids
            %   xy_figs_fn
            %
            % Revisions:
            %  
            %
            
            % Program Constant
            DEBUG_FLAG = 0;    
            VARIABLE_MARKER_SIZE = 0;
            MARKER_IS_FILLED = 1;
            
            
            % Set range of marker size
            if VARIABLE_MARKER_SIZE == 1
                min_marker_size = 20;
                max_marker_size = obj.recursion_marker_size;
            else
                min_marker_size = obj.recursion_marker_size;
                max_marker_size = obj.recursion_marker_size;
            end
            
            marker_type_array = obj.marker_type_array;
           
            % Echo input to console
            if DEBUG_FLAG >= 1
                fprintf('\n\nrecursion_summary_results_struct_array:\n');
                disp(recursion_summary_results_struct_array);
                disp(recursion_summary_results_struct_array{1});
                fprintf('\n\ncreate create_recursive_xy_struct:\n');
                disp(create_recursive_xy_struct);
                fprintf('\n\ncreate hormone plot:\n');
                disp(hormone_plot);
            end
            
            % Create figure
            xy_fig_ids = figure();
            
            % set axes parameters
            axes1 = axes('Parent',xy_fig_ids,...
                'YScale','log',...
                'XScale','log',...
                'LineWidth',2,...
                'FontWeight','bold',...
                'FontSize',14);
            box(axes1,'on');
            hold(axes1,'all');            
            
            % Get min and max amplitude across recursion so that amplitudes
            % can be scaled across recursion levels
            get_min_F = @(x) min(getfield(x,'paired_amplitudes'));
            min_amp_cell = (cellfun(get_min_F, ...
                            recursion_summary_results_struct_array,...
                             'UniformOutput',0));
            get_max_F = @(x)max(getfield(x,'paired_amplitudes'));
            max_amp_cell = cellfun(get_max_F, ...
                            recursion_summary_results_struct_array,...
                            'UniformOutput',0);
            min_amp = min_amp_cell{1}(1);
            max_amp = max_amp_cell{1}(1);
            for r = 1:length(recursion_summary_results_struct_array)
                min_amp = min(min_amp, min_amp_cell{2}(1));
                max_amp = max(max_amp, max_amp_cell{2}(1));
            end
            
            % Plot secretion, clearance
            legend_str = {};
            symbol_legend = [];
            for r = 1:length(recursion_summary_results_struct_array)
                % Define scatter inputs
                xdata = ...
                    recursion_summary_results_struct_array{r}.paired_secretion_rates;
                ydata = ...
                    recursion_summary_results_struct_array{r}.paired_clearance_rates;
                
                % Set marker size according to amplitude
                marker_shape = marker_type_array{r};
                marker_size = visual_scale(...
                        recursion_summary_results_struct_array{r}.paired_amplitudes,...
                        [min_amp, max_amp],...
                        [min_marker_size, max_marker_size], 'linear');

                    
                % Create scatter plot
                ch_bool = create_recursive_xy_struct.USE_TEMPORAL_COLORMAP_FOR_RECURSION_PLOTS;
                if ch_bool == 1
                    % Plot color scaled by time of occurance
                    
                    % Get time data
                    tdata = ...
                        recursion_summary_results_struct_array{r}.paired_secretion_rates_cum_times;
                    
                    % Calculate color for each time point
                    array_var = tdata;
                    var_range = [0 hormone_plot.T];
                    var_colormap = ...
                        create_recursive_xy_struct.temporal_color_map;
                    var_color = ...
                        get_color_array(array_var, var_range, var_colormap);
                   
                   
                    % create scatter plot
                    if MARKER_IS_FILLED == 1
                        symbol_handle = scatter(xdata, ydata,  marker_size ,...
                            var_color, marker_type_array{r},'filled',...
                            'MarkerEdgeColor','k'); 
                    else
                        symbol_handle = scatter(xdata, ydata,  marker_size ,...
                            var_color, marker_type_array{r});
                    end
                    set(xy_fig_ids,'Colormap', var_colormap);                    
                else
                    % plot a single color
                    d_color = create_recursive_xy_struct.data_color;
                    symbol_handle = scatter(xdata, ydata,  marker_size ,d_color,...
                        marker_type_array{r});  
                end
                hold on;
                
                % set legend string
                symbol_legend(r) = symbol_handle;
                legend_str{r} =num2str(r);
            end
             % Create legend
%             legend(symbol_legend(1:end-1), legend_str{1:end-1},...
%                 'Location','Northwest');
            
            % set figure attributes
            figure(xy_fig_ids)
            fig_title = create_recursive_xy_struct.titles;
            fig_xlabel = create_recursive_xy_struct.xlabels;
            fig_ylabel = create_recursive_xy_struct.ylabels;
            
            title(fig_title,'FontWeight','bold','FontSize',19.6);
            xlabel(fig_xlabel, 'FontWeight','bold','FontSize',19.6);
            ylabel(fig_ylabel, 'FontWeight','bold','FontSize',19.6);
            
            % Define figure name
            xy_figs_fn = sprintf('recursion_summary_xy');
            
            %------------------------------------------------- visual_scale
            function scaled_x = visual_scale...
                                  (x, data_range, marker_range, scale_type)
                % visual_scale
                % Function rescales the data to the entered range
                
                
                % Define local vairables
                s_min = marker_range(1);
                s_max = marker_range(2);
                d_min = data_range(1);
                d_max = data_range(2);
                
                % Check input
                if s_max < s_min
                   t = s_min; s_min = s_max; s_max = s_min; 
                end
                 
                % scale data according to type
                if strcmp (upper('Linear'),upper(scale_type))
                    x = x;
                elseif strcmp(upper('Log'),upper(scale_type))
                    x = log(x);
                else
                    x = x;
                end
                
                % rescale if possible, default
                if (d_max-d_min) <= 0
                    scaled_x = onese(size(x))*s_max;
                else
                    scaled_x = ...
                        (x - d_min)/(d_max-d_min)*(s_max-s_min)+s_min;
                end
            end
        end
        %----------------- Create_single_variable_histograms_from_recursion
        function [histogram_fig_ids histogram_fig_fn] = ...
            Create_single_variable_histograms_from_recursion...
                (recursion_summary_results_struct_array, ...
                    create_histogram_struct)
            % Create_single_variable_histograms_from_recursion
            % 
            % Create histograms for functions listed in the 
            % create histogram structre
            %
            % Input
            %   recursion_summary_results_struct_array
            %       paramters by recursion level
            %   create_historgram_stuct
            %       variables - cell array
            %       titles - cell array
            %       xlabels - cell array
            %       ylables - cell array
            %
            % Output
            %   histogram_fig_ids - array of figure ids
            %
            
            % Function Constant
            DEBUG_FLAG = 0;
            
            % Define return variable
            histogram_fig_ids = [];
            
            % Echo input to console in DEBUG mode
            if DEBUG_FLAG == 1
                fprintf('\nrecursion_summary_results_struct_array:\n');
                disp(recursion_summary_results_struct_array);
                fprintf('\ncreate_histogram_stuct:\n');
                disp(create_histogram_struct);
            end
            
            % Determine number of histograms to plot
            
            % Merge data
            num_fields = length(create_histogram_struct);
            for f = 1:num_fields
                % Generate command to get data
                field_str = create_histogram_struct(f).variables;  
                get_data_cmd = ...
                    sprintf('recursion_summary_results_struct_array{%d}.%s',...
                        1, field_str);
                     
                % Create hist struct with data
                hist_struct = create_histogram_struct(f);
                hist_struct = setfield(hist_struct,'data',eval(get_data_cmd));
                
                % Create
                fig_id = create_hist_from_struct(hist_struct);
                
                % Save figure id
                histogram_fig_ids(f) = fig_id;
                histogram_fig_fn{f} = strcat(field_str,'_hist');
            end
            
            %-------------------------------------- create_hist_from_struct
            function fig_id = create_hist_from_struct(hist_struct)
            % create_hist_from_struct
            
                % Get or create figure
                if isfield(hist_struct,'fig_id') 
                    figure(hist_struct.fig_id);
                else
                    fig_id = figure('InvertHardcopy','off','Color',[1 1 1]);
                end
                
                % Check number of discrete bins
                bins = double(sort(unique(hist_struct.data)));
                
                % Create histogram
                if length(bins) > 6
                    hist(double(hist_struct.data))
                else
                    hist(double(hist_struct.data),bins)
                end
                
                box on
                
                % set axes parameters
                h = findobj(gca,'Type','patch');
                set(h,'LineWidth',2, 'FaceColor','flat')
                set(gca,'FontSize',14)
                set(gca,'FontWeight','bold')      
                set(gca,'LineWidth',2)
                
                
                
                % Create Labels
                title(hist_struct.titles,'FontWeight','bold',...
                    'FontSize',19.6)
                xlabel(hist_struct.xlabels,...
                    'FontWeight','bold','FontSize',19.6);
                ylabel(hist_struct.ylabels,...
                    'FontWeight','bold','FontSize',19.6);
            end
            
        end
        %---------------------------------------------- create_scatter_data
        function [xy_fig_ids xy_fig_fn ] = Create_xy_plots_from_recursion...
                (recursion_summary_results_struct_array, create_xy_struct) 
            % Create XY plots
            %
            % Create rise run plots
            %
            % Inputs
            %   recursion_summary_results_struct_array
            %   create_xy_struct
            %
            % Output
            %   xy_fig_ids
            %   xy_fig_fn
            %
            % Revisions:
            %   2010_21_09 Revised to return properally aligned peak-valley
            %      pairs to be used to create group summary plot.  Should
            %      revise program to make peak-valley pair construction
            %      independent.
            
            % Program Constant
            DEBUG_FLAG = 0;
            color_array = [[0 0 1];[1 0 0];[0 1 0]];
            
            % Echo input to console
            if DEBUG_FLAG == 1
                fprintf('\n\nrecursion_summary_results_struct_array:\n');
                disp(recursion_summary_results_struct_array);
                fprintf('\n\ncreate xy struct:\n');
                disp(create_xy_struct);
            end
            
                        % Determine number of histograms to plot
            
            % Create plots for each data set
            num_fields = length(create_xy_struct);
            merge_data_x = [];
            merge_data_y = [];
            data_key = [];
            merged_color_key = [];
            for f = 1:num_fields
                % Generate command to get data
                field_cell = create_xy_struct(f).variables; 
                
                field_str_x = field_cell{1};
                field_str_y = field_cell{2};
                
                get_data_cmd_1 = ...
                    sprintf('recursion_summary_results_struct_array{%d}.%s',...
                        1, field_str_x);
                get_data_cmd_2 = ...
                    sprintf('recursion_summary_results_struct_array{%d}.%s',...
                        1, field_str_y);
                % Echo to console on debug
                if DEBUG_FLAG == 1
                    fprintf('\nxy plot\n--- field_str_x: %s\n', field_str_x);
                    fprintf('--- --- field_str_y: %s\n', field_str_y);
                    fprintf('--- --- get_data_cmd_1: %s\n', get_data_cmd_1);
                    fprintf('--- --- get_data_cmd_2: %s\n', get_data_cmd_2);
                end
                    
                %----------------------------------------- Separate figures
                % Create hist struct with data
                xy_struct = create_xy_struct(f);
                xy_struct = setfield(xy_struct,'data_x',...
                    eval(get_data_cmd_1));
                xy_struct = setfield(xy_struct,'data_y',...
                    eval(get_data_cmd_2));
                xy_struct = setfield(xy_struct,'merged_data', 0);
                xy_struct = setfield(xy_struct,'fit_data', 0);
                
                % Create
                scat_color = color_array(f,:);
                fig_id = create_xy_from_struct(xy_struct, scat_color);
                
                % Save figure id
                indiv_xy_fig_ids(f) = fig_id;
                xy_fig_fn{f} = strcat(field_str_x,'_',field_str_y,'_xy_plot');
                
                %------------------------------------------- Combined data
                merge_data_x = [merge_data_x; xy_struct.data_x];
                merge_data_y = [merge_data_y; xy_struct.data_y];
                data_key = [data_key; ones(length(xy_struct.data_x),1)*f];
                merged_color_key = [merged_color_key; ...
                    ones(length(xy_struct.data_x),1)*color_array(f,:)];

            end
            
            %--------------------------------------- Create combine figure
            % Create hist struct with data
            xy_struct = create_xy_struct(f);
            xy_struct.variables = {'fall_times'  'amplitude_falls'};
            xy_struct.titles = xy_struct.title;
            xy_struct.xlabels = 'Duration (min)';
            xy_struct.ylabels = 'Amplitude(ug/dL)';
            
            xy_struct = setfield(xy_struct,'data_x', merge_data_x);
            xy_struct = setfield(xy_struct,'data_y', merge_data_y);
            xy_struct = setfield(xy_struct,'data_key', data_key);
            xy_struct = setfield(xy_struct,'merged_data', 1);
            xy_struct = setfield(xy_struct,'fit_data', 1);

            xy_struct = setfield(xy_struct,'secrete_hist_xlabel', ...
                'Accumulation Rate ug/(dL min)');
            xy_struct = setfield(xy_struct,'clearance_hist_xlabel', ...
                'Dissipation Rate ug/(dL min)');
            
            % legend_str = {'Fall', 'Rise' };
            % xy_struct = setfield(xy_struct,'legend_str', legend_str);
            
            if DEBUG_FLAG == 1
            	fprintf('--- --- --- merge x len: %d, merge y len: %d\n'...
                    ,length(xy_struct.data_x), length(xy_struct.data_y));      
            end
            
            % Create Combined plot
            [merged_xy_fig_ids  merged_xy_fig_fns]= ...
                create_xy_from_struct(xy_struct, merged_color_key);  
            
            
            %---------------------------------------- Prepare return values
            % Combine figures ids
            xy_fig_ids = [indiv_xy_fig_ids , merged_xy_fig_ids];
%             xy_fig_fn{f+1} = strcat(field_str_x,'_',field_str_y,...
%                 '_merged_xy_plot');
            
            % Combine file names
            xy_fig_fn = [xy_fig_fn, merged_xy_fig_fns];
            
            %---------------------------------------- create_xy_from_struct
            function varargout = ...
                    create_xy_from_struct(xy_struct, scat_color)
            % create_xy_from_struct
            % 
            % input
            %     xy_struct: information for creating scatter plot
            %
            %       variables: {'rise_times'  'amplitudes'}
            %          titles: 'Cortisol 23C - Rise'
            %         xlabels: 'Duration (Min)'
            %         ylabels: 'Amplitudes (ug/dL)'
            %           title: 'Cortisol 23C (blue-rise, red-fall)'
            %        fit_data: 0
            %       title_str: 'Cortisol 23C'
            %          data_x: [26x1 int32]
            %          data_y: [26x1 double]
            %     merged_data: 0
            %
            %     scat_color: either 1x3 or Nx3
                
                % Echo input to console during DEBUG
                if DEBUG_FLAG == 1
                    xy_struct
                    scat_color
                end
               
                % Get or create figure
                if isfield(xy_struct,'fig_id') 
                    figure(xy_struct.fig_id);
                else
                    fig_id = figure('InvertHardcopy','off','Color',[1 1 1]);
                end
                
                % Create xy plot
                pt_size = 25;
                if length(scat_color) == 3
                    % Assume scat colot is a color vector that needs to be
                    % maped an array
                    color_key = ones(length(xy_struct.data_x),1)*scat_color;
                else
                    % Assume color setup correctly
                    color_key = scat_color;
                end
                scatter(xy_struct.data_x, xy_struct.data_y,...
                    pt_size, color_key);
                box on;
                
                % Export to create an orign plot
                %temp = [double(xy_struct.data_x),xy_struct.data_y,double(color_key)];
                %xlswrite('temp.xls',temp);
                
                
                % set axes parameters
                h = findobj(gca,'Type','patch');
                set(h,'LineWidth',2, 'FaceColor','flat')
                set(gca,'LineWidth',2)
                set(gca,'FontSize',14)
                set(gca,'FontWeight','bold')                
                
                % 
                % Create Labels
                title(xy_struct.titles,'FontWeight','bold',...
                    'FontSize',19.6)
                xlabel(xy_struct.xlabels,...
                    'FontWeight','bold','FontSize',19.6);
                ylabel(xy_struct.ylabels,...
                    'FontWeight','bold','FontSize',19.6);
                
                % Set legend text
                if isfield(xy_struct,'legend_str') == 1
                    xy_struct.legend_str
                    legend_cmd = sprintf('legend(''%s'', ''%s'',''box'',''off'',''Location'',''SouthEast'')',...
                        xy_struct.legend_str{1},xy_struct.legend_str{2});
                    eval(legend_cmd);
                end
                
                % Add linear fit
                if and( xy_struct.fit_data == 1, ...
                        xy_struct.merged_data == 1)
                    % Identify rise and fall data
                    data_key = unique(xy_struct.data_key);
                    rise_index = find(data_key(1) == xy_struct.data_key);
                    fall_index = find(data_key(2) == xy_struct.data_key);
                    
                    % Fit rise data to a line
                    n = 1;
                    rise_data = [xy_struct.data_x(rise_index),...
                                 xy_struct.data_y(rise_index)];
                    rise_data = sort(double(rise_data));                    
                    p_rise = ...
                        polyfit(rise_data(:,1), rise_data(:,2), n);
                    [p S_rise mu] = ...
                        polyfit(rise_data(:,1), rise_data(:,2), n);
                    fall_data = [xy_struct.data_x(fall_index),...
                                 xy_struct.data_y(fall_index)];
                    fall_data = sort(double(fall_data));  
                    p_fall  = ...
                        polyfit(fall_data(:,1), fall_data(:,2), n);
                    [p, S_fall mu]  = ...
                        polyfit(fall_data(:,1), fall_data(:,2), n);       
                    
                    % Create return structure
                    xy_fit_struct = struct(...
                       'p_rise',p_rise, 'p_fall',p_fall); 
                   
                   % Add line to figure
                   figure(fig_id);hold on;
                   x_start =  min(xy_struct.data_x(rise_index));
                   x_end = max(xy_struct.data_x(rise_index));
                   x = double([x_start:1:x_end])';
                   [y delta] = polyval(p_rise,x, S_rise);
                   plot(x(1:end),y(1:end),'-b','LineWidth', 2);
                   line_fit_struct_secrete = linearFit(...
                       double(xy_struct.data_x(rise_index)),...
                       double(xy_struct.data_y(rise_index)));
                   
                   x_start = min(xy_struct.data_x(fall_index));
                   x_end = max(xy_struct.data_x(fall_index));
                   x = double([x_start:1:x_end])';
                   [y delta] = polyval(p_fall,x, S_fall);
                   plot(x(1:end),y(1:end),'-r','LineWidth', 2); 
                   line_fit_struct_clearance = linearFit(...
                       double(xy_struct.data_x(fall_index)),...
                       double(xy_struct.data_y(fall_index)));

                   % Estimate secretion and clearnace rate
                   secretion_rate = double(xy_struct.data_y(rise_index))./...
                                    double(xy_struct.data_x(rise_index));
                   clearance_rate = double(xy_struct.data_y(fall_index))./...
                                    double(xy_struct.data_x(fall_index)); 
                   
                   % Sumarize results to console
                   fprintf('%s\n',xy_struct.title_str);
                   fprintf('average accumulation rate = %.3f ug/(dL min), (%.3f, %.3f), gof rsquare = %.3f\n',...
                       line_fit_struct_secrete.slope, line_fit_struct_secrete.slope_lw_ci, ...
                       line_fit_struct_secrete.slope_up_ci, ...
                       line_fit_struct_secrete.gof_rsquare )
                   fprintf('accumulation rate summary (min = %.3f, median = %.3f, max = %.3f)\n',...
                       min(secretion_rate),median(secretion_rate), max(secretion_rate));
                   
                   fprintf('\n%s\n',xy_struct.title_str);
                   fprintf('average dissipation rate = %.3f ug/(dL min), (%.3f, %.3f), gof rsquare = %.3f\n', ...
                       line_fit_struct_clearance.slope, line_fit_struct_clearance.slope_lw_ci, ...
                       line_fit_struct_clearance.slope_up_ci, ...
                       line_fit_struct_clearance.gof_rsquare )                                
                   fprintf('dissipation rate summary (min = %.3f, median = %.3f, max = %.3f)\n\n',...
                       min(clearance_rate),median(clearance_rate), max(clearance_rate));
                                
                   %-------------------------------Secretion rate histogram                  
                   % compute bins for the 0.5
                   range = 0.5;
                   w = range/10;
                   x = [w/2:w:range];
                   
                   fig_secrete_hist = figure ...
                       ('InvertHardcopy','off','Color',[1 1 1]);
                   [n, xout] = hist(secretion_rate);
                   hist(secretion_rate);
                   %histc(secretion_rate,[0:0.05:0.5]);
                   box on
                   
                   % set axes parameters
                   h = findobj(gca,'Type','patch');
                   set(h,'LineWidth',2, 'FaceColor','flat');
                   set(gca,'FontSize',14); 
                   set(gca,'FontWeight','bold');                
                   set(gca,'LineWidth',2);   
                   
                   % Create Labels
                   title(sprintf('%s',xy_struct.title_str),...
                        'FontWeight','bold', 'FontSize',19.6)
                   xlabel(xy_struct.secrete_hist_xlabel,...
                        'FontWeight','bold','FontSize',19.6);
                   ylabel('Count',...
                        'FontWeight','bold','FontSize',19.6);
                  
                   %------------------------------Clearance rate histogram
                   range = 0.2;
                   w = range/10;
                   x = [w/2:w:range];
                   
                   fig_clear_hist = ...
                       figure('InvertHardcopy','off','Color',[1 1 1]);
                   [n, xout]= hist(clearance_rate);
                   % removed sacling so that it worked with all versions
                   hist(clearance_rate);
                   %hist(clearance_rate,[0:0.02:0.2]);
                   box on
                   
                   % set axes parameters
                   h = findobj(gca,'Type','patch');
                   set(h,'LineWidth',2, 'FaceColor','red');
                   set(gca,'FontSize',14);
                   set(gca,'FontWeight','bold');                
                   set(gca,'LineWidth',2);  
                   
                   % Create Labels
                   title(sprintf('%s', xy_struct.title_str),...
                        'FontWeight','bold', 'FontSize',19.6);
                   xlabel(xy_struct.clearance_hist_xlabel,...
                        'FontWeight','bold','FontSize',19.6);
                   ylabel('Count',...
                        'FontWeight','bold','FontSize',19.6);
                
                else
                    % Create return value just in case
                    xy_fit_struct = struct(...
                       'p_rise',[], 'S_rise', [], 'mu_rise', [],...
                       'p_fall',[], 'S_fall', [], 'mu_fall', []) ;             
                end
                
                % Prepare figure ids for return
                if xy_struct.merged_data == 1
                    return_figure_ids = ...
                        [ fig_id, fig_secrete_hist, fig_clear_hist];
                else
                    return_figure_ids =  fig_id;   
                end    
                
                % Prepare figure ids for return
                xy_fn = sprintf('xy_plot_%s__%s', xy_struct.variables{1}...
                    , xy_struct.variables{2});
                if xy_struct.merged_data == 1
                    % Define histogram file names
                    hist_secrete_fn = 'hist_secrete';
                    hist_clear_fn = 'hist_clear';
                    
                    % Create return filename value
                    return_figure_fns = {xy_fn, hist_secrete_fn, ...
                        hist_clear_fn};
                else
                    return_figure_fns = {xy_fn};
                end   
                
                % Prepare return values
                if nargout == 1 
                    varargout = {return_figure_ids};
                elseif nargout == 2
                    varargout = {return_figure_ids, return_figure_fns};
                elseif nargout == 3
                    varargout = {return_figure_ids, return_figure_fns, ...
                        xy_fit_struct};
                end
                
            end

        end
        %-------------------------------------- Create_gplot_from_recursion
        function [ms_fig_ids ms_figs_fns] = Create_gplot_from_recursion...
         (recursion_summary_results_struct_array, create_gplot_struct,...
          hormone_plot)          
         % Create a gplotplot to identify between rise and fall 
         % distributions. Code uses matlab code and is devloped to generate
         % stastitcal comparisons of first, second, and third quadrant of
         % data
         %
            % Program Constants
            DEBUG_FLAG = 0;
            MIN_NUM_POINTS_TO_PLOT = 5;
            
            % Echo inputs to console
            if DEBUG_FLAG == 1
                recursion_summary_results_struct_array
                create_multiscatter_struct
                recursion_summary_results_struct_array{1}
            end
            
            % define data access function
            get_var_f = @(x)create_gplot_struct(x).variables;
            get_data_f = @(x,y)eval(...
                sprintf('recursion_summary_results_struct_array{%d}.%s',...
                    x, get_var_f(y)));
            get_labels_f = @(y)create_gplot_struct(y).var_labels;
            get_ext_valley_locs_f = @(x)eval(...
                sprintf('recursion_summary_results_struct_array{%d}.%s',...
                    x, create_gplot_struct(1).time_loc_var));
            get_t_f = @(x)eval(sprintf(...
                'recursion_summary_results_struct_array{%d}.%s',x,...
                    create_gplot_struct(1).time_var));
                
            % Determine size of scatter plot to create
            num_vars = length(create_gplot_struct);
            num_recurse = length(recursion_summary_results_struct_array);
            n = ones(num_recurse,1)*Inf;
            for r = 1:num_recurse
                for v = 1: num_vars
                    n(r) = min(n(r),length(get_data_f(r,v)));
                end   
            end
            max_recurse_to_plot = max(find(n >= MIN_NUM_POINTS_TO_PLOT));
            
            % Create plot for each recursion level that has more than five
            % points
            for r = 1:max_recurse_to_plot
                % get data for each varaibles
                data = double([]);
                data_labels = {};
                for v = 1: num_vars
                    r_data = get_data_f(r,v);
                    data = [data,double(r_data(1:n(r)))];
                    data_labels{v} = sprintf('%s - %d',get_labels_f(v),r);
                end   

                % Get times for each entry (start time of grouping) and
                % assign segment number
                locs = get_ext_valley_locs_f(r);
                t = get_t_f(r);
                t = t(locs(1:end-1));
                segment = ceil((double(t)/double((8.0*60.0))));
                segment_2 = ceil((double(t)/double((4.0*60.0))));
                
                % Identify zero segments
                zero_index = find(segment==0);
                if ~isempty(find(segment==0))
                    % Change '0' segments to 1
                    segment(find(segment==0)) = 1;
                end
                
                % Create scatter plots
                data_description = sprintf('%s %d%s', ...
                    hormone_plot.data_type_str,...
                    hormone_plot.subject_id,...
                    hormone_plot.group_id_str);
                
                [ms_fig_id ms_figs_fn] = scattermatrix_pulse...
                (data,data_labels, data_description);
            
            
                % Create gplot matrix
                if length(segment) == size(data,1)
                    gplot_fig_id = figure();
                    xlabels = []; %create_gplot_struct.var_labels;
                    gplotmatrix(data,[],segment,[],'+xo');
                end
                
                % MANOVA
                if DEBUG_FLAG == 1
                    if and(and (r == 1, (size(data,1)==length(segment))), ...
                       (size(data,1)==length(segment_2)))
                        fprintf('---- segment - 8 hr\n')
                        [d,p,stats] = manova1(data,segment);
                        fprintf('---- segment - 4 hours\n')
                        [d,p,stats] = manova1(data,segment_2);
                    end
                end
                
                % Save figure id and file number
                ms_fig_ids(r) = ms_fig_id;
                ms_figs_fns{r} = sprintf('%s_%d_%d',...
                    ms_figs_fn, num_vars, r);
            end
        end
        %------------------------------- Create_multiscatter_from_recursion
        function [ms_fig_ids ms_figs_fns] = Create_multiscatter_from_recursion...
         (recursion_summary_results_struct_array, create_multiscatter_struct,...
          hormone_plot)          
         % Create a multi-scatter plot to identify between rise and fall 
         % distributions. Code uses free code developed by dataViz to mimic 
         % plots presented in Clevland et. al
            
            % Program Constants
            DEBUG_FLAG = 0;
            MIN_NUM_POINTS_TO_PLOT = 5;
            
            % Echo inputs to console
            if DEBUG_FLAG == 1
                recursion_summary_results_struct_array
                create_multiscatter_struct
            end
            
            % define data access function
            get_var_f = @(x)create_multiscatter_struct(x).variables;
            get_data_f = @(x,y)eval(sprintf('recursion_summary_results_struct_array{%d}.%s',x, get_var_f(y)));
            get_labels_f = @(y)create_multiscatter_struct(y).var_labels;  
            if isfield(create_multiscatter_struct, 'plot_labels')
                get_labels_f2 = @(y)create_multiscatter_struct(y).plot_labels;
            end
            
            %plot_labels
            % Determine size of scatter plot to create
            num_vars = length(create_multiscatter_struct);
            num_recurse = length(recursion_summary_results_struct_array);
            n = ones(num_recurse,1)*Inf;
            for r = 1:num_recurse
                for v = 1: num_vars
                    n(r) = min(n(r),length(get_data_f(r,v)));
                end   
            end
            max_recurse_to_plot = max(find(n >= MIN_NUM_POINTS_TO_PLOT));
            
            % Create plot for each recursion level that has more than five
            % points
            for r = 1:max_recurse_to_plot
                data = double([]);
                data_labels = {};
                data_labels_2 = {};
                for v = 1: num_vars
                    r_data = get_data_f(r,v);
                    data = [data,double(r_data(1:n(r)))];
                    data_labels{v} = sprintf('%s - %d',get_labels_f(v),r);
                    if isfield(create_multiscatter_struct, 'plot_labels')
                        data_labels_2{v} = sprintf('%s - %d',get_labels_f2(v),r);
                    end
                end   

                % Create scatter plots
                data_description = sprintf('%s %d%s', ...
                    hormone_plot.data_type_str,...
                    hormone_plot.subject_id,...
                    hormone_plot.group_id_str);
                
                if isfield(create_multiscatter_struct, 'plot_labels')
                    [ms_fig_id ms_figs_fn] = scattermatrix_pulse...
                    (data,data_labels_2, data_description);
                else
                    [ms_fig_id ms_figs_fn] = scattermatrix_pulse...
                    (data,data_labels, data_description);
                end
                


            
                % Save figure id and file number
                ms_fig_ids(r) = ms_fig_id;
                ms_figs_fns{r} = sprintf('%s_%d_%d',...
                    ms_figs_fn, num_vars, r);
            end
            
            
            
        end
        %------------------------ Create_hormone_text_figure_from_recursion
        function [ms_fig_ids ms_figs_fns recursion_string_summary] = ...
                Create_hormone_text_figure_from_recursion...
                    (recursion_summary_results_struct_array, ...
                        create_pulse_text_fig_struct,...
                            hormone_plot)          
         %Create_hormone_text_figure_from_recursion function uses a 
         % distributions. Code uses free code developed by dataViz to mimic 
         % plots presented in Clevland et. al
            
            % Program Constants
            DEBUG_FLAG = 0;
            
            % Echo inputs to console
            if DEBUG_FLAG == 1
                recursion_summary_results_struct_array
                recursion_summary_results_struct_array{1}
                create_pulse_text_fig_struct
            end
            
            % Create text array for each entry
            textPulseObj = textPulse (hormone_plot,...
                recursion_summary_results_struct_array, hormone_plot.T);
            
            % write latex to console
            textPulseObj.show_intermediate_recursion_results = 1;
            textPulseObj.show_recursion_results = 1;
            textPulseObj.show_latex = 1;
            
            % Create a figure for each recursion level
            ms_fig_ids = [];
            ms_figs_fns = {};
            recursion_string_summary = struct('text_pulse_str', '', ...
                'latex_pulse_str', '');
            for r = 1:length(recursion_summary_results_struct_array)
                % Define parameters
                textPulseObj.prn_level = r; % max textPulseObj.num_recursions;   
                textPulseObj.show_terminal_peak = 1;
                textPulseObj.show_recursive_peaks = 1;
   
                % Create string
                text_pulse_str = textPulseObj.text_pulse_str;
                latex_pulse_str = textPulseObj.latex_pulse_str;
    
                % Create figure
                latex_fig_id = textPulseObj.create_latex_figure;
                
                % Store results
                recursion_string_summary(r).text_pulse_str = text_pulse_str;
                recursion_string_summary(r).latex_pulse_str = ...
                    latex_pulse_str;
                ms_fig_ids = [ms_fig_ids, latex_fig_id];
                ms_figs_fns{r} = sprintf('pulse_str_%d',r);
            end
            
        end       
        %------------------------------------- create_recursion_plot_struct
        function [rp_fig_ids rp_figs_fn] = Create_variable_recursion_plots...
         (recursion_summary_results_struct_array, create_recursion_plot_struct)          
         % Create a multi-scatter plot to identify between rise and fall 
         % distributions. Code uses free code developed by dataViz to mimic 
         % plots presented in Clevland et. al
         % 
         % Legacy - can probablly delete
         %
            % Program Constants
            DEBUG_FLAG = 0;
            
            % Echo inputs to console
            if DEBUG_FLAG == 1
                recursion_summary_results_struct_array
                create_recursion_plot_struct
            end
            
            % Get variable infomration
            vars_1 = create_recursion_plot_struct(1).variables;
            vars_2 = create_recursion_plot_struct(2).variables;
            vars_3 = create_recursion_plot_struct(3).variables;
            vars_4 = create_recursion_plot_struct(4).variables;
            
            % Get Command information
            cmd_1 = sprintf('recursion_summary_results_struct_array{1}.%s', vars_1);
            cmd_2 = sprintf('recursion_summary_results_struct_array{1}.%s', vars_2);            
            cmd_3 = sprintf('recursion_summary_results_struct_array{1}.%s', vars_3);
            cmd_4 = sprintf('recursion_summary_results_struct_array{1}.%s', vars_4);
                   
            % Get data and labels
            d1 = eval(cmd_1); d2 = eval(cmd_2); d3 = eval(cmd_3);d4 = eval(cmd_4);
            n = min([length(d1), length(d2), length(d3), length(d4)]);
            data = [d1(1:n), d2(1:n), d3(1:n), d4(1:n)];
            data_labels = {create_recursion_plot_struct(1).var_labels, ...
                create_recursion_plot_struct(2).var_labels, ...
                create_recursion_plot_struct(3).var_labels, ...
                create_recursion_plot_struct(4).var_labels};
            
            % Call scatter plots
%             [rp_fig_ids rp_figs_fn] = scattermatrix_pulse...
%                 (data,data_labels);
            rp_fig_ids = [];
            rp_figs_fn = [];
        end       
        %---------------------------------------- generate_recursion_string
        function fig_id = plot_data_w_selected_points(varargin)
            % plot_data_w_selected_points function plot at time series
            % and vertical lines at selected points.
            %
            
            % Process input
            if nargin == 3
                t = varargin{1};
                y = varargin{2};
                selected_times = varargin{3};
                fig_id = figure();
            else
                t = varargin{1};
                y = varargin{2};
                selected_times = varargin{3};
                fig_id = varargin{4};
            end
            
            % Plot data
            figure(fig_id);
            plot(t,y)
            
            % Identify each missing segment
            v = axis();
            
            % Plot a vertical line at each point
            for m = 1:length(selected_times)
                % Plot line at location
                line([selected_times(m);selected_times(m)],v(3:4)',...
                    'LineStyle','-','color',[1 1 0]);
            end
        end % end plot_data_w_selected_points
        %---------------------------------------- generate_recursion_string
        function v = set_fig_max_x_xtick(fig_id, max_struct)
            % set_max_time(fig_id, max_time)
            %
            % The function sets the maximum time for the selected graph
                       
            % Select and adjust figure
            figure(fig_id);
            
            % Adjust figure axis
            v = axis();
            v(2) = max_struct.x;
            axis(v);
            
            % Set axis labels
            set(gca,'XTick',max_struct.x_tick_loc);
            set(gca,'XTickLabel',max_struct.x_tick_labels);
        end
        %--------------------------------------------- summarize_non_normal
        function array_summary = summarize_non_normal_array(array_data)
            % set_max_time(fig_id, max_time)
            %
            % The function sets the maximum time for the selected graph
                       
            % summarized array
            array_summary.min = min(array_data);
            array_summary.median = min(array_data);
            array_summary.max = min(array_data);
        end
        %----------------------------------------------- display_vector_int
        function display_vector_int(data_vec)
        %
        % display_vector_int
        %
        % Input:
        %   data_vec - array of integers
        % 
        % Output:
        %   Tab delimited list at the console.
        %
        %
        
        
            % Write array to console
            fprintf('(\t%d',data_vec(1))
            for i = 2:length(data_vec)
                fprintf(' \t%d',data_vec(i))
            end
            fprintf(')\n');
        end
        %--------------------------------------------------- display_vector
        function display_vector(varargin)
        %
        % display_vector
        %
        % Input:
        %   data_vec - array of floats
        %   precision - number of digits following the decimal
        %   field_length  - number characters allocated for entry
        % 
            % Default Values
            precision = 2;
            field_length = 10;
            
            % Process input and override defaults if necessary
            if nargin == 1
                data_vec = varargin{1};
            elseif nargin == 2
                data_vec = varargin{1};
                precision = varargin{2};
            elseif nargin == 3
                data_vec = varargin{1};
                precision = varargin{2};
                field_length = varargin{3};
            else
                error('display_vector(data_vec), display_vector(data_vec, precision), display_vector(data_vec, precision, field_length)');
            end
            
            % Echo array to console
            if length(data_vec) >= 1
                % Generate output string based on 
                start_command_str = sprintf('fprintf(''(\t%%.%df'',data_vec(1))', ...
                    precision);
                loop_command_str = sprintf('fprintf('' \t%%.%df'',data_vec(i))', ...
                    precision);
            
                % Write array to console
                eval(start_command_str);
                for i = 2:length(data_vec)
                    eval(loop_command_str);
                end
                fprintf(')\n');
            else
                % Print brackets for an empty array
                fprintf('( )\n');
            end
        end
        %----------------------------------- return_vallid_peak_valley_pair
        function [p_loc v_loc] = return_vallid_peak_valley_pairs...
                (local_peaks_times, local_valleys_times, ...
                 local_peaks_times_locs, local_valleys_times_locs)
            % return_secrete_vallid: takes a location, time, and amplitude
            % array, and returns values that allow for quick calculation of
            % secretion values in matrix form.
            %
            % Example of secrete vallid
            %   P        .    .    .   .
            %   V     .    .    .   .
            %
            % There are four cases where that divide into even and odd
            % cases
            %
            
            % Determine which set of cases input belongs to
            total_num_points = length(local_peaks_times_locs)+ ...
                length(local_valleys_times_locs);
            even_case = rem(total_num_points,2)==0;
            
            if even_case == 1
                start_ok = (local_peaks_times(1)-local_valleys_times(1))> 0;
                if total_num_points <= 2
                    % Vallid peak-valley pair can not exist
                    p_loc = [];
                    v_loc = [];
                elseif start_ok
                    % pass orignial locations back
                    p_loc = local_peaks_times_locs(1:end-1);
                    v_loc = local_valleys_times_locs;
                else
                    % Extra starting peak 
                    p_loc = local_peaks_times_locs(2:end);
                    v_loc = local_valleys_times_locs;
                end
            else
                if length(local_valleys_times)>length(local_peaks_times)
                    % vallid set
                    p_loc = local_peaks_times_locs;
                    v_loc = local_valleys_times_locs;
                elseif total_num_points >= 3
                    % Extra starting and ending  peak
                    p_loc = local_peaks_times_locs(2:end-1);
                    v_loc = local_valleys_times_locs;
                else
                    % not enough points
                    p_loc = [];
                    v_loc = [];
                end
                
                if length(p_loc) + length(v_loc) <3
                    % Double check  
                    p_loc = [];
                    v_loc = [];
                end
            end
        end
        %------------------------------------------ return_clearance_vallid
        function [p_loc v_loc] = return_clearance_vallid...
                (local_peaks_times, local_valleys_times, ...
                 local_peaks_times_locs, local_valleys_times_locs)
            % return_secrete_vallid: takes a location, time, and amplitude
            % array, and returns values that allow for quick calculation of
            % secretion values in matrix form.
            %
            % Example of secrete vallid
            %   P        .    .    .   .
            %   V     .    .    .   .
            %
            % There are four cases where that divide into even and odd
            % cases
            %
            
            % Determine which set of cases input belongs to
            even_case = rem(length(local_peaks_times_locs)+ ...
                length(local_valleys_times_locs),2)==0;
            
            if even_case == 1
                even_ok = (local_valleys_times(1)-local_peaks_times(1))> 0;
                if even_ok
                   % pass orignial locations back
                   p_loc = local_peaks_times_locs;
                   v_loc = local_valleys_times_locs;
                else
                   % Extra starting peak and extra ending valley
                   p_loc = local_peaks_times_locs(1:end-1);
                   v_loc = local_valleys_times_locs(2:end);
                end  
            else
                % odd case
                if and( ~isempty(local_peaks_times), ...
                        ~isempty(local_valleys_times) )
                    extra_start_valley = (local_peaks_times(1)-local_valleys_times(1))>= 0;
                    if extra_start_valley
                        % extra ending valley
                        p_loc = local_peaks_times_locs;
                        v_loc = local_valleys_times_locs(2:end);
                    else
                        % Extra ending  peak
                        p_loc = local_peaks_times_locs(1:end-1);
                        v_loc = local_valleys_times_locs;
                    end
                else
                   % pass back original locations back
                   % assume future combputation knows how to handle
                   p_loc = local_peaks_times_locs;
                   v_loc = local_valleys_times_locs;
                end
            end
        end
        %------------------------------------------- return_secrete_vallid
        function [p_loc v_loc] = return_secrete_vallid...
                (local_peaks_times, local_valleys_times, ...
                 local_peaks_times_locs, local_valleys_times_locs)
            % return_secrete_vallid: takes a location, time, and amplitude
            % array, and returns values that allow for quick calculation of
            % secretion values in matrix form.
            %
            % Example of secrete vallid
            %   P        .    .    .   .
            %   V     .    .    .   .
            %
            % There are four cases where that divide into even and odd
            % cases
            %
            
            % Determine which set of cases input belongs to
            even_case = rem(length(local_peaks_times_locs)+ ...
                length(local_valleys_times_locs),2)==0;
            
            if even_case == 1
                even_ok = sum(double((local_peaks_times(1)-local_valleys_times(1))< 0))== 0;
                if even_ok
                   % pass orignial locations back
                   p_loc = local_peaks_times_locs;
                   v_loc = local_valleys_times_locs;
                else
                   % Extra starting peak and extra ending valley
                   p_loc = local_peaks_times_locs(2:end);
                   v_loc = local_valleys_times_locs(1:end-1);
                end  
            else
                % odd case
                if and( ~isempty(local_peaks_times), ...
                        ~isempty(local_valleys_times) )
                    extra_valley = (local_peaks_times(1)-local_valleys_times(1))>= 0;
                    if extra_valley
                        % extra ending valley
                        p_loc = local_peaks_times_locs;
                        v_loc = local_valleys_times_locs(1:end-1);
                    else
                        % Extra starting peak
                        p_loc = local_peaks_times_locs(2:end);
                        v_loc = local_valleys_times_locs;
                    end
                else
                   % pass back original locations back
                   % assume future combputation knows how to handle
                   p_loc = local_peaks_times_locs;
                   v_loc = local_valleys_times_locs;
                end
            end
        end
    end % end static methods
end
