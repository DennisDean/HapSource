function [pulse_panel_fig_ids subj_tiff_fn subj_fig_fn] = create_hormone_pulse_panel_plots...
        (hormone_database, pulse_library, num_subjects, ...
        num_pulses_by_subject, display_width_val)
 % create_hormone_pulse_panel_plots
 %
 % Function uses arrayfun to plot panel for each subject.  
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
    
 
 % Program constants:
 DEBUG = 1;
 SAVE_FIGURES = 1;
 SAVE_FOLDER = '\panel_figures\';
 
 % Generate subject ids
 subj_array_F = @(num)[1:1:num];
 
 % Add group flag to hormone database
 hormone_database.grp = 1;
 
 % Pulse panel figure id
 process_each_subject_F =...
     @(subject_id)create_hormone_pulse_panel_plot(...
     hormone_database,...
     pulse_library,subject_id,...
     [1:num_pulses_by_subject(subject_id)],...
     display_width_val);
 subjects = [1:num_subjects];
 pulse_panel_fig_ids = arrayfun(process_each_subject_F, subjects);
 
% Get subject names
get_subject_id_F = @(struct_x)getfield(struct_x,'subject_id_str');
subject_strs = cellfun(get_subject_id_F, pulse_library);

% Create figure file names to store (assume panel directory created)
fn_tiff_F = @(subj_id)strcat(cd,SAVE_FOLDER,subject_strs(subj_id),'_panel.tiff');
fn_fig_F = @(subj_id)strcat(cd,SAVE_FOLDER,subject_strs(subj_id),'_panel.fig');
subj_tiff_fn = arrayfun(fn_tiff_F,subj_array_F(num_subjects));
subj_fig_fn = arrayfun(fn_fig_F,subj_array_F(num_subjects));

% Maximize each figure
% status = arrayfun(@max_fig,pulse_panel_fig_ids);

% % Save each figure
% save_tiff_F = @(id)save_as(pulse_panel_fig_id(id),subj_tiff_fn(id));
% save_fig_F = @(id)save_as(pulse_panel_fig_id(id),subj_fig_fn(id));
% subj_tiff_fn = arrayfun(save_tiff_F,subj_array_F(num_subjects));
% subj_fig_fn = arrayfun(save_fig_F,subj_array_F(num_subjects));
