function rect  = get_rectangle_2(fig_id)
% rect  = get_rectangle_2(fig_id)
% 
% Uses g_input to select 
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

% Move focus to figure
figure(fig_id);
hold on
pt1 = ginput(1);     
plot(pt1(1),pt1(2),'k.');
pt2 = ginput(1);         
plot(pt2(1),pt2(2),'k.');
plot(pt1(1),pt1(2),'k.');        
plot(pt2(1),pt2(2),'k.');

% Convert points to standard format
w = abs(pt1(1)- pt2(1));
h = abs(pt1(2)- pt2(2));
rect = [ min(pt1(1),pt2(1)),  min(pt1(2),pt2(2)), ...
         w,                   h];
hold on
%plot(x,y, '-w')
if ~or(w == 0, h== 0) 
    rectangle('Position', rect, 'EdgeColor', 'k')
end
