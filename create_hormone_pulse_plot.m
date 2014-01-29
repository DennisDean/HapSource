function [pulse_fig_id v] = create_hormone_pulse_plot(pulse_plot)
% create_hormone_pulse_plot
%
%
%
%        subject_id_str: 'GH_1'
%                     t: [100x1 int32]
%                     Y: [100x1 double]
%          pulse_id_val: 1
%              group_id: 'F'
%           sleep_start: 0
%             sleep_end: 480
%     upper_left_corner: [63.4000 55.3385]
%
% fig_id = create_hormone_subject_plot(hormone_plot)
%
% Function takes a hormone function sturcture and plots the data. If a
% sleep region is specified, it is idenitified in gray. if 'fig_id' is
% defined the figure will be redrawn in an existing figure.
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
subject_id_str = pulse_plot.subject_id_str;
group_id = pulse_plot.group_id;
pulse_id_val = pulse_plot.pulse_id_val;
title_str = sprintf('%s - %s - %d',upper(subject_id_str),  upper(group_id), pulse_id_val);

% Check for time transformation
if isfield(pulse_plot,'time_adj_F')
    t = pulse_plot.time_adj_F(hormone_plot.t);
else
    t = pulse_plot.t;
end

% Plot figure
if isfield(pulse_plot,'fig_id')
    fig_id = pulse_plot.fig_id;
    figure(fig_id);
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

% Check for subplot
if isfield(pulse_plot,'sub_plot')
    hold on
    subplot(pulse_plot.num_rows,pulse_plot.num_cols,pulse_id_val)
end
plot(t, pulse_plot.Y, '.-','LineWidth',2, 'MarkerSize', 18 );
title(title_str, 'Interpreter', 'none','FontWeight','bold',...
    'FontSize',14)

% Set axis properties
set(gca,'LineWidth',2);
set(gca,'FontWeight','bold');
set(gca,'FontSize',14);
if isfield(pulse_plot,'grp')
    set(gca,'FontSize',8);
end


% Return axis value range
if isfield(pulse_plot,'max_y')
    %     v = axis();
    %     v(4) = hormone_plot.max_y;
    %     axis(v)
end

if isfield(pulse_plot, 'upper_left_corner')
    set(fig_id,'units', 'character');
    fig_pos = get(fig_id, 'position');
    fig_pos(1) = pulse_plot.upper_left_corner(1);
    fig_pos(2) = pulse_plot.upper_left_corner(2)-fig_pos(4);
    set(fig_id, 'position', fig_pos);
end

% GEt boundary information
v = axis();
pulse_fig_id = fig_id;
v(1) = t(1);
v(2) = t(end);
v(4) = max(pulse_plot.Y)*1.1;
axis(v)

% Check for sleep boundary
if isfield(pulse_plot,'sleep_start')
    
    is_in_sleep = and(pulse_plot.pt1(1) >= pulse_plot.sleep_start, ...
        pulse_plot.pt3(1) <= pulse_plot.sleep_end);
    
    if is_in_sleep == 1
        
        % add sleep plots
        sleep_period = [min(v(1),pulse_plot.pt1(1)) ...
                        max(v(2),pulse_plot.pt3(1))];
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
        hold on; plot(t, pulse_plot.Y, '.-','LineWidth',2, 'MarkerSize', 18 );
        axis(v);
        hold off;

        % display tick marks on top  
        axis(v)
        set(gca,'Layer','top')
       
    end
end

grid