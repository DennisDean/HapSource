function [fig_id v] = create_hormone_subject_w_sleep_plot(hormone_plot)
% fig_id = create_hormone_subject_plot(hormone_plot)
%
% Function takes a hormone function sturcture and plots the data. If a 
% sleep region is specified, it is idenitified in gray.
%  
%     % Subject data (data ssumed in minutes)
%     hormone_plot.t = subject_data{s}.t;
%     hormone_plot.Y = subject_data{s}.Y;
%     hormone_plot.T = T;    
%     
%     % Identifying information
%     hormone_plot.subject_id = subject_info(s).subject_id;
%     hormone_plot.group_id = subject_info(s).group_id;
%     hormone_plot.data_type = subject_info(s).data_type;
%     
%     % Specify sleep region
%     hormone_plot.sleep_start = hormone_databasecond_1_start';
%     hormone_plot.sleep_end = hormone_databasecond_1_end';
%
% 2009 07 16  Add code to position figure if 'upper_left_corner' is defined
%
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

% Create title string
subject_id_str = hormone_plot.subject_id_str;
hormone_str = hormone_plot.data_type_str;
group_id_str = hormone_plot.group_id_str;
title_str = sprintf('%s - %s - %s',subject_id_str, hormone_str, group_id_str);

% Check for time transformation
if isfield(hormone_plot,'time_adj_F')
    t = hormone_plot.time_adj_F(hormone_plot.t);
else
    t = hormone_plot.t;
end

% Plot figure 
fig_id = figure('InvertHardcopy','off','Color',[1 1 1]);
plot(t, hormone_plot.Y, '.-','LineWidth',2, 'MarkerSize', 14 )
title(title_str, 'Interpreter', 'none','FontWeight','bold',...
    'FontSize',14)

% Set axis properties
set(gca,'LineWidth',2);
set(gca,'FontWeight','bold');
set(gca,'FontSize',14);

% Set Upper Left Corner
if isfield(hormone_plot,'upper_left_corner')
   % move figure
   set(fig_id,'Units','character');
   fig_pos = get(fig_id, 'position');
   upper_left_corner = hormone_plot.upper_left_corner;
   upper_left_corner = upper_left_corner - [ 0 fig_pos(4)];
   set(fig_id, 'position',[ upper_left_corner fig_pos(3:4)]);   
end

% Set x tick if max struct is defined
max_struct.x = 1440;
max_struct.x_tick_loc = [0:360:max_struct.x];
max_struct.x_tick_labels = {'0' '360' '720' '1080' '1440'};

%if isfield(hormone_plot,'max_struct')
   v = set_fig_max_x_xtick(fig_id, max_struct);
%end

% turn on grid
grid

% Return axis value range
v = axis();

% The axis values are hard coded so that the 





