function [hormone_database database_is_loaded ] = ...
        load_hormone_database_from_file(database_fn, database_pn)
% load_hormone_database_from_file 
%
% 
% hormone_database struct:
%      description: 'Adler cortisol data'
%     subject_info: [1x28 struct]
%     subject_data: {28x1 cell}
%                T: 1440
%          delta_t: 10
%       conditions: {'sleep'  'wake'}
%           groups: {'C'  'F'}
%     num_subjects: 28
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

% Program Constant
DEBUG = 1;


% Initialize return variables
old_pwd = cd;

% Load struct
cd(database_pn);
load(database_fn);

% Variable assignments
defined_variables = who;
var_chk_f = @(x)strcmp(x,'hormone_database');
database_is_loaded = sum(cellfun(var_chk_f, who));
if database_is_loaded == 0
    % initialize return variable to empy cell array
    hormone_database = {};
else
    % database load successfully
    hormone_database = hormone_database;   
end

% Reset working directory
cd(old_pwd);

if database_is_loaded == 1
    % Echo summary to console   
    fprintf('--- Loading database\n    fn = %s, num subjects = %d\n    description = %s\n',...
            database_fn,...
            hormone_database.num_subjects,...
            hormone_database.description);
end