
function [pulse_fig_id v] = add_simulation_to_pulse_plot...
    (pulse_plot, Y, pulse_fig_id,simulated_time_increment )
% add_simulation_to_pulse_plot
%
% Program adds simulation plot to the raw data plot created by the function
% 'create_hormone_pulse_plot'.
%
% 
% pulse_plot = 
% 
%        subject_id_str: 'GH_1'
%                     t: [7x1 int32]
%                     Y: [7x1 double]
%          pulse_id_val: 2
%              group_id: 'F'
%           sleep_start: 0
%             sleep_end: 480
%                   pt1: [20 1.4450]
%                   pt2: [50 2.9000]
%                   pt3: [80 0.9800]
%     upper_left_corner: [63.4000 55.3385]
%      pulse_library_fn: 'adler_GH_pulse_library.mat'
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

% check tha tfigure exists
fig_exists = does_figure_exist(pulse_fig_id);
if fig_exists ~= 1
    % create pulse figure
    [pulse_fig_id v] = create_hormone_pulse_plot(pulse_plot);
end

% Add simulation to plot
figure(pulse_fig_id);
hold on
t = [pulse_plot.t(1):simulated_time_increment:pulse_plot.t(end)];
plot(t, Y, '-k','LineWidth',2)
v = axis();


