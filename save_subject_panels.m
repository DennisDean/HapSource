function save_subject_panels (pulse_panel_fig_ids, subj_tiff_fn, subj_fig_fn)
% save_subject_panels
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

 % Generate subject ids
 subj_array_F = @(num)[1:1:num];

 % Determine number of subjects
 num_subjects = length(pulse_panel_fig_ids);
 
% Save each figure
save_tiff_F = @(id)save_as_screen(pulse_panel_fig_ids(id),subj_tiff_fn(id));
save_fig_F = @(id)save_as(pulse_panel_fig_ids(id),subj_fig_fn(id));
subj_tiff_fn = arrayfun(save_tiff_F,subj_array_F(num_subjects));
subj_fig_fn = arrayfun(save_fig_F,subj_array_F(num_subjects));
