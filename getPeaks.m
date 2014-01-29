classdef getPeaks
% getPeaks Function determines different classes of peaks and troughs
% that with in time series data.
%
%   The goal of this peak finding function is to provide a set of
%   functions that provides better support for troughs and
%   discontinuous data.
%
%  Revisions:
%  2010-08-30 Revision for removing first and last values in a time
%    series as a feature was not working.  A crude but functional if
%    was added following the function for removing first and last.  The
%    function is elegant and should be revisited later.  The code was
%    checked for the valley but not the peaks.
%  2010-09-07 Added extended peak functions to complement extended
%    valley funtions.
%  2010_09_09 Added a display dependent variable function takes a list
%    dependent variables and displays the vectors so that they can be
%    seen
%  2010_09_10 Added functions to check if peak-valley and 
%    extended-peak-valley locations are vallid. Extended peak-valley
%    pair seem to be always vallid for ennumerated test cases.  Need to 
%    verify with real data.
%  2010_09_12 Added peak-valley check to dependent variable list
%  2010_10_31 Added times for forward summary arrays. Array needed to
%   plot time inconjunction with recursion plots
%
%  Features to add:
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Properties
    %% ----------------------------------------------------------- Constant
    properties (Constant)
        % Specification for types of points. Will be used for smart search
        % of a time series string
        
        % Data descriptor values
        PEAK = 1;
        PEAK_RISING = 2;
        PEAK_DECENDING = 3;
        VALLEY = 4;
        VALLEY_RISNG = 5;
        VALLEY_DECENDING = 6;
        FLAT_START = 7;
        FLAT_END = 8;
        MISSING_SEGMENT = 9;
        MISSING_START = 10;
        MISSING_END = 11;
        NO_LABEL = 12;
        TIME_SERIES_START = 13;
        TIME_SERIES_END = 14;
        
        DEBUG_FLAG = 0;
        
        % Feature desciptor strings
        feature_descriptor_strgs = {...
            'PEAK','PEAK_RISING','PEAK_DECENDING',...
            'VALLEY','VALLEY_RISNG','VALLEY_DECENDING',...
            'FLAT_START','FLAT_END','MISSING_SEGMENT',...
            'MISSING_START','MISSING_END','NO_LABEL',...
            'TIME_SERIES_START', 'TIME_SERIES_END'}
        
        dependent_properties = {...
            {'num_points', 'min_time_interval'},...
            {'peak_locs', 'peak_locs_exists', 'peak_times', 'peak_vals'},...
            {'valley_locs','valley_locs_exists','valley_times',...
            'valley_vals'},...
            {'extended_valley_locs','extended_valley_locs_exist',...
            'extended_valley_times','extended_valley_locs_vals',...
            'extended_valley_type'},...
            {'extended_peaks_locs','extended_peaks_locs_exist',...
            'extended_peaks_times','extended_peaks_locs_vals',...
            'extended_peaks_type'},...
            {'peak_rising_locs','peak_rising_locs_exists',...
            'peak_rising_times', 'peak_rising_vals'},...
            {'peak_descending_locs','peak_descending_locs_exists',...
            'peak_descending_times', 'peak_descending_vals'},...
            {'valley_rising_locs','valley_rising_locs_exists', ...
            'valley_rising_times','valley_rising_vals'},...
            {'valley_descending_locs', 'valley_descending_locs_exists',...
            'valley_descending_times','valley_descending_vals'},...
            {'missing_segments', 'missing_segments_locs', ...
            'missing_segments_start_times', 'missing_segments_exists',...
            'num_missing_points', 'num_missing_segments',...
            'missing_data_start_time', 'missing_data_times'},...
            {'are_peaks_and_valleys_proper',...
            'are_extended_peaks_and_valleys_proper',...
            'data_features_found_array', 'data_features_found_str'}...
            };
        
        dependent_property_descriptions = {...
            'Dependent Time Properties',...
            'Dependent Peak Properties',...
            'Dependent Valley Properties', ...
            'Dependent Extended Valley Properties',...
            'Dependent Extended Peak Properties',...
            'Dependent Peak Rising Properties',...
            'Dependent Peak Decending Properties',...
            'Dependent Valley Rising Properties',...
            'Dependent Valley_Descending Properties',...
            'Dependent Missing Data Properties',...
            'Dependent Data Feature Properties',...
            };
                
        % Algorithmn Flags
        EXCLUDE_FIRST_LAST = 1;
        
        % Figure constants
        MISSING_DATA_COLOR = [0.3, 0.3 , 0.3];
        INITAL_LINE_COLOR = [0.0, 0.0, 1.0];
        PLOT_MISSING_DATA = 1;
        CREATE_INDIVIDUAL_DISTRIBUTION_PLOTS = 1;
        
    end
    %% ----------------------------------------------- Publically Available
    properties
        % Peaks requires a time series of values.  Time is optionally
        % provided and is assumed to be in the form of [t Y]. If time is
        % not provided, t is automatically generated with an index value
        % for each time point.
        
        % Primary data
        Y
        t
        
        % figure properties
        fig_id
        plot_missing_data;
        create_individual_distribution_plots;
        
        % control the handline of minma/maxima that occur at the extreme
        % times for inclusion. Since the extreme point don't meet the
        % precise definition for an extreme point the case must be handled
        % seperately
        % Extreme point values
        exclude_first_last;
        
    end
    %% ---------------------------------------------------------- Dependent
    properties (Dependent)
        % Dependent properties are used to access information about the
        % time series relative to the point types defined in the constant
        % properties section. Since these properties are dynamically
        % defined when called they do not use memory.
        %
        
        % Summary values
        num_points
        min_time_interval
        
        %--------------------------------------------- standard definitions
        peak_locs
        peak_locs_exists
        peak_times
        peak_vals
        
        valley_locs
        valley_locs_exists
        valley_times
        valley_vals
        
        %----------------------------------- Extended Composite Definitions
        % Extended valley includes features required for a recursing on the
        
        
        % local minimum
        extended_valley_locs
        extended_valley_locs_exist
        extended_valley_times
        extended_valley_locs_vals
        extended_valley_type
        
        % local maximums
        extended_peaks_locs
        extended_peaks_locs_exist
        extended_peaks_times
        extended_peaks_locs_vals
        extended_peaks_type
        
        %--------------------------------------------- Extended Definitions
        % extended peaks
        peak_rising_locs
        peak_rising_locs_exists
        peak_rising_times
        peak_rising_vals
        
        peak_descending_locs
        peak_descending_locs_exists
        peak_descending_times
        peak_descending_vals
        
        % extended valleys
        valley_rising_locs
        valley_rising_locs_exists
        valley_rising_times
        valley_rising_vals
        
        valley_descending_locs
        valley_descending_locs_exists
        valley_descending_times
        valley_descending_vals
        
        %----------------- flat and missing data definitions
        missing_segments
        missing_segments_locs
        missing_segments_start_times
        missing_segments_exists
        num_missing_points
        num_missing_segments
        missing_data_start_time
        missing_data_times
        
        %----------------- Check if any data features are present
        data_features_found_array
        data_features_found_str
        data_label_array               % complete data label array
        are_peaks_and_valleys_proper
        are_extended_peaks_and_valleys_proper
    end
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Methods
    methods
        %------------------------------------------------------ constructor
        function obj = getPeaks(varargin)
            % getPeaks constructor is used to define the object. If only
            % only column of data is added then
            
            if nargin == 4
                % Process two columns
                obj.t = varargin{1};
                obj.Y = varargin{2};
                obj.plot_missing_data = varargin{3};
                
                % Use extreme points in analysis
                obj.exclude_first_last = varargin{4};
            elseif nargin == 3
                % Process two columns
                obj.t = varargin{1};
                obj.Y = varargin{2};
                obj.plot_missing_data = varargin{3};
                
                % Use extreme points in analysis
                obj.exclude_first_last = obj.EXCLUDE_FIRST_LAST;
            elseif nargin == 2
                % Process two columns
                obj.t = varargin{1};
                obj.Y = varargin{2};
                obj.plot_missing_data = obj.PLOT_MISSING_DATA;
                
                % Use extreme points in analysis
                obj.exclude_first_last = obj.EXCLUDE_FIRST_LAST;
            elseif nargin == 1
                % check single argument for 2 column array)
                if size(varargin{1},2) == 2
                    % two columns found
                    data = varargin{1};
                    obj.Y = data(:,2);
                    obj.t = data(:,1);
                else
                    % process single columne
                    obj.Y = varargin{1};
                    obj.t = [1:length(obj.Y)]';
                end
                obj.plot_missing_data = obj.PLOT_MISSING_DATA;
                
                
                % Use extreme points in analysis
                obj.exclude_first_last = obj.EXCLUDE_FIRST_LAST;
            elseif nargin == 0
                obj.Y = rand(50,1);
                obj.t = [1:length(obj.Y)]';
                obj.plot_missing_data = obj.PLOT_MISSING_DATA;
                
                % Use extreme points in analysis
                obj.exclude_first_last = obj.EXCLUDE_FIRST_LAST;
            else
                fprintf('--- getPeaks(Y), getPeaks(t,Y)\n');
                error('function prototype not found');
            end
            
            % Determine point types
            pt_type = ones(obj.num_points,1)*obj.NO_LABEL;
            
            
            obj.create_individual_distribution_plots = ...
                obj.CREATE_INDIVIDUAL_DISTRIBUTION_PLOTS;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dependent Properties
        %------------------------------------------------------- num points
        function num_points = get.num_points(obj)
            % Get NumSensors property
            num_points=length(obj.Y);
        end
        %------------------------------------------------------- num points
        function min_time_interval = get.min_time_interval(obj)
            % Get NumSensors property
            min_time_interval=min(diff(obj.t));
        end
        %------------------------------------------------------------------
        %--------------------------------------------------- peak locations
        function peak_locs = get.peak_locs(obj)
            
            % Echo info to console suring debug
            if obj.DEBUG_FLAG == 1
                if length(obj.Y) <= 7
                    fprintf('------------------ entering debug \n');
                    
                    debug_fid = figure();
                    plot(obj.t,obj.Y);
                    close(debug_fid)
                end
            end
            
            if obj.num_points >= 3
                % Get NumSensors property
                peaks_f = @(A)(A(2:end-1)>A(1:end-2))+(A(2:end-1)>A(3:end))==2;
                peak_locs = (find(peaks_f(obj.Y))+1);
                peak_locs = obj.remove_first_last....
                    (obj.exclude_first_last, obj.num_points, peak_locs);
                
                % check extreme values
                if obj.exclude_first_last == 0
                    if obj.Y(1)>obj.Y(2)
                        % Add first point
                        peak_locs = [1; peak_locs ];
                    end
                    if obj.Y(end)>obj.Y(end-1)
                        % Add last point
                        peak_locs = [peak_locs; obj.num_points];
                    end
                end
            else
                peak_locs = [];
            end
          
        end
        %------------------------------------------------- peak_locs_exists
        function peak_locs_exists = get.peak_locs_exists(obj)
            % Define functions for identifying if local peaks exist
            if ~isempty(obj.peak_locs)
                peak_locs_exists = 1;
            else
                peak_locs_exists = 0;
            end
        end
        %------------------------------------------------------- peak times
        function peak_times = get.peak_times(obj)
            % Get NumSensors property
            peak_times = obj.t(obj.peak_locs);
        end
        %------------------------------------------------------ peak values
        function peak_vals = get.peak_vals(obj)
            % Get NumSensors property
            peak_vals=obj.Y(obj.peak_locs);
        end
        %------------------------------------------------------------------
        %------------------------------------------------- valley locations
        function valley_locs = get.valley_locs(obj)
            if obj.num_points >= 3
                % Get valley locations
                valley_f = @(A)(A(2:end-1)<A(1:end-2))+(A(2:end-1)<A(3:end))==2;
                valley_locs=(find(valley_f(obj.Y))+1);
                valley_locs = obj.remove_first_last... % doesn't seem to work
                    (obj.exclude_first_last, obj.num_points, valley_locs);
                
                % check extreme values
                if obj.exclude_first_last == 0
                    if obj.Y(2)>obj.Y(1)
                        % Add first point
                        valley_locs = [1; valley_locs ];
                    end
                    if obj.Y(end-1)>obj.Y(end)
                        % Add last point
                        valley_locs = [valley_locs; length(obj.Y)];
                    end
                end
            else
                % Not eough points to points for a valley
                valley_locs = [];
            end
            
        end
        %---------------------------------------------- valley_locs_exists
        function valley_locs_exists = get.valley_locs_exists(obj)
            % Define functions for identifying if local peaks exist
            if ~isempty(obj.valley_locs)
                valley_locs_exists = 1;
            else
                valley_locs_exists = 0;
            end
        end
        %----------------------------------------------------- valley times
        function valley_times = get.valley_times(obj)
            % Get NumSensors property
            valley_times=obj.t(obj.valley_locs);
        end
        
        %---------------------------------------------------- valley values
        function valley_vals = get.valley_vals(obj)
            % Get NumSensors property
            valley_vals=obj.Y(obj.valley_locs);
        end
        %------------------------------------------------------------------
        %--------------------------------------------- extended_valley_locs
        function extended_valley_locs = get.extended_valley_locs(obj)
            % extended_valley_locs
            %    extended_valley_locs = sort([...
            %                 obj.valley_locs; ...
            %                 obj.valley_rising_locs; ...
            %                 obj.valley_descending_locs]);
            
            extended_valley_locs = sort([...
                obj.valley_locs; ...
                % obj.valley_rising_locs; ...
                obj.valley_descending_locs]);
        end
        %--------------------------------------- extended_valley_locs_exist
        function extended_valley_locs_exist = get.extended_valley_locs_exist(obj)
            % Get NumSensors property
            extended_valley_locs_exist = ~isempty(obj.extended_valley_locs);
        end
        %--------------------------------------------- extended_valley_locs
        function extended_valley_times = get.extended_valley_times(obj)
            % Get times of extende valley
            extended_valley_times = obj.t(obj.extended_valley_locs);
        end
        %---------------------------------------- extended_valley_locs_vals
        function extended_valley_locs_vals = ...
                get.extended_valley_locs_vals(obj)
            % Get values of extended valley times
            extended_valley_locs_vals = obj.Y(obj.extended_valley_locs);
        end
        %---------------------------------------- extended_valley_locs_vals
        function extended_valley_type = ...
                get.extended_valley_type(obj)
            % extended valley includes all the features that are required
            % to process local minimum in real data situations.
            
            %
            
            % Determine sort order for type array
            [temp IX] = sort([...
                obj.valley_locs; ...
                obj.valley_rising_locs; ...
                obj.valley_descending_locs]);
            
            % Create array type array
%             extended_valley_type = [ ...
%                 ones(length(obj.valley_locs),1)*obj.VALLEY;...
%                 ones(length(obj.valley_rising_locs),1)*obj.VALLEY_RISNG;...
%                 ones(length(obj.valley_descending_locs),1)*obj.VALLEY_DECENDING ];
            extended_valley_type = [ ...
                ones(length(obj.valley_locs),1)*obj.VALLEY;...
                ones(length(obj.valley_rising_locs),1)*obj.VALLEY_RISNG;...
                ones(length(obj.valley_descending_locs),1)*obj.VALLEY_DECENDING ];
            
            % reorder according to temporal occurance
            extended_valley_type = extended_valley_type(IX);
        end
        %--------------------------------------------------- extended_peaks
        %---------------------------------------------- extended_peaks_locs
        function extended_peaks_locs = get.extended_peaks_locs(obj)
            % Get NumSensors property
%             extended_peaks_locs = sort([...
%                 obj.peak_locs; ...
%                 obj.peak_rising_locs; ...
%                 obj.peak_descending_locs]);
            extended_peaks_locs = sort([...
                obj.peak_locs; ...
                obj.peak_descending_locs]);
        end
        %---------------------------------------- extended_peaks_locs_exist
        function extended_peaks_locs_exist = get.extended_peaks_locs_exist(obj)
            % Get NumSensors property
            extended_peaks_locs_exist = ~isempty(obj.extended_peaks_locs);
        end
        %--------------------------------------------- extended_valley_locs
        function extended_peaks_times = get.extended_peaks_times(obj)
            % Get times of extende valley
            extended_peaks_times = obj.t(obj.extended_peaks_locs);
        end
        %---------------------------------------- extended_valley_locs_vals
        function extended_peaks_locs_vals = ...
                get.extended_peaks_locs_vals(obj)
            % Get values of extended valley times
            extended_peaks_locs_vals = obj.Y(obj.extended_peaks_locs);
        end
        %---------------------------------------- extended_valley_locs_vals
        function extended_peaks_type = ...
                get.extended_peaks_type(obj)
            % extended valley includes all the features that are required
            % to process local minimum in real data situations.
            
            %
            
            % Determine sort order for type array
            [temp IX] = sort([...
                obj.peak_locs; ...
                obj.peak_rising_locs; ...
                obj.peak_descending_locs]);
            
            % Create array type array
            extended_peaks_type = [ ...
                ones(length(obj.peak_locs),1)*obj.PEAK;...
                ones(length(obj.peak_rising_locs),1)*obj.PEAK_RISING;...
                ones(length(obj.peak_descending_locs),1)*obj.PEAK_DECENDING ];
            
            % reorder according to temporal occurance
            extended_peaks_type = extended_peaks_type(IX);
        end
        %------------------------------------------------------------------
        %------------------------------------------------- peak_rising_locs
        function peak_rising_locs = get.peak_rising_locs(obj)
            % Get values of extended valley times
            % Define functions for identifying peaks and previous
            plateau_loc_f = ...
                @(A)(A(2:end-1)>A(1:end-2))+(A(2:end-1)==A(3:end))==2;
            
            if obj.num_points >= 3
                % Define rising
                peak_rising_locs = (find(plateau_loc_f(obj.Y))+1);
                
                peak_rising_locs = obj.remove_first_last...
                    (obj.exclude_first_last, obj.num_points, peak_rising_locs);
            else
                peak_rising_locs = [];
            end
        end
        %----------------------------------------------- peak rising exists
        function peak_rising_locs_exists = get.peak_rising_locs_exists(obj)
            % Define functions for identifying peaks and previous
            peak_rising_locs_exists =  ~isempty(obj.peak_rising_locs);
        end
        %------------------------------------------------ peak_rising_times
        function peak_rising_times = get.peak_rising_times(obj)
            % Define functions for identifying peaks and previous
            peak_rising_times = obj.t(obj.peak_rising_locs);
        end
        %------------------------------------------------- peak_rising_vals
        function peak_rising_vals = get.peak_rising_vals(obj)
            % Define functions for identifying peaks and previous
            peak_rising_vals = obj.Y(obj.peak_rising_locs);
        end
        %------------------------------------------------------------------
        %-------------------------------------------------- peak descending
        function peak_descending_locs = get.peak_descending_locs(obj)
            % Define functions for identifying peaks and previous
            plateau_loc_f = ...
                @(A)(A(2:end-1)==A(1:end-2))+(A(2:end-1)>A(3:end))==2;
            
            if obj.num_points >= 3
                % Define rising
                peak_descending_locs = (find(plateau_loc_f(obj.Y))+1);
                
                peak_descending_locs = obj.remove_first_last...
                    (obj.exclude_first_last, obj.num_points, peak_descending_locs);
            else
                peak_descending_locs = [];
            end
        end
        %----------------------------------------------- peak rising exists
        function peak_descending_locs_exists = get.peak_descending_locs_exists(obj)
            % Define functions for identifying peaks and previous
            if ~isempty(obj.peak_descending_locs)
                peak_descending_locs_exists = 1;
            else
                peak_descending_locs_exists = 0;
            end
        end
        %----------------------------------------------- peak rising exists
        function peak_descending_times = get.peak_descending_times(obj)
            % Define functions for identifying peaks and previous
            peak_descending_times = obj.t(obj.peak_descending_locs);
        end
        %----------------------------------------------- peak rising exists
        function peak_descending_vals = get.peak_descending_vals(obj)
            % Define functions for identifying peaks and previous
            peak_descending_vals = obj.Y(obj.peak_descending_locs);
        end
        
        %------------------------------------------------------------------
        %---------------------------------------------------- valley rising
        function valley_rising_locs = get.valley_rising_locs(obj)
            % Define functions for identifying peaks and previous
            plateau_loc_f = ...
                @(A)(A(2:end-1)==A(1:end-2))+(A(2:end-1)<A(3:end))==2;
            
            if obj.num_points >=3
                % Define rising
                valley_rising_locs = (find(plateau_loc_f(obj.Y))+1);
                
                valley_rising_locs = obj.remove_first_last...
                    (obj.exclude_first_last, obj.num_points, valley_rising_locs);
            else
                valley_rising_locs = [];
            end
        end
        %--------------------------------------------- valley rising exists
        function valley_rising_locs_exists = ...
                get.valley_rising_locs_exists(obj)
            % Define functions for identifying peaks and previous
            if ~isempty(obj.valley_rising_locs)
                valley_rising_locs_exists = 1;
            else
                valley_rising_locs_exists = 0;
            end
        end
        %--------------------------------------------- valley rising exists
        function valley_rising_times = get.valley_rising_times(obj)
            % Define functions for identifying peaks and previous
            valley_rising_times = obj.t(obj.valley_rising_locs);
        end
        %--------------------------------------------- valley rising exists
        function valley_rising_vals = get.valley_rising_vals(obj)
            % Define functions for identifying peaks and previous
            valley_rising_vals = obj.Y(obj.valley_rising_locs);
        end
        %------------------------------------------------------------------
        %------------------------------------------------ valley descending
        function valley_descending_locs = get.valley_descending_locs(obj)
            % Define functions for identifying peaks and previous
            plateau_loc_f = ...
                @(A)(A(2:end-1)< A(1:end-2))+(A(2:end-1)==A(3:end))==2;
            
            if obj.num_points >=3
                % Define rising
                valley_descending_locs = (find(plateau_loc_f(obj.Y))+1);
                
                valley_descending_locs = obj.remove_first_last...
                    (obj.exclude_first_last, obj.num_points, valley_descending_locs);
            else
                valley_descending_locs = 1;
            end
        end
        %----------------------------------------  valley descending exists
        function valley_descending_locs_exists = ...
                get.valley_descending_locs_exists(obj)
            % Define functions for identifying peaks and previous
            if ~isempty(obj.valley_descending_locs)
                valley_descending_locs_exists = 1;
            else
                valley_descending_locs_exists = 0;
            end
        end
        %----------------------------------------  valley descending exists
        function valley_descending_times = get.valley_descending_times(obj)
            % Define functions for identifying peaks and previous
            valley_descending_times = obj.t(obj.valley_descending_locs);
        end
        %----------------------------------------  valley descending exists
        function valley_descending_vals = get.valley_descending_vals(obj)
            % Define functions for identifying peaks and previous
            valley_descending_vals = obj.Y(obj.valley_descending_locs);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Missing and Flat
        %------------------------------------------------  missing_segments
        function missing_segments = get.missing_segments(obj)
            % Define functions for identifying peaks and previous
            diff_index = obj.missing_segments_locs;
            missing_segments = [obj.t(diff_index), (obj.t(diff_index+1))];
        end
        %------------------------------------------------  missing_segments
        function missing_segments_start_times = get.missing_segments_start_times(obj)
            % Define functions for identifying peaks and previous
            diff_index = obj.missing_segments_locs;
            missing_segments_start_times = obj.t(diff_index);
        end
        %-------------------------------------------- missing_segments_locs
        function missing_segments_locs = get.missing_segments_locs(obj)
            % Define functions for identifying peaks and previous
            if obj.num_points > 1;
                diff_array = round(diff(obj.t)/obj.min_time_interval);
                missing_segments_locs = find(diff_array ~= 1);
            else
                missing_segments_locs = [];
            end
        end
        %-----------------------------------------  missing segments exists
        function missing_segments_exists = ...
                get.missing_segments_exists(obj)
            % Define functions for identifying peaks and previous
            if ~isempty(obj.missing_segments)
                missing_segments_exists = 1;
            else
                missing_segments_exists = 0;
            end
        end
        %--------------------------------------------- num_missing_segments
        function num_missing_segments = ...
                get.num_missing_segments(obj)
            % Define functions for identifying peaks and previous
            num_missing_segments = size(obj.missing_segments,1);
        end
        %----------------------------------------------  num_missing_points
        function num_missing_points = ...
                get.num_missing_points(obj)
            % Define functions for identifying peaks and previous
            if ~isempty(obj.missing_segments)
                point_id = obj.missing_segments/obj.min_time_interval;
                num_missing_points = sum((point_id(:,2) - point_id(:,1))-1);
            else
                num_missing_points = 0;
            end
        end
        %------------------------------------------ missing_data_start_time
        function missing_data_start_time = ...
                get.missing_data_start_time(obj)
            % Define functions for identifying peaks and previous
            if ~isempty(obj.missing_segments)
                missing_data_start_time = ...
                    obj.missing_segments_start_times(1,1)+ ...
                    obj.min_time_interval;
            else
                missing_data_start_time = -1;
            end
        end
        %---------------------------------------------- missing_data_times
        function missing_data_times = ...
                get.missing_data_times(obj)
            % Return an array of missing data times
            missing_data_times = [];
            if ~isempty(obj.missing_segments)
                % create local copy of variables
                min_time_interval = obj.min_time_interval;
                num_missing_segments = obj.num_missing_segments;
                
                % determine inclusive missing data boundary
                missing_segments = obj.missing_segments;
                missing_segments(:,1) = ...
                    missing_segments(:,1)+ min_time_interval;
                missing_segments(:,2) = ...
                    missing_segments(:,2)- min_time_interval;
                
                % reset data size and add
                missing_data_times = [];
                for m = 1:num_missing_segments
                    new_segment = [missing_segments(m,1):...
                        min_time_interval:missing_segments(m,2)]';
                    missing_data_times = [missing_data_times; new_segment];
                end
            end
        end
        %------------------------------------- are_peaks_and_valleys_proper
        function are_peaks_and_valleys_proper = ...
                get.are_peaks_and_valleys_proper(obj)
            % function checks that is exactly one function between every
            % peak between each valley and vice versa.
            
            % Set up variables
            are_peaks_and_valleys_proper = 0;
            valley_times = obj.valley_times;
            valley_locs = obj.valley_locs;
            peak_times = obj.peak_times;
            peak_locs = obj.peak_locs;
            
            % Check peak and valley times
            peak_check_index = ...
                obj.check_peak_valley_t_relationship...
                    (peak_times, valley_times);
            valley_check_index = ...
                obj.check_peak_valley_t_relationship...
                    (valley_times, peak_times);
            
            % Define peaks and valley are propper if they are separately
            % vallid
            if and( peak_check_index == 1, valley_check_index == 1)
                    are_peaks_and_valleys_proper = 1;
            end
            
            % Check for rising and decreasing section
            if are_peaks_and_valleys_proper == 1
                if and(length(valley_times)== 1, length(peak_times)== 1)
                    % single peak and single valley
                    if and(...
                            or(obj.num_points == peak_locs(1), 1 == peak_locs(1)),...
                            or(obj.num_points == valley_locs(1), 1 == valley_locs(1)))
                        % peak and valley are at the ends
                        if valley_locs(1) ~= peak_locs(1)
                            are_peaks_and_valleys_proper = 0;
                        end
                    end
                end
            end      
        end     
        %---------------------------- are_extended_peaks_and_valleys_proper
        function are_extended_peaks_and_valleys_proper = ...
                get.are_extended_peaks_and_valleys_proper(obj)
            % function checks that is exactly one function between every
            % peak between each valley and vice versa.
            
            % Set up variables
            are_extended_peaks_and_valleys_proper = 0;
            valley_times = obj.extended_valley_times;
            valley_locs = obj.extended_valley_locs;
            peak_times = obj.extended_peaks_times;
            peak_locs = obj.extended_peaks_locs;
            
            % Check pea
            peak_check_index = ...
                obj.check_peak_valley_t_relationship...
                    (peak_times, valley_times);
            valley_check_index = ...
                obj.check_peak_valley_t_relationship...
                    (valley_times, peak_times);
            
            % Define peaks and valley are propper if they are separately
            % vallid
            if and( peak_check_index == 1, valley_check_index == 1)
                    are_extended_peaks_and_valleys_proper = 1;
            end 
            
            % Check for rising and decreasing section
            if are_extended_peaks_and_valleys_proper == 1
                if and(length(valley_times)== 1, length(peak_times)== 1)
                    % single peak and single valley
                    if and(...
                            or(obj.num_points == peak_locs(1), 1 == peak_locs(1)),...
                            or(obj.num_points == valley_locs(1), 1 == valley_locs(1)))
                        % peak and valley are at the ends
                        if valley_locs(1) ~= peak_locs(1)
                            are_extended_peaks_and_valleys_proper = 0;
                        end
                    end
                end
            end 
        end        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% data features
        %---------------------------------------- data_features_found_array
        function data_features_found_array = get.data_features_found_array(obj)
            % Define functions for identifying peaks and previous
            
            % Create an array of all possible features
            data_features_found = [ ...
                obj.peak_locs_exists, obj.PEAK ; ...
                obj.valley_locs_exists, obj.VALLEY ; ...
                obj.peak_rising_locs_exists, obj.PEAK_RISING; ...
                obj.peak_descending_locs_exists, obj.PEAK_DECENDING; ...
                obj.valley_rising_locs_exists, obj.VALLEY_RISNG; ...
                obj.valley_descending_locs_exists, obj.VALLEY_DECENDING; ...
                obj.valley_descending_locs_exists, obj.VALLEY_DECENDING; ...
                obj.missing_segments_exists, obj.MISSING_SEGMENT];
            
            % Return features that are found
            index = find(data_features_found(:,1) == 1);
            data_features_found_array = data_features_found(index,2);
        end
        %---------------------------------------------- data features found
        function data_features_found_str = get.data_features_found_str(obj)
            % Define functions for identifying peaks and previous
            data_features_found_str = ...
                obj.feature_descriptor_strgs(obj.data_features_found_array);
        end
        %------------------------------------- are_peaks_and_valleys_proper
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualizations
        %-------------------------------------------------------- Summarize
        
        function peak_struct = summarize(obj)
            % Create summary structure with all values calculated
            %
            % slowly converting passing of values to more efficient
            % representation for updates and additions.
            %

            
            % Use global DEBUG flag to echo contents to console
            if obj.DEBUG_FLAG == 1
                if length(obj.Y) <= 7
                    fprintf('------------------ entering ''peak:summarize'' debug \n');
                end
            end
            
            % Create new substructure by passing values from object
            variable_cell_array = {  'Y'; 't'; 'fig_id'; ...
                 'num_points'; ...
                 'min_time_interval'; ...
                 % peak summary
                 'peak_locs'; ...
                 'peak_locs_exists'; ...
                 'peak_times'; ...
                 'peak_vals'; ...
                 % valley summary
                 'valley_locs'; ...
                 'valley_locs_exists'; ...
                 'valley_times'; ...
                 'valley_vals'; ...
                 % extended valley summary
                 'extended_valley_locs'; ...
                 'extended_valley_locs_exist'; ...
                 'extended_valley_times'; ...
                 'extended_valley_locs_vals'; ...
                 'extended_valley_type'; ...
                 % extended peaks summary
                 'extended_peaks_locs';...
                 'extended_peaks_locs_exist';...
                 'extended_peaks_times';...
                 'extended_peaks_locs_vals';...
                 'extended_peaks_type';...
                 'extended_peaks_type';...
                 % extended definitions
                 'peak_rising_locs';...
                 'peak_rising_locs_exists';...
                 'peak_rising_times';...
                 'peak_rising_vals';...
                 'peak_descending_locs';...
                 'peak_descending_locs_exists';...
                 'peak_descending_times';...
                 'peak_descending_vals';...
                 % extended valleys
                 'valley_rising_locs';...
                 'valley_rising_locs_exists';...
                 'valley_rising_times';...
                 'valley_rising_vals';...
                 'valley_descending_locs';...
                 'valley_descending_locs_exists';...
                 'valley_descending_times';...
                 'valley_descending_vals';...
                 % flat and missing data definitions
                 'missing_segments';...
                 'missing_segments_locs';...
                 'missing_segments_start_times';...
                 'missing_segments_exists';...
                 'num_missing_points';...
                 'num_missing_segments';...
                 'missing_data_start_time';...
                 'missing_data_times';...
                 % Data features present
                 'data_features_found_array';...
                 'data_features_found_str';...
                 % Check if proper
                 'are_peaks_and_valleys_proper';...
                 'are_extended_peaks_and_valleys_proper'};
            
            % Create summary peak structure
            peak_struct = obj.create_sub_structure...
                                         (obj, variable_cell_array);
        end
        %-------------------------------------------------------- Summarize
        function peak_nadir_sum_struct_ret = peak_nadir_summary(obj)
            % peak_nadir_summary
            % Sumarized numeric characteristics of selected points.
            % Information will be used to compare strings and to create
            % individual paramter distributions. Results from individual
            % parameter distribution can be collected to create a group
            % distribution.
            %
            % Input: Peak object is used
            %
            % Output: Is dependent on the calling function. A stucture that
            % holds the derived properties is passed back if the calling
            % function has one return argument. Otherwise, the results are
            % listed to the screen assuming appropriate flags are set.
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  Function is currently under use
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  Need to use new dependent variable for vallid peak-nadir
            %  pair
            %
            %
            
            
            % Function Constants
            DEBUG_FLAG = 1;
            
            % Get summary data structure
            peak_struct = summarize(obj);
            
            % Define return structure
            peak_nadir_sum_struct = struct('num_peaks', 0,...
                'percent_peaks', 0, 'num_valley', 0, 'percent_valley', 0,...
                'nadir_index',[], 'nadir_peak_index_pair', [], ...
                'amplitudes',[],'rise_times', [], ...
                'inter_pulse_interval', [], ...
                'num_extended_valley', 0, ...
                'num_peak_rising', 0, ...
                'num_peak_decending', 0, ...
                'num_valley_rising', 0, ...
                'num_valley_descending', 0 );
            
            % Peak Summary
            num_peaks = length(peak_struct.peak_times);
            percent_peaks = num_peaks/peak_struct.num_points;
            
            % Valley Summary
            num_valley = length(peak_struct.valley_vals);
            percent_valley = num_valley/peak_struct.num_points;
            
            % Extended Definitions (note: extended peak not included)
            num_extended_valley = length(peak_struct.extended_valley_locs_vals);
            num_peak_rising = length(peak_struct.peak_rising_vals);
            num_peak_decending = length(peak_struct.peak_descending_vals);
            num_valley_rising = length(peak_struct.valley_rising_vals);
            num_valley_descending = length(peak_struct.valley_descending_vals);
            
            % Check if nadir exists prior to amplitude
            predecessors_exists_F = ...
                @(peak_time)~isempty(find(peak_struct.valley_times < peak_time));
            proper_predecessor_peak_index = ...
                find(arrayfun(predecessors_exists_F, peak_struct.peak_times));
            
            % Proceed if proper nadir-peak combination exists
            if ~isempty(proper_predecessor_peak_index)
                % Define and ger precessor index
                get_predecessor_index_fun = ...
                    @(peak_index)max(find(peak_struct.valley_times < ...
                    peak_struct.peak_times(peak_index)));
                nadir_index = ...
                    arrayfun(get_predecessor_index_fun, proper_predecessor_peak_index);
                
                % Define nadier peak pair
                nadir_peak_index_pair = [nadir_index, proper_predecessor_peak_index];
                
                % Create individualize distributions
                amplitudes = [peak_struct.peak_vals(proper_predecessor_peak_index), ...
                    peak_struct.valley_vals(nadir_index) ];
                rise_times = ...
                    [peak_struct.peak_times(proper_predecessor_peak_index), ...
                    peak_struct.valley_times(nadir_index)];
                inter_pulse_interval = diff(peak_struct.valley_times(nadir_index));
                
                % Create nadir peak summary structure
                peak_nadir_sum_struct.num_peaks = num_peaks;
                peak_nadir_sum_struct.percent_peaks = percent_peaks;
                peak_nadir_sum_struct.num_valley = num_valley;
                peak_nadir_sum_struct.percent_valley = percent_valley;
                peak_nadir_sum_struct.nadir_index = nadir_index;
                peak_nadir_sum_struct.nadir_peak_index_pair = nadir_peak_index_pair;
                peak_nadir_sum_struct.amplitudes = amplitudes;
                peak_nadir_sum_struct.inter_pulse_interval = inter_pulse_interval;
                peak_nadir_sum_struct.rise_times = rise_times;
                
                % Plot individualize distributions
                if nargout == 1
                    plot_individualized_distribution(peak_nadir_sum_struct);
                end
                obj.plot_individualized_distribution(peak_nadir_sum_struct);
            end
            
            % Prepare return value depending on the nargout
            if nargout == 1
                % Return of nargout
                peak_nadir_sum_struct_ret = peak_nadir_sum_struct;
            end   
        end
        %------------------------------------------------------------- Disp
        function varargout = Disp(obj)
            % Writes a summary of the getPeak obj of single value functions
            % that includes 
            
            % Function Constants
            var_start_offset = 5;
            
            % Summarize peak structure - Instantiates all the varaibles for 
            % use outside of object and for display functions.
            peak_struct = summarize(obj);
            
            % Define varaibles and grouping to display
            disp_var = ...
                {{'num_points'; 'min_time_interval';...
                  'num_missing_points'; 'num_missing_segments';...
                  'missing_data_start_time'};...
                 {'peak_locs_exists'; 'valley_locs_exists';...
                  'peak_rising_locs_exists';'peak_descending_locs_exists';...
                  'valley_rising_locs_exists';'missing_segments_exists';...
                  'are_peaks_and_valleys_proper';...
                  'are_extended_peaks_and_valleys_proper'}...
                 };
            var_descr = { 'Numerical Peak Summary'; ...
                 'Boolean Feature Summary'};         
            str_max_length = max(max(cellfun(@length, disp_var{1})),...
                   max(cellfun(@length, disp_var{2}))) + var_start_offset;
                              
            % Write variable output by groupings
            for g = 1: length(var_descr)
                % For each group        
                fprintf('%s:\n',var_descr{g})
                for e = 1:length(disp_var{g})
                    % variable start spaced
                    var_length = length(disp_var{g}{e});
                    space_cmd = sprintf('fprintf(''%%%ds'','' '')',...
                        str_max_length-var_length);
                    eval(space_cmd);
                    
                    % Write variable and variable value
                    fprintf('%s:\t',disp_var{g}{e});
                    data_cmd = sprintf('obj.%s',disp_var{g}{e});
                    obj.display_vector(eval(data_cmd));
                end
                fprintf('\n');
            end
            
            % Dummay output so function can be used in 
            if nargout == 1
                varargout = {1};
            else
                varargout = {};
            end
        end
        
        %----------------------------------------------------- Disp_Summary
        function varargout = Disp_Summary(obj)
            % Computes summary structure and displays to console
            
            % Analyze time series
            peak_struct = summarize(obj);
            
            fprintf('--- Peak Structure Summary\n');
            
            fprintf('     Y:');obj.display_vector(obj.Y);
            fprintf('     t:');obj.display_vector(obj.t);
            fprintf('\n');
            for g = 1: length(obj.dependent_property_descriptions)
                % For each group
                fprintf('    %s:\n',obj.dependent_property_descriptions{g})
                for e = 1:length(obj.dependent_properties{g})
                    % For each entry
                    fprintf('    %s:',obj.dependent_properties{g}{e});
                    data_cmd = sprintf('obj.%s',obj.dependent_properties{g}{e});
                    obj.display_vector(eval(data_cmd));
                end
                fprintf('\n');
            end
            
            if nargout == 1
                varargout = {1};
            else
                varargout = {};
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualizations
        %------------------------------------------------------- plot peaks
        function fid = plot_peaks(varargin)
            % Function used to create an annotated plot with points types
            % identified with color. Plot is used to verify status of
            %
            
            % Function Constants
            DEBUG_FLAG = 0;
            
            % Check parameters
            if nargin == 1
                obj = varargin{1};
                fid = -1;
                line_color = obj.INITAL_LINE_COLOR;
            elseif nargin == 2
                obj = varargin{1};
                fid = varargin{2};
                line_color = obj.INITAL_LINE_COLOR;
            elseif nargin == 3
                obj = varargin{1};
                fid = varargin{2};
                line_color = varargin{3};
            elseif nargin == 4
                obj = varargin{1};
                fid = varargin{2};
                line_color = varargin{3};
                fid = varargin{4};
            else
                error('-- number of arguments not handled');
            end
            
            % Get local peak and valley values. Function assumes that time
            % series will contain at least one peak and one valley
            peak_times = obj.peak_times;
            valley_times = obj.valley_times;
            peak_vals = obj.peak_vals;
            valley_vals = obj.valley_vals;
            
            % Plot data in new figure
            if fid == -1
                fid = figure('InvertHardcopy','off','Color',[1 1 1]);
            else
                figure(fid)
                hold on;
            end
            plot(obj.t,obj.Y,'LineWidth',2, ...
                'MarkerSize', 14, 'Color', line_color );
            hold on;
            
            % Plot peak times
            if obj.peak_locs_exists ==1
                plot(peak_times, peak_vals,...
                    '.r','LineWidth',2, 'MarkerSize', 14 );
                hold on;
            end
            
            % Plot Valley times if they exists
            if obj.valley_locs_exists ==1
                plot(valley_times, valley_vals,...
                    '.g','LineWidth',2, 'MarkerSize', 14 );
                hold on;
            end
            
            % Plot peaks rising in they exist
            if obj.peak_rising_locs_exists ==1
                plot(obj.peak_rising_times,obj.peak_rising_vals,...
                    '.m','LineWidth',2, 'MarkerSize', 14 );
                hold on;
            end
            
            % Plot peaks descending if they exist
            if obj.peak_descending_locs_exists ==1
                plot(obj.peak_descending_times,obj.peak_descending_vals,...
                    '.c','LineWidth',2, 'MarkerSize', 14 );
                hold on;
            end
            
            % Plot valley rising if they exist
            if obj.valley_rising_locs_exists ==1
                plot(obj.valley_rising_times,obj.valley_rising_vals,...
                    '.b','LineWidth',2, 'MarkerSize', 14 );
                hold on;
            end
            
            % Plot valley descedning if they exist
            if obj.peak_descending_locs_exists ==1
                plot(obj.valley_descending_times,obj.valley_descending_vals,...
                    '.k','LineWidth',2, 'MarkerSize', 14 );
                hold on;
            end
            
            % Plot missing segments if they exist
            if and (obj.missing_segments_exists == 1,...
                    obj.plot_missing_data == 1)
                
                % Identify each missing segment
                v = axis();
                for m = 1:obj.num_missing_segments
                    % Determine line locations
                    s = obj.missing_segments(m,1);
                    e = obj.missing_segments(m,2);
                    line([s;s],v(3:4)',...
                        'color',obj.MISSING_DATA_COLOR,'LineStyle','-');
                    line([e;e],v(3:4)',...
                        'color',obj.MISSING_DATA_COLOR,'LineStyle',':');
                    if DEBUG_FLAG == 1
                        fprintf('--- (%d) plotting missing segment {[%.1f, %.1f]} \n',...
                            m, s, e);
                    end
                end
                
                if DEBUG_FLAG == 1
                    obj.missing_segments_start_times
                end
            end
            
            % Make plot display/print ready
            % title(title_str, 'Interpreter', 'none','FontWeight','bold',...
            %    'FontSize',14)
            
            % Set axis properties
            set(gca,'LineWidth',2);
            set(gca,'FontWeight','bold');
            set(gca,'FontSize',14);
        end
        %--------------------------------- plot_individualized_distribution
        function fids = plot_individualized_distribution(varargin)
            %
            %
            
            % Function Constants
            DEBUG_FLAG = 0;
            fids = [100 101 104 105];
            
            % Check parameters
            if nargin == 2
                obj = varargin{1};
                peak_nadir_sum_struct = varargin{2};
            else
                error('-- number of arguments not handled');
            end
            
            % Create Amplitude Plot
            figure(fids(1))
            hist(peak_nadir_sum_struct.amplitudes(:,1)-peak_nadir_sum_struct.amplitudes(:,2))
            title('Amplitude','FontSize',14)
            xlabel('Concentration (ug/dL)','FontSize',14);
            ylabel('Count','FontSize',14);
            
            % Create rise time plot
            %       peak_nadir_sum_struct
            rise_times = peak_nadir_sum_struct.rise_times;
            bins = double(sort(unique(rise_times(:,1)-rise_times(:,2))));
            
            figure(fids(2))
            hist( double(peak_nadir_sum_struct.rise_times(:,1)-peak_nadir_sum_struct.rise_times(:,2)),bins)
            title('Rise Times','FontSize',14);
            xlabel('Time (min)','FontSize',14);
            ylabel('Count','FontSize',14)
            
            % Create Inter-Pulse Interval Plot
            figure(fids(3))
            hist(double(peak_nadir_sum_struct.inter_pulse_interval))
            title('Inter-Pulse Interval','FontSize',14)
            xlabel('Time (min)','FontSize',14)
            ylabel('Count','FontSize',14);
            
            %             % Create x-y of rise times and amplitudes
            %             rise = rise_times(:,1)-rise_times(:,2)
            %             amps = peak_nadir_sum_struct.amplitudes(:,1)
            %                 -peak_nadir_sum_struct.amplitudes(:,2)
            %             figure(fids(4))
            %             plot(rise,amps,'.')
            %
            %             title('',14)
            %             xlabel('Rise Times','FontSize',14)
            %             ylabel('Amplitude (ug/dL)','FontSize',14);
        end
    end
    %% -------------------------------- Publically Available Static Methods
    methods (Static)
        %% ----------------------------- 
        function ret_struct = create_sub_structure(obj, vars)
            % create_sub_structure: Program takes a calling object and a cell
            % array of variables. The varaibles in the cell array are used to
            % create a new substructure.
            %
            
            % Process variable string if it exists
            if ~isempty(vars)
                ret_struct = struct(vars{1}, ...
                                    eval(sprintf('obj.%s',vars{1})));
                for v = 2:length(vars)
                    move_cmd = sprintf('ret_struct.%s = obj.%s;',...
                        vars{v},vars{v});
                    eval(move_cmd);
                end
            end
        end
        %% ----------------------------- check_peak_valley_t_relationship
        function t1_check_index = check_peak_valley_t_relationship(t1,t2)
            % check_peak_valley_t_relationship. function checks that there
            % between every two points in t1 there is a point in t2. The
            % function is used to check that there is a vallid peak-valley
            % relationship in t1 and t2. The function validates t1.  To
            % validate t2 the function can be called a second time with the
            % parameters reversed.
            %
            % input:
            %     t1: vector of times
            %     t2: vector of time
            %
            % output:
            %    t1_check_index: true boolean if vallid
            %
            
            % Define function
            t1_check_index = 0;
            num_t1 = length(t1);
            
            % Check based on length of vector
            if num_t1 >= 2
                % Check for a vallid valley between every peak
                check_t2_F = @(p1,p2) sum(and(t2 > p1, t2 < p2));
                get_t1_points_f = @(p)check_t2_F(t1(p-1),t1(p));
                t1_check_index = prod(arrayfun(get_t1_points_f,[2:1:num_t1]));
            elseif num_t1 == 1
                % check that there is at least one valley not equal
                t1_check_index = sum(t1(1) ~= t2)>=1;
            else
                % Assume zero peaks not vallid for analysis
                t1_check_index = 0;
            end
        end
        %% ---------------------------------------------- remove_first_last
        function index_array = remove_first_last(flag, array_length, index_subset)
            % remove_first_last Function removes first and last array index
            % flag is a boolean, array_length is an interger and maximum
            % array length, index suset is an array of interger values
            
            % Function Constant
            DEBUG = 1;
            
            % Remove first and last index if flag is set
            index_array = index_subset;
            if flag == 1
                % remove first entry if present
                if ismember(1,index_subset)
                    index_subset = index_subset(2:end);
                end
                
                % remove second entry if present
                if ismember(array_length,index_subset)
                    index_subset = setdiff(array_length,index_subset);
                end
            end
        end
        %----------------------------------------------- display_vector
        function display_vector(data_vec)
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
            
            if isinteger(data_vec) == 1
                if prod(size(data_vec))==1
                   fprintf('%2d\n',data_vec) 
                else
                   display_vector_int(data_vec);
                end
            elseif islogical(data_vec) == 1
                if prod(size(data_vec))==1
                   fprintf('%1d\n',data_vec) 
                else
                   display_vector_int(data_vec);
                end
            elseif isfloat(data_vec) == 1
                if prod(size(data_vec))==1
                   if is_frac_zero(data_vec)
                       fprintf('%d\n',data_vec)
                   else
                       fprintf('%.2f\n',data_vec)
                   end
                else
                   if sum(~arrayfun(@is_frac_zero,data_vec))== 0
                        display_vector_int(data_vec) 
                   else
                        display_vector_real(data_vec,2) 
                   end
                end
            elseif iscell(data_vec) == 1
                display_cell_str(data_vec)
            else
                data_vec
                fprintf('Data type not handled\n');
            end
            
            %------------------------------------------------- is_frac_zero
            function frac_zero = is_frac_zero(num)
                if num-floor(num)== 0
                   frac_zero = 1;
                else
                   frac_zero = 0;
                end
            end       
            %------------------------------------------- display_cell_str
            function display_cell_str(data_vec)
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
                
                if ~isempty(data_vec)
                    if isstr(data_vec{1}) == 1
                        % Write array to console
                        fprintf('(\t%s',data_vec{1})
                        for i = 2:length(data_vec)
                            fprintf(' \t%s',data_vec{i})
                        end
                        fprintf(')\n');
                    end
                end
            end
            %------------------------------------------- display_vector_int
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
                
                if ~isempty(data_vec)
                    % Write array to console
                    fprintf('(\t%d',data_vec(1))
                    for i = 2:length(data_vec)
                        fprintf(' \t%d',data_vec(i))
                    end
                    fprintf(')\n');
                else
                    fprintf('( )\n');
                end
            end
            %--------------------------------------------------- display_vector
            function display_vector_real(varargin)
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
                field_length = 1;
                
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
                if length(data_vec) > 1
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
        end 
    end
end


