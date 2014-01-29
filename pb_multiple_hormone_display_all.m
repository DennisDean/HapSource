function fig_ids = pb_multiple_hormone_display_all(varargin)
% pb_multiple_hormone_display_all
%
% Function displays two hormones on the same plot. Function was adapted
% from 'pb_display_all
%
% Revisions:
%   2009 07 16 Commented out the time
%   2009 10 01 Added figure limit
%   2009 10 01 change function to have a catch all structure for new
%        parameters
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

if nargin == 3
    % Get function call variables
    hormone_database_1 = varargin{1};
    hormone_database_2 = varargin{2};
    multiple_fig_display_struct = varargin{3};
    
    % extract parameters from structure
    overlaping_data = multiple_fig_display_struct.overlaping_data;
    
    fig_description = multiple_fig_display_struct.fig_description;
    
    if isfield(multiple_fig_display_struct, 'figure_limits')
        figure_limits =  multiple_fig_display_struct.figure_limits;
    end
elseif nargin == 4
    % Trying t get rid of this option.....
    hormone_database_1 = varargin{1};
    hormone_database_2 = varargin{2};
    overlaping_data = varargin{3};
    figure_limits = varargin{4};
end

% filter homrone database
[hormone_database_1, hormone_database_2 ] = filter_hormone_database ...
    (hormone_database_1, hormone_database_2, overlaping_data);

% Echo results to console
fprintf('--- creating figures for %s\n',hormone_database_1.description);
fprintf('--- and overlapping figures from %s\n',hormone_database_2.description);

% Create hormone plot specification
hormone_plot_spec.hormone_database_1 = hormone_database_1;
hormone_plot_spec.hormone_database_2 = hormone_database_2;
hormone_plot_spec.overlaping_data = overlaping_data;
hormone_plot_spec.hormone_database_str = '';
hormone_plot_spec.time_increment = 360;
hormone_plot_spec.max_display_time = 1440;
hormone_plot_spec.figure_description = hormone_database_1.description;
hormone_plot_spec.folder_name = '';
hormone_plot_spec.time_translation = @zero_time;
hormone_plot_spec.folder_pn = cd;
hormone_plot_spec.plot_scale_function = @set_m_fig_max_x_xtick;
hormone_plot_spec.line_styles = {'-','-.'};

% add figure limits if they are passed in
if isfield(multiple_fig_display_struct, 'figure_limits')
    hormone_plot_spec.figure_limits = figure_limits;
end

% Create figures based on specification
fig_ids = specify_multiple_hormone_database_plots(hormone_plot_spec);

% Save only if multiple plots are requested
% cludge
if ~isfield(hormone_database_1,'plot_one')
    % Save figures as tiff
    pn = cd;
    fig_description = 'amplitude_analysis_';
    subject_info = hormone_database_1.subject_info;
    
    save_fig_struct.subject_info = subject_info;
    save_fig_struct.fig_ids = fig_ids;
    save_fig_struct.pn = pn;
    save_fig_struct.fig_description = fig_description;
    figure_fn = save_figures(save_fig_struct);
end








