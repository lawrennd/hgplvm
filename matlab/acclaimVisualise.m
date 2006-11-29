function handle = acclaimVisualise(channels, skel, padding)
%ACCLAIMVISUALISE For updating an Acclaim representation of 3-D data

%MOCAP

if nargin < 3 
    padding = 0;
end
handle = skelVisualise(channels, skel, padding);
