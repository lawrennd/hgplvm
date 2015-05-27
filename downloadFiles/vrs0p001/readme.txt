HGPLVM software
Version 0.001		Thursday 09 Nov 2006 at 15:10
Copyright (c) 2006 Neil D. Lawrence

The HGPLVM toolbox is a toolbox for hierarchical visualisation with the GP-LVM, it relies on the FGPLVM code to run.

Version 0.001
-------------

Very preliminary test version, just to act as a placeholder for the toolbox.



MATLAB Files
------------

Matlab files associated with the toolbox are:

getMaxTreeDimensions.m: 
lvmHierarchicalScatterPlot.m: 2-D scatter plot of the latent points.
demSubskels2.m: Load in the walk1 skeleton and motion capture, then break up into sub skels and learn models on each sub skel.
demSubskelsH.m: Run a given data set in the hierarchical GP-LVM.
fgplvmHierarchicalVisualise.m: Visualise the manifold.
hierarchicalModelLearner.m: Learns models for the supplied skeletal hierarchy.
demSubskels.m: Load in the walk1 skeleton and motion capture, then break up into sub skels and learn models on each sub skel.
plotSubskel.m: Plot a given subskeleton.
testFunc.m: Handler for mouse events on the latetn space axes.
hierarchicalLatentSpaceHandler.m: Event handler for the HGPLVM latent space.
