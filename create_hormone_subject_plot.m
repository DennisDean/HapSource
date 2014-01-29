function [fig_id v ] = create_hormone_subject_plot(hormone_plot)
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
% Revisons:
%    2009 07 16 Problem has been revised so that the the program isn't
%    rescaled in y.  No needed for a pass analysis where we want to
%    determine individual differences.
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

% Program Constants
DEBUG = 0;

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
if isfield(hormone_plot,'fig_id')
    fig_id = hormone_plot.fig_id;
    figure(fig_id);clf
else
    fig_id = figure('InvertHardcopy','off','Color',[1 1 1]);clf
end

if DEBUG == 1
    test = size(t)
    test_2 = size(hormone_plot.Y)
    
    if sum(test) ~= sum(test_2)
        t
        hormone_plot.Y
        subject_id_str = hormone_plot.subject_id_str
    end
end

plot(t, hormone_plot.Y, '.-','LineWidth',2, 'MarkerSize', 18 );
title(title_str, 'Interpreter', 'none','FontWeight','bold',...
    'FontSize',14)
ax1 = gca;

% Set axis properties
set(ax1,'LineWidth',2);
set(ax1,'FontWeight','bold');
set(ax1,'FontSize',14);

% Return axis value range
if isfield(hormone_plot,'max_y')
%     v = axis();
%     v(4) = hormone_plot.max_y;
%     axis(v)
end

if isfield(hormone_plot, 'upper_left_corner')
   set(fig_id,'units', 'character');
   fig_pos = get(fig_id, 'position');
   fig_pos(1) = hormone_plot.upper_left_corner(1);
   fig_pos(2) = hormone_plot.upper_left_corner(2)-fig_pos(4);
   set(fig_id, 'position', fig_pos); 
end

% GEt boundary information
v = axis();


% Check for sleep boundary
if isfield(hormone_plot,'sleep_start')
    
    % add sleep plots
    sleep_period = hormone_plot.time_adj_F([hormone_plot.sleep_start hormone_plot.sleep_end]);
    sleep_start = sleep_period(1);
    sleep_end = sleep_period(2);
    
    % create sleep string
    delta = min(diff(t));
    t1 = [t(1):delta:sleep_start];
    y1 = zeros(1,length(t1));
    t2 = [sleep_start:delta:sleep_end];
    y2 = ones(1,length(t2))*v(4);
    t3 = [sleep_end:delta:t(end)];
    y3 = zeros(1,length(t3));
    
    t_s = [t1, t2, t3];
    y_s = [y1, y2, y3];
    
    figure(fig_id)
    hold on; area(t_s, y_s,'FaceColor',[0.90 0.90 0.90],'EdgeColor','None');
    hold on; plot(t, hormone_plot.Y, '.-','LineWidth',2, 'MarkerSize', 14 );
    hold off;
    
    % Mark sleep period if available
    sleep_start = sleep_period(1)+1440;
    sleep_end = sleep_period(2)+1440;
    
    if sleep_end < t(end)
        line([sleep_start sleep_start], v(3:4), 'color', [0.0 0.0 0.0], 'LineWidth', 1.5,'LineStyle', '--')
        line([sleep_end sleep_end], v(3:4), 'color', [0.00 0.00 0.00],  'LineWidth', 1.5,'LineStyle', '--')
    end
    
    % display tick marks on top  
    set(gca,'Layer','top')
end

% Add second plot if it exists
if isfield(hormone_plot,'t_2')
    t_2 = hormone_plot.time_adj_F(hormone_plot.t_2);
    Y_2 = hormone_plot.Y_2;
    data_type_str_2 = hormone_plot.data_type_str_2;  
        
    ax2 = axes('Position',get(ax1,'Position'),...
       'XAxisLocation','top',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k');
    hl2 = line(t_2,Y_2,'Color','k','Parent',ax2);
    
    
    % Set axis properties
    set(ax2,'LineWidth',2);
    set(ax2,'FontWeight','bold');
    set(ax2,'FontSize',14);
else
    ax2 = 0;
end



