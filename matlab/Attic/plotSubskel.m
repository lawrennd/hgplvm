function visHandle = plotSubskel(visIndex, model, skel, padding)

% PLOTSUBSKEL Plot a given subskeleton.
% FORMAT 
% DESC plots a sub skeleton on for the given visualisation.
% ARG visIndex : the index of the visualisation structure into which the
% plot will be made.
% ARG model : the model containing the learned information about
% the skeleton to be plotted.
% ARG skel : the skeleton structure to be plotted.
% ARG padding : any padding to be added to the skeleton.
%
% COPYRIGHT Andrew Moore, 2006
%

% HGPLVM
global visualiseInfo;
figure(2)

visData = zeros(1, model.d);
%set visData to frame with max sum of squares of joint angles
[void, maxInd] = max(sum((model.y.*model.y), 2));
visData = model.y(maxInd, :);

visHandle = visualiseInfo(visIndex).visualiseFunction(visData, skel, visIndex, padding);

set(visHandle, 'eraseMode', 'xor');
colormap gray;




