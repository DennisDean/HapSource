function var_color = get_color_array(array_var, var_range, var_colormap)
%get_color_array function returns a color array that corresponds to the
%value of var array.  The var range is used to keep the mapping consitant
%between datasets.
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
LOCAL_DEBUG_FLAG = 1;
ECHO_WARNING = 0;

% Allocate memory for return value
var_color = zeros(length(array_var),3);
scaled_array_var = (double(array_var) - var_range(1))/(var_range(2)-var_range(1));

% set values less than or equal to zero to zero
zero_indexes = find(scaled_array_var <= 0);
if ~ isempty(zero_indexes)
    var_color(zero_indexes,:) = ones(size(zero_indexes))*var_colormap(1,:);
    
    % Write warning to console if values exists that are less than minimum
    % value
    if and(ECHO_WARNING == 1, ~isempty(scaled_array_var < 0))
        fprintf('---- Values less than minimum range value\n');
    end
end

% set values greater than or equal 1
one_indexes = find(scaled_array_var >= 1);
if ~ isempty(one_indexes)
    var_color(one_indexes,:) = ...
        ones(size(one_indexes))*var_colormap(end,:);
    
    % Write warning to console if values exists that are less than minimum
    % value
    if and(ECHO_WARNING == 1, ~isempty(scaled_array_var < 0))
        fprintf('---- Values less than minimum range value\n');
    end
end

% set values greater than or equal 1
scale_indexes = find(and(0 < scaled_array_var, scaled_array_var < 1 ));
if ~isempty(scale_indexes)
    % Scaled values
    scaled_values = scaled_array_var(scale_indexes);
    lookup_indexes_r = 1 + scaled_values*(length(var_colormap)-1);
    
    % Define colors
    start_color = var_colormap(floor(lookup_indexes_r),:);
    end_color = var_colormap(ceil(lookup_indexes_r),:);
    color_offset = lookup_indexes_r - floor(lookup_indexes_r);
    
    % Interpolate color between entries
    scaled_colors =  start_color + ...
        (end_color-start_color).*(color_offset*ones(1,3));
    var_color(scale_indexes,:) = scaled_colors;
end

end