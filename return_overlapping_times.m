function [a_index b_index times] = return_overlapping_times(d1, d2)
% return_overlapping_times
%
% 
% load 'paired_data.mat'
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
% Copyright � [2012] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%

a = d1(:,1);
b = d2(:,1);

% compare times
[tf b_index] = ismember(a, b);
[tf a_index] = ismember(b, a);

% remove zeros from longer string
ind = find(a_index>0);
a_index = a_index(ind);
ind = find(b_index>0);
b_index = b_index(ind);

% get common times
times = a(a_index);


a = double(a(a_index));
b = double(b(b_index));


c = double(d1(a_index,2));
d = double(d2(b_index,2));

figure();
imagesc( cov(c*d'));

figure();
plot(c,d);;

figure();
mscohere(c,d);

c = xcorr(c,d);
figure()
plot(c)
