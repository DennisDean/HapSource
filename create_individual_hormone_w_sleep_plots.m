function [fig_ids vs]= create_individual_hormone_w_sleep_plots(varargin)
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
    time_adj_F = varargin{2};
    max_y = varargin{3};
elseif nargin == 4
    % Rescale figures acording to max_struct
    % Obsolete, using a functional form of the rescaling functions
    
    hormone_database = varargin{1};
    time_adj_F = varargin{2};
    max_y = varargin{3};
    fig_ids = varargin{4};
end

%Assign database variables
description = hormone_database.description;
subject_info = hormone_database.subject_info;
subject_data = hormone_database.subject_data;
T = hormone_database.T;
delta_t = hormone_database.delta_t;
conditions = hormone_database.conditions;
groups = hormone_database.groups;
num_subjects = hormone_database.num_subjects;

% Initialize return variable
vs = zeros(num_subjects,4);
if nargin ~= 4
    fig_ids = zeros(num_subjects,1);
end

% Plot each figure
for s = 1:num_subjects
    % Subject data (data ssumed in minutes)
    hormone_plot.t = subject_data{s}.t;
    hormone_plot.Y = subject_data{s}.Y;
    hormone_plot.T = T;    
    
    % Identifying information
    hormone_plot.subject_id_str = subject_info(s).subject_descriptor_text;
    hormone_plot.group_id_str = subject_info(s).group_id;
    hormone_plot.data_type_str = subject_info(s).data_type;
    
    % Specify sleep region
    hormone_plot.sleep_start = subject_info(s).cond_1_start';
    hormone_plot.sleep_end = subject_info(s).cond_1_end';
    
    % Data manipulation functions
    if nargin >= 2
        % time adjust plots
        hormone_plot.time_adj_F = time_adj_F;
    end
    
    % Data manipulation functions
    if nargin >= 3
        % Rescale organing to maximum structure
        hormone_plot.max_y = max_y;
    end
    
    % Data manipulation functions
    if nargin >= 3
        % Rescale organing to maximum structure
        hormone_plot.fig_id = fig_ids(s);
    end

    if isfield(hormone_database,'upper_left_corner')
       hormone_plot.upper_left_corner = hormone_database.upper_left_corner;   
    end
    
    [fig_id v] = create_hormone_subject_plot(hormone_plot);
    fig_ids(s) = fig_id;
    vs(s,:) = v;
end
