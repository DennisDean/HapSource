function [pulse_struct pulse_selected] = get_pulse_points(fig_id, data)
% rect  = get_rectangle_2(fig_id)
% 
% Uses constrain_ginput_to_data to select points corresponding to start
% pulse start, pulse amplitude, and pulse end.
% 
% input:
%    fig_id: figure id
%    data: cell array of points
%
% ouput:
%     pulse_struct.pt1   = pt1;   % Pulse start
%     pulse_struct.idx1  = idx1;  % Pulse start data index
%     pulse_struct.pt2   = pt2;   % Pulse peak point
%     pulse_struct.idx2  = idx2;  % Pulse peak data index
%     pulse_struct.pt3   = pt3;   % Pulse end point
%     pulse_struct.idx3  = idx3;  % Pulse end point
%     pulse_struct.w1    = w1;    % Start to peak width
%     pulse_struct.h1    = h1;    % Start to peak height
%     pulse_struct.w2    = w2;    % peak to end width
%     pulse_struct.h2    = h2;    % peak to end height
%     pulse_struct.rect1 = rect1; % rise rectangle
%     pulse_struct.rect2 = rect2; % decent rectangle
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
DEBUG = 1;

% Define return structure
pulse_struct.pt1   = [];
pulse_struct.idx1  = -1;
pulse_struct.pt2   = [];
pulse_struct.idx2  = -1;
pulse_struct.pt3   = [];
pulse_struct.idx3  = -1;
pulse_struct.w1    = -1;
pulse_struct.h1    = -1;
pulse_struct.w2    = -1;
pulse_struct.h2    = -1;
pulse_struct.rect1 = [];
pulse_struct.rect2 = [];

% Move focus to figure
figure(fig_id);
hold on

% Select and plot first point
[pt1 idx1]= constrain_ginput_to_data(data);    
plot(pt1(1),pt1(2),'r.');
fprintf('pt1 selected (%d, [%.0f,%.1f]), ', idx1, pt1(1), pt1(2));

% Select and plot second point
[pt2 idx2] = constrain_ginput_to_data(data);   
plot(pt2(1),pt2(2),'r.');
fprintf('pt2 selected (%d, [%.0f,%.1f]), ', idx2, pt2(1), pt2(2));

% Select and plot third point
[pt3 idx3] = constrain_ginput_to_data(data);   
plot(pt3(1),pt3(2),'r.');
fprintf('pt3 selected (%d, [%.0f,%.1f])\n', idx3, pt3(1), pt3(2));

% Return pulse point to blue
plot(pt1(1),pt1(2),'b.');        
plot(pt2(1),pt2(2),'b.');
plot(pt3(1),pt3(2),'b.');

% Rect1 - Convert points to standard format
w1 = abs(pt1(1)- pt2(1));
h1 = abs(pt1(2)- pt2(2));
rect1 = [ min(pt1(1),pt2(1)),  min(pt1(2),pt2(2)), ...
          w1,                  h1];
     
% Rect1 - Convert points to standard format
w2 = abs(pt2(1)- pt3(1));
h2 = abs(pt2(2)- pt3(2));
rect2 = [ min(pt2(1),pt3(1)),  min(pt2(2),pt3(2)), ...
          w2,                  h2];
     
hold on
if ~and(or(w1 == 0, h1 == 0),or( w2 == 0, h2 == 0)) 
    % Draw rectangles
    if ~or(w1 == 0, h1 == 0)
        rectangle('Position', rect1, 'EdgeColor', 'm')
    end
    if ~or( w2 == 0, h2 == 0)
        rectangle('Position', rect2, 'EdgeColor', 'r')
    end
    % Prepare structure for return
    pulse_struct.pt1   = pt1;
    pulse_struct.idx1  = idx1 ;
    pulse_struct.pt2   = pt2;
    pulse_struct.idx2  = idx2;
    pulse_struct.pt3   = pt3;
    pulse_struct.idx3  = idx3;
    pulse_struct.w1    = w1;
    pulse_struct.h1    = h1;
    pulse_struct.w2    = w2;
    pulse_struct.h2    = h2;
    pulse_struct.rect1 = rect1;
    pulse_struct.rect2 = rect2;
    
    % set flag
    pulse_selected = 1;
else
    pulse_selected = 0;
    
end


