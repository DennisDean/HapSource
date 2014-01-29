function figure_fns = save_hierarchical_figures(save_fig_struct, output_fig_fns)
% figure_fn = save_hierarchical_figures(fig_ids, fig_description)
%
% The function saves files from into the selected folder. The current
% version is a minor revision of the save_figures function. It is expected
% the structures and functions will evolve to save figure into seperate
% folders according to subject, group, or type.
%
% fig_description is also used to create a folder where files are placed.
% this will change
%
% save_fig_struct =
%
%     application_root_dir: [1x121 char]
%            result_folder: 'Segmentation'
%       figure_description: 'rise_times_hist'
%               subject_id: 23
%           subject_id_str: 'cort_23'
%             group_id_str: 'C'
%            data_type_str: 'Cortisol'
%              subject_num: 23
%                   fig_id: [1 2 3 4 5 6 7]
%
% output_fig_fns: cell array of file names (figure file name)
%   Could pass output)_fig_fns in struct, may be a bug in MATLAB
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
DEBUG_FLAG = 0;

% Get function parameters from structure
subject_info = save_fig_struct.subject_id_str;
fig_ids = save_fig_struct.fig_ids;
pn = save_fig_struct.application_root_dir;
fig_description = output_fig_fns;

% Echo main inputs to console
if DEBUG_FLAG == 2
    save_fig_struct
    output_fig_fns
    subject_info
    fig_ids
    pn
    fig_description
end

% Program Constant
extension_cell = {'.tiff','.fig'};

% Determine number of figures to print
num_figs = length(fig_ids);
figure_fns = cell(num_figs,1);

% create directory
orig_dir = cd;
cd(pn);

% Define
if isfield(save_fig_struct,'folder_name')
    % if folder name is specified create folder
    tf = isdir(strcat('./',save_fig_struct.folder_name));
    if tf~= 1
        [s,mess,messid] = mkdir(pn, 'CFL_Estimation');
    end
    %cd(save_fig_struct.folder_name)
    cd('CFL_Estimation');
end

% Save each figure
% subject_descriptor_text = subject_info.subject_descriptor_text;
for e = 1: length(extension_cell)
    extension = extension_cell{e};
    for f = 1:length(fig_ids)
        subject_descriptor_text  = output_fig_fns{f};
        fn = strcat( save_fig_struct.data_type_str, '_',...
            num2str(save_fig_struct(1).subject_id),'_', ...
            save_fig_struct.group_id_str,'_',fig_description{f}, extension);
        fig_id = fig_ids(f);
        figure(fig_id);
        saveas(fig_id, fn) ;
    end
end

% return to original directory
cd(orig_dir);
