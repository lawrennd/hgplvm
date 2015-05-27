HGPLVM software
Version 0.002		Wednesday 29 Nov 2006 at 12:01
Copyright (c) 2006 Neil D. Lawrence

The HGPLVM toolbox is a toolbox for hierarchical visualisation with the GP-LVM, it relies on the FGPLVM code to run.

Version 0.001
-------------

Very preliminary test version, just to act as a placeholder for the toolbox.



MATLAB Files
------------

Matlab files associated with the toolbox are:

acclaim2xyzHierarchical.m: Compute XYZ values given skeleton structure and channels.
demRun1.m: Show visualisation of the run.
demSubskels.m: Load in the walk1 skeleton and motion capture, then break up into sub skels and learn models on each sub skel.
demSubskels2.m: Load in the walk1 skeleton and motion capture, then break up into sub skels and learn models on each sub skel.
demSubskelsH.m: Run a given data set in the hierarchical GP-LVM.
demWalk1.m: Show visualisation of the walk.
fgplvmHierarchicalVisualise.m: Visualise the manifold.
getMaxTreeDimensions.m: 
hierarchicalLatentSpaceHandler.m: Event handler for the HGPLVM latent space.
hierarchicalModelLearner.m: Learns models for the supplied skeletal hierarchy.
lvmHierarchicalScatterPlot.m: 2-D scatter plot of the latent points.
plotSubskel.m: Plot a given subskeleton.
skelGetSubskel.m: Gets a sub-skeleton from a larger skeleton.
skelModifyHierarchical.m: Helper code for visualisation of skel data.
skelVisualiseHierarchical.m: For updating a skel representation of 3-D data.
testFunc.m: Handler for mouse events on the latetn space axes.
