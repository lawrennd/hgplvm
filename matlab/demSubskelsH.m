function visualiseNodesData = demSubskelsH(skelFile, animFile)

% DEMSUBSKELSH Run a given data set in the hierarchical GP-LVM.
% FORMAT
% DESC Runs a given data set with the hierarchical GP-LVM. 
% ARG skelFile : The full or relative file path and name for the skeleton data file.
% ARG animFile : The full or relative file path and name for the animation data file.
% RETURN visualiseNodesData : the data structure needed for
% visualisation.
% 
% COPYRIGHT : Andrew Moore, 2006
%

% HGPLVM 
if nargin < 1
    skelFile = 'examples/walk1.asf';
    animFile = 'examples/walk1.amc';
end

if ~exist(skelFile)
    error(sprintf('Could not find skeleton data file %s', skelFile));
end
if ~exist(animFile)
    error(sprintf('Could not find animation data file %s', animFile));
end

%Load in the walk1 skeleton and motion capture, then break up into sub
%skels and learn models on each sub skel.
skel = acclaimReadSkel(skelFile);
[channels, skel] = acclaimLoadChannels(animFile, skel);

visualiseNodes(1).name = 'skeleton';
visualiseNodes(1).parent = [];
visualiseNodes(1).children = [2, 3, 4];
visualiseNodes(1).model = [];

visualiseNodes(2).name = 'upper_body';
visualiseNodes(2).parent = 1;
visualiseNodes(2).children = [5, 6, 7];
visualiseNodes(2).model = [];

visualiseNodes(3).name = 'abdomen';
visualiseNodes(3).parent = 1;
visualiseNodes(3).children = [];
visualiseNodes(3).model = [];
[visualiseNodes(3).subskel visualiseNodes(3).subchans] = skelGetSubskel(skel, ...
    'root', channels, {'lowerback'}, {'lclavicle', 'rclavicle', 'lowerneck'});
visualiseNodes(3).subchans(:, [1:3]) = 0;

visualiseNodes(4).name = 'legs';
visualiseNodes(4).parent = 1;
visualiseNodes(4).children = [8, 9];
visualiseNodes(4).model = [];

visualiseNodes(5).name = 'left_arm';
visualiseNodes(5).parent = 2;
visualiseNodes(5).children = [];
visualiseNodes(5).model = [];
[visualiseNodes(5).subskel visualiseNodes(5).subchans] = skelGetSubskel(skel, ...
    'thorax', channels, {'lclavicle'});
visualiseNodes(5).subchans(:, [1:3]) = 0;

visualiseNodes(6).name = 'head';
visualiseNodes(6).parent = 2;
visualiseNodes(6).children = [];
visualiseNodes(6).model = [];
[visualiseNodes(6).subskel visualiseNodes(6).subchans] = skelGetSubskel(skel, ...
    'thorax', channels, {'lowerneck'});
visualiseNodes(6).subchans(:, [1:3]) = 0;

visualiseNodes(7).name = 'right_arm';
visualiseNodes(7).parent = 2;
visualiseNodes(7).children = [];
visualiseNodes(7).model = [];
[visualiseNodes(7).subskel visualiseNodes(7).subchans] = skelGetSubskel(skel, ...
    'thorax', channels, {'rclavicle'});
visualiseNodes(7).subchans(:, [1:3]) = 0;

visualiseNodes(8).name = 'left_leg';
visualiseNodes(8).parent = 4;
visualiseNodes(8).children = [];
visualiseNodes(8).model = [];
[visualiseNodes(8).subskel visualiseNodes(8).subchans] = skelGetSubskel(skel, ...
    'root', channels, {'lhipjoint'});
visualiseNodes(8).subchans(:, [1:3]) = 0;

visualiseNodes(9).name = 'right_leg';
visualiseNodes(9).parent = 4;
visualiseNodes(9).children = [];
visualiseNodes(9).model = [];
[visualiseNodes(9).subskel visualiseNodes(9).subchans] = skelGetSubskel(skel, ...
    'root', channels, {'rhipjoint'});
visualiseNodes(9).subchans(:, [1:3]) = 0;

%recursively learn the models in the hierarchy, start with leaf models,
%then composite models will learned on the latent values of the leaves.
modelOptions = fgplvmOptions('ftc');
modelLatentDim = 2;
visualiseNodesData = hierarchicalModelLearner(visualiseNodes, modelOptions, modelLatentDim);

end
