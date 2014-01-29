function [fid fn] = scattermatrix_pulse(data,label,data_description)
%  scattermatrix_pulse
%
%  plot a matrix of scatter plots
%  scattermatrix(data,label)
%  takes data columnwise in pairs
%  label is a cell or string array of labels for diagonal boxes
%
% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $
%
% Revised to fit into Hierarchically Adaptive Hormone Analysis software
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

% Default
data_description = data_description;

% Process input
nseries = size(data,2);  % number of data series
v = zeros(1,4);

%  if labels are not given, make some
if nargin<2
   for ii = 1:nseries
      label{ii} = ['Series' int2str(ii)];
   end
end

% Create figure identifiers
fid = figure('InvertHardcopy','off','Color',[1 1 1]);
fn = 'multi_scatter';

% Generate figure subplots
for ic = 1:nseries
   for ir = 1:nseries
      subplot(nseries,nseries,(nseries-ir)*nseries+ic)
      if ir==ic
         %  position and size label
         scatter(data(:,ic),data(:,ir),1,'w')
         naxis = axis;
         tx = 0.5*(naxis(1)+naxis(2));
         ty = 0.5*(naxis(3)+naxis(4));
%          hg = text(tx,ty,char(label(ic)),'HorizontalAlignment','center',...
%               'FontWeight','bold', 'FontSize',9.8);
         %set(hg,'FontSize',round(27/nseries))
         
         % set(gca,'FontSize',14)
         set(gca,'FontWeight','bold')                
         set(gca,'LineWidth',2) 
      else
         %  plot data points
         scatter(data(:,ic),data(:,ir),'LineWidth',2)
         
         set(gca,'FontSize',14)
         set(gca,'FontWeight','bold')                
         set(gca,'LineWidth',2) 
      end
      %  make plots slightly bigger than default
      pos = get(gca,'Position');
      pos(3:4) = 1.13*pos(3:4);
      set(gca,'Position',pos)
      set(gca,'FontSize',round(24/nseries))
      box on
      %  place labels on overall edges
      if ir~=1
         set(gca,'XTickLabel',[])
      end
      if ic~=1
         set(gca,'YTickLabel',[])
      end
      if ir == ic
          v = axis;
         tx = 0.5*(v(1)+v(2));
         ty = 0.7*(v(3)+v(4));
         ty2 = 0.33*(v(3)+v(4));
         hg = text(tx,ty,char(label(ic)),'HorizontalAlignment','center',...
              'FontWeight','bold', 'FontSize',9.8);
         set(hg,'FontSize',round(27/nseries))
         hg2 = text(tx,ty2,char(data_description),'HorizontalAlignment','center',...
              'FontWeight','bold', 'FontSize',9.8);
         set(hg2,'FontSize',round(27/nseries))        
         % set(gca,'FontSize',14)
         set(gca,'FontWeight','bold')                
         set(gca,'LineWidth',2) 
      end
   end
end



