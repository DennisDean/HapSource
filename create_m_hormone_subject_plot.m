function [fig_id v ax1 ax2] = create_m_hormone_subject_plot(hormone_plot)
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
data_type_str_1 = hormone_plot.data_type_str;
subject_id =  hormone_plot.subject_id;
if isfield(hormone_plot, 'data_type_str_2')
    data_type_str_2 = hormone_plot.data_type_str_2;
    title_str = sprintf('%s - %s - %s - %d',data_type_str_1, data_type_str_2, group_id_str, subject_id);
else
    title_str = sprintf('%s - %s - %s',subject_id_str, hormone_str, group_id_str);
end
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
set(ax1,'XColor','b');
set(ax1,'YColor','b');

% Return axis value range
if isfield(hormone_plot,'max_y')
%     v = axis();
%     v(4) = hormone_plot.max_y;
%     axis(v)
end

% Set maximum value if paramter is set
if isfield(hormone_plot,'figure_limits')
     figure_limits = hormone_plot.figure_limits;
     set(ax1,'ylim',[0 figure_limits.ax1_ymax]);
end   
        

% Move plot if upper_left_corner is define
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
    % Select and adjust figure



%     % Set x limit for first axis
%     max_struct.x_tick_loc = [0:360:1440]
%     max_struct.x_tick_labels = [0:360:1440]/60 
%     max_struct.x = 1440         
%     v = set_fig_max_x_xtick(fig_id, max_struct)

    v(2) = 1440;
    axis(v)
    set(ax1,'XTick',[0:360:1440]);
    set(ax1,'XTickLabel',[0:360:1440]/60 );  

    % Get second data set
    t_2 = hormone_plot.time_adj_F(hormone_plot.t_2);
    Y_2 = hormone_plot.Y_2;
    data_type_str_2 = hormone_plot.data_type_str_2;  
  
    t_indexes = find(t_2<= 1440);
    
    % Define new axis
    ax2 = axes('Position',get(ax1,'Position'),...
       'XAxisLocation','top',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k',...
       'XLim',[0 1440]);
   
    % Draw new plot
    hl2 = line(t_2(t_indexes),Y_2(t_indexes),'Color','k','Parent',ax2, ...
        'LineWidth',2,'MarkerSize', 18, 'Marker', '.' ); 

    % Set axis properties
    set(ax2,'LineWidth',2);
    set(ax2,'FontWeight','bold');
    set(ax2,'FontSize',14);
    set(ax2,'XTick',[0:360:1440]);
    set(ax2,'XTickLabel',[0:360:1440]/60 );  
    
    % Clear x ticks
    % Set axis labels
    ax2_xticks = get(ax2,'XTick');
    ax2_labels = get(ax2,'XTickLabel');
    for l = 1:length(ax2_xticks)
        ax2_clear_labels{l} =''; 
    end
    set(ax2, 'XTickLabel', ax2_clear_labels); 
    
    % set xticks
    

    % Set maximum value if paramter is set
    if isfield(hormone_plot,'figure_limits')
        % user defined limts
        figure_limits = hormone_plot.figure_limits;
        set(ax2,'ylim',[0 figure_limits.ax2_ymax]);
    else
        % set start to 0 keep automatically defined y scale
        ylim = get(ax2,'YLim');
        ylim(1) = 0;
        set(ax2, 'YLim', ylim);   
    end 

     
    % Define corresponding axis
    xlimits = get(ax1,'XLim');
    ylimits = get(ax1,'YLim');
    xinc = (xlimits(2)-xlimits(1))/5;
    yinc = (ylimits(2)-ylimits(1))/5;
    % Now set the tick mark locations.
    % set(ax1,'XTick',[xlimits(1):xinc:xlimits(2)],...
    %    'YTick',[ylimits(1):yinc:ylimits(2)])
    set(ax1,'YTick',[ylimits(1):yinc:ylimits(2)])
    
    % Define corresponding axis
    xlimits = get(ax2,'XLim');
    ylimits = get(ax2,'YLim');
    xinc = (xlimits(2)-xlimits(1))/5;
    yinc = (ylimits(2)-ylimits(1))/5;
    % Now set the tick mark locations.
    % set(ax2,'XTick',[xlimits(1):xinc:xlimits(2)],...
    %    'YTick',[ylimits(1):yinc:ylimits(2)])
    set(ax2,'YTick',[ylimits(1):yinc:ylimits(2)])    
    
    % Set ylabels
    % set(ax1,'Ylabel','F (ug/dl)')
    % set(ax2,'Ylabel','ACTH (pg/ml')
    ylabel(ax1, 'F (ug/dl)')
    ylabel(ax2, 'ACTH (pg/ml)')
else
    ax2 = 0;
end



