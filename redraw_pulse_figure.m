function redraw_pulse_figure(redraw_struct)
% redraw_pulse_figure
%
% Function redraws the pulse figure based on a change in the gui. the
% structure is passed back incase the figure id is changed. Change is one
% in this code to keep alterations in gui code to a minimum.
%
% 
% redraw_struct = 
% 
%                B: [2x2 double]
%     pulse_fig_id: 8
%            t_sim: [1x61 double]
%            state: [1x1 struct]
%       pulse_plot: [1x1 struct]
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

% Clear Figure
figure(redraw_struct.pulse_fig_id);
clf;

% Draw data
redraw_struct.pulse_plot.fig_id = redraw_struct.pulse_fig_id;
[pulse_fig_id v] = create_hormone_pulse_plot(redraw_struct.pulse_plot);
hold on;

% Simulate stucture and add simulation to plot
y = NEHFilterState(redraw_struct.state, redraw_struct.state,redraw_struct.t_sim);
[pulse_fig_id v] = add_simulation_to_pulse_plot ...
    (redraw_struct.pulse_plot, y, redraw_struct.pulse_fig_id, redraw_struct.state.dT);

% Add simulation to plot
figure(redraw_struct.pulse_fig_id);
hold on
t = [redraw_struct.pulse_plot.t(1):redraw_struct.state.dT:redraw_struct.pulse_plot.t(end)];
plot(t, y, '-k','LineWidth',2)
v = axis();