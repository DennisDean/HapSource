function [state B t_sim] = create_initial_simulation_structures ...
                                              (defaults, pulse_plot)
% create_initial_simulation_structures
%
% Program creates the data structured required to simulate the hormone
% model.  Structure models requirements to use NEHFilterState created by
% David Nguyen.
%
% Input:
%      defaults: a structure containing the defaults set up in the calling
%              GUI
%    pulse_plot: a structure containing all the information required to
%              plot the selected pulse
%
% Ouput:
%         state: structure required to simulate the hormone data series
%             B: The state transformation matrix   
%             t: Simulation time where zero is the start of the pulse
%
% 
% 
% defaults = 
% 
%                     rho: [3x1 double]
%              rho_limits: [3x2 double]
%         pulse_start_val: 20
%          time_increment: 1
%     pulse_amplitude_val: 1.4550
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

%% Create State Variable
  state.Tinit = 0; % assume time zero at start of pulse
  state.dT = defaults.time_increment;
  state.T = pulse_plot.t(end)- pulse_plot.t(1);  % 3 hours, 180 minutes
  state.h2_init = pulse_plot.Y(1);
  state.rho = defaults.rho;
  state.A = defaults.pulse_amplitude_val;
  state.w = 0; % minutes, assume start of pulse is 
  state.rholim = defaults.rho_limits;
  state.kinampcomp = 0;

%% Create tranformation matrix    
B = [-state.rho(1)  -state.rho(3) ; state.rho(1)  -state.rho(2) ]; 

%% Create simulation time
t_sim = double([0:state.dT:state.T]);