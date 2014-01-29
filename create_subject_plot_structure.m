function hormone_plot = ...
         create_subject_plot_structure(hormone_database,subject_id_val)
% create_subject_plot_structure
%
% Function takes a hormone database and an id_val.  The id_val is used to
% extract the appropriate information for plotting data. The function makes
% the assumption that only the first 24 hours will be used for analyis.
%
% hormone_plot structure
%     % Subject data (data ssumed in minutes)
%     hormone_plot.t = subject_data{s}.t;
%     hormone_plot.Y = subject_data{s}.Y;
%     hormone_plot.T = T;    
%     
%     % Identifying information
%     hormone_plot.subject_id = subject_info(s).subject_id;
%     hormone_plot.group_id = subject_info(s).group_id;
%     hormone_plot.data_type = subject_info(s).data_type;
%     
%     % Specify sleep region
%     hormone_plot.sleep_start = hormone_databasecond_1_start';
%     hormone_plot.sleep_end = hormone_databasecond_1_end';
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

% Get datbase structures
subject_data = hormone_database.subject_data;
subject_info = hormone_database.subject_info;

% Subject data (data ssumed in minutes)
hormone_plot.t = zero_time(subject_data{subject_id_val}.t);
hormone_plot.Y = subject_data{subject_id_val}.Y;
hormone_plot.T = hormone_database.T;    

% Identifying information
hormone_plot.subject_id = subject_info(subject_id_val).subject_id;
hormone_plot.subject_id_str = subject_info(subject_id_val).subject_descriptor_text;
hormone_plot.group_id_str = subject_info(subject_id_val).group_id;
hormone_plot.data_type_str = subject_info(subject_id_val).data_type;

% Specify sleep region
hormone_plot.sleep_start = subject_info(subject_id_val).cond_1_start;
hormone_plot.sleep_end = subject_info(subject_id_val).cond_1_end;

if isfield(hormone_database,'upper_left_corner')
    hormone_plot.upper_left_corner = hormone_database.upper_left_corner;   
end