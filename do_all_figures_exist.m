function varargout =  do_all_figures_exist (figure_list)
% do_all_figures_exist
%
% function determines if all figures exists.
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



% Initialize return values
some_figures_exist = 0;
all_figures_exist  = 0;
existing_fig_list  = [];


% Determine figure handles
hands     = get (0,'Children');   % locate fall open figure handles
hands     = sort(hands);          % sort figure handles
numfigs   = size(hands,1);        % number of open figures
indexes   = find(hands-round(hands)==0);


figure_check_F = @(x)sum(x == indexes);
figure_exists_array = arrayfun(figure_check_F, figure_list);

if sum(figure_exists_array) == 0
    
elseif sum(figure_exists_array) <= length(figure_list)
    % Not all figures exist
    some_figures_exist = 1;
    
end
if sum(figure_exists_array) == length(figure_list)
    % Not all figures exist
    all_figures_exist = 1;
end

existing_fig_list = figure_list(find(figure_exists_array));

if nargout == 1
    varargout{1} = all_figures_exist;
elseif nargout == 3
    varargout{1} = some_figures_exist;
    varargout{2} = all_figures_exist;
    varargout{3} = existing_fig_list;        
end