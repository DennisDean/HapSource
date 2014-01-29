function saved = save_as_screen(h,fn)
% save_as(h,fn)
%
% Wrapper function for matlab 'saveas' file returns a 1 to be compatible
% with array functions. 'PaperPositionMode' paper position mode is set to
% insure that figure appears as on screen.
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

% Echo results to console
full_file_name = fn{1};
k = findstr('\', full_file_name);
file_name = full_file_name(k(end)+1:end);

fprintf('--- Saving file %s\n',file_name);

% % Save file - use print command for finer control
% saveas(h,full_file_name);
set(h,'PaperPositionMode','auto');
figure(h)
% cmd = sprintf('print(''f%d'',''-r300'',''-dtiff'',full_file_name);',h)
% eval(cmd)
print(gcf,'-r300','-dtiff',full_file_name);

% Define dummy return value
saved = 1;