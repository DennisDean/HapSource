function [fig_ids vs ax1s ax2s]= create_multiple_individual_hormone_w_sleep_plots(varargin)
% fig_ids = create_individual_hormone_plot(hormone_database)
%
% Function creates data plot for each entry in the hormone database.
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

% Process input
if nargin == 1
    % generate automatically scaled MATLAB figures
    hormone_database = varargin{1};
elseif nargin == 2
    % Generate new figure ids and adjust time scales
    hormone_database = varargin{1};
    time_adj_F = varargin{2};
elseif nargin == 3
    % Generate new figure ids and adjust time scales
    hormone_database = varargin{1};
    hormone_database_2 = varargin{2};
    time_adj_F = varargin{3};
elseif nargin == 4
    % Generate new figure ids and adjust time scales
    hormone_database = varargin{1};
    hormone_database_2 = varargin{2};
    time_adj_F = varargin{3};
    max_y = varargin{4};
elseif nargin == 5
    % Rescale figures acording to max_struct
    % Obsolete, using a functional form of the rescaling functions
    hormone_database = varargin{1};
    hormone_database_2 = varargin{2};
    time_adj_F = varargin{3};
    max_y = varargin{4};
    fig_ids = varargin{5};
end

% Set function flags
DEBUG_FLAG = 1;

%Assign database variables
description = hormone_database.description;
subject_info = hormone_database.subject_info;
subject_data = hormone_database.subject_data;
T = hormone_database.T;
delta_t = hormone_database.delta_t;
conditions = hormone_database.conditions;
groups = hormone_database.groups;
num_subjects = hormone_database.num_subjects;

% Assign subject variables for second database if it exists
if nargin >= 3
    description_2 = hormone_database_2.description;
    subject_info_2 = hormone_database_2.subject_info;
    subject_data_2 = hormone_database_2.subject_data;
    T_2 = hormone_database_2.T;
    delta_t_2 = hormone_database_2.delta_t;
    conditions_2 = hormone_database_2.conditions;
    groups_2 = hormone_database_2.groups;
    num_subjects_2 = hormone_database_2.num_subjects;
end


% Initialize return variable
vs = zeros(num_subjects,4);
if nargin ~= 4
    fig_ids = zeros(num_subjects,1);
end


% Select plot start and stop
start_subject = 1;
end_subject = num_subjects;
if isfield(hormone_database, 'plot_one')
    start_subject = hormone_database.plot_one;
    end_subject = hormone_database.plot_one;
    
    % Allocate return value size
    vs = zeros(1,4);
    if nargin ~= 4
        fig_ids = zeros(1,1);
    end
    
elseif isfield(hormone_database_2, 'plot_one')
    start_subject = hormone_database_2.plot_one;
    end_subject = hormone_database_2.plot_one;
    
    % Allocate return value size
    vs = zeros(1,4);
    if nargin ~= 4
        fig_ids = zeros(1,1);
    end
end


% Plot each figure
for s = start_subject:end_subject
    % Subject data (data ssumed in minutes)
    hormone_plot.t = subject_data{s}.t;
    hormone_plot.Y = subject_data{s}.Y;
    hormone_plot.T = T;
    
    % Identifying information
    hormone_plot.subject_id_str = subject_info(s).subject_descriptor_text;
    hormone_plot.group_id_str = subject_info(s).group_id;
    hormone_plot.data_type_str = subject_info(s).data_type;
    hormone_plot.subject_id = subject_info(s).subject_id;
    
    % Specify sleep region
    hormone_plot.sleep_start = subject_info(s).cond_1_start';
    hormone_plot.sleep_end = subject_info(s).cond_1_end';
    
    % Data manipulation functions
    if nargin >= 2
        % time adjust plots
        hormone_plot.time_adj_F = time_adj_F;
    end
    
    % Add second signal to plot
    if nargin >= 3
        % time adjust plots
        hormone_plot.t_2 = subject_data_2{s}.t;
        hormone_plot.Y_2 = subject_data_2{s}.Y;
        hormone_plot.data_type_str_2 = subject_info_2(s).data_type;
        hormone_plot.subject_id_2 = subject_info_2(s).subject_id;
    end
    
    if DEBUG_FLAG == 1
        % Data structure
        coupled_data = struct();
        coupled_data.t =  hormone_plot.t;
        coupled_data.Y = hormone_plot.Y ;
        coupled_data.t2 = hormone_plot.t_2 ;
        coupled_data.Y2 = hormone_plot.Y_2 ;
        
        % Data arrays
        d1 = [coupled_data.t, coupled_data.Y];
        d2 = [coupled_data.t2, coupled_data.Y2];
        
        save('paired_data.mat','coupled_data', 'd1', 'd2');
        xlswrite('d1.xls', d1)
        xlswrite('d2.xls', d2)
    end
    
    % Data manipulation functions
    if nargin >= 4
        % Rescale organing to maximum structure
        hormone_plot.max_y = max_y;
    end
    
    % Data manipulation functions
    if nargin >= 4
        % Rescale organing to maximum structure
        hormone_plot.fig_id = fig_ids(s);
    end
    
    if isfield(hormone_database,'upper_left_corner')
        hormone_plot.upper_left_corner = hormone_database.upper_left_corner;
    end
    
    [fig_id v  ax1 ax2] = create_m_hormone_subject_plot(hormone_plot);
    fig_ids(s) = fig_id;
    vs(s,:) = v;
    ax1s(s) = ax1;
    ax2s(s) = ax2;
end
