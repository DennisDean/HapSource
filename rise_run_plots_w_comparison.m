function [fig_id fig_fn] = rise_run_plots_w_comparison...
    (data_type, x_data,       y_data,    interactive_table_struct,...
     indexes,   marker_color, fig_descr, y_limit, plot_type, x_limit)
% rise_run_plots
%
% Plots selected data in a scatter plot
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


% Program Constant
GROUP_ID = 3;
PULSE_START = 4;
PULSE_AMPLITUDE = 5;
RISE_WIDTH = 6;
DECENT_AMPLITUDE = 7;
DECENT_WIDTH = 8;
C_CHAR = 67;
H_CHAR = 70;

% Create Secretion XY Plot control only
fig_fn = sprintf('%s_%s', interactive_table_struct.data_type, fig_descr);
fig_id = figure('InvertHardcopy','off','Color',[1 1 1]);
scatter(x_data(indexes),y_data(indexes),[],marker_color,'LineWidth',2);
set(gca,'yscale','log')
title(sprintf('%s - %s',data_type, plot_type),'FontWeight','bold','FontSize',14)
xlabel(interactive_table_struct.table_key{RISE_WIDTH},'FontWeight','bold','FontSize',12)
ylabel(interactive_table_struct.table_key{PULSE_AMPLITUDE},'FontWeight','bold','FontSize',12)
box on
ax1 = gca;
set(ax1,'YLim',y_limit);
set(ax1,'XLim',x_limit);
set(ax1,'YScale','log');
set(ax1,'YMinorTick','on');
set(ax1,'LineWidth',2);
set(ax1,'FontWeight','bold');
set(ax1,'FontSize',14);

% Add color bar
% Create colorbar
colorbar('peer',ax1, 'location','East');