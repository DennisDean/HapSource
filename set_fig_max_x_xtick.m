function v = set_fig_max_x_xtick(fig_id, max_struct)
% set_max_time(fig_id, max_time)
%
% The function sets the maximum time for the selected graph


% Select and adjust figure
figure(fig_id);

% Adjust figure axis
v = axis();
v(2) = max_struct.x;
axis(v);

% Set axis labels
set(gca,'XTick',max_struct.x_tick_loc);
set(gca,'XTickLabel',max_struct.x_tick_labels);