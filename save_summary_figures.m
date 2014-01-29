function figure_fns = save_figures(save_fig_struct)
% figure_fn = save_figures(fig_ids, fig_description)
%
% function saves each figure into a seperate file. the figure description
% is also used to create a folder where files are placed.
%
% Hormone plot specification
%     save_fig_struct.pn = folder_pn;
%     save_fig_struct.fig_description = figure_description;
%     save_fig_struct.subject_info = hormone_database.subject_info;
%     save_fig_struct.folder_name = folder_name;
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

% Get function parameters from structure
summary_info = save_fig_struct.summary_info;
fig_ids = save_fig_struct.fig_ids;
pn = save_fig_struct.pn;
fig_description = save_fig_struct.fig_description;

% Program Constant
extension = '.tiff';

% Determine number of figures to print
num_figs = length(fig_ids);
figure_fns = cell(num_figs,1);

% create directory
orig_dir = cd;
cd(pn);
tf = isdir(fig_description);
if tf~= 1
    [s,mess,messid] = mkdir(pn, fig_description);
end
cd(fig_description)

% Save each figure
group_descriptor_text = summary_info;
for f = 1:length(fig_ids)
    fn = strcat(fig_description , group_descriptor_text{f},extension);
    fig_id = fig_ids(f);
    figure(fig_id);
    saveas(fig_id, fn) ;
end

% return to original directory
cd(orig_dir);
