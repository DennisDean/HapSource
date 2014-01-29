function fig_info = plot_histogram_from_inter_table(varargin)
% plot_histogram_from_inter_table
%
% Create historgrams for main pulse information.
%
%
%     interactive_table_struct_1.table
%     interactive_table_struct_1.table_key
%     interactive_table_struct_1.data_type
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
NUM_BINS = 50;
FILTER = 0;
ADJUST_AXIS = 0;

%
if nargin == 1
    interactive_table_struct = varargin{1};
elseif nargin == 2
    interactive_table_struct = varargin{1};
    upper_left_corner = varargin{2};
end

% Create variables for return information
fig_id_hist = [];
fig_fns = cell(4,1);
for f = 5:8
    % Create figure
    fid = figure('InvertHardcopy','off','Color',[1 1 1]);
    if FILTER == 1
        filter_indexes = find(interactive_table_struct.table(:,f) <2000);
        hist(interactive_table_struct.table(filter_indexes,f),NUM_BINS);
        ax1 = gca;
        if ADJUST_AXIS == 1
            set(ax1,'xlim',[0 250]);
            set(ax1,'ylim',[0 160]);
        end
    else
        hist(interactive_table_struct.table(:,f),NUM_BINS)
    end
    if nargin == 2
        pos = get(fid,'Position');
        pos([1:2]) = upper_left_corner;
        set(fid,'Position',pos);
    end
    ax1 = gca;
    
    % Add title to figures
    title_str = sprintf('%s - %s',interactive_table_struct.data_type, ...
        interactive_table_struct.table_key{f});
    title(title_str,'FontWeight','bold','FontSize',14)
    
    % Add axis label
    label_str = sprintf('%s ( %s )',interactive_table_struct.data_type, ...
        interactive_table_struct.units);
    label_str = sprintf('( %s )',interactive_table_struct.units);
    xlabel(label_str,'FontWeight','bold','FontSize',14)
    
    %create fig file name
    fig_fn = sprintf('%s_%s_',interactive_table_struct.data_type, ...
        interactive_table_struct.table_key{f});
    fig_fns{f-4} = fig_fn;
    
    % change axis information
    set(ax1, 'LineWidth', 2);
    set(ax1, 'FontWeight','bold');
    set(ax1, 'FontSize',14);
    set(ax1, 'CLim',[1 2]);
    
    % Save figure id
    fig_id_hist = [fig_id_hist;fid];
end

% create return structure
fig_info.fig_fns = fig_fns;
fig_info.fig_id_hist = fig_id_hist;