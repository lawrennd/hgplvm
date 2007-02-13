function visualiseNodes = hierarchicalModelLearner(visualiseNodes, modelOptions, modelLatentDim)
% HIERARCHICALMODELLEARNER Learns models for the supplied skeletal hierarchy.
% FORMAT
% DESC Takes in a structure containing a skeletal hierarchy, and
% recursively learns a GPLVM on each node.
% ARG visualiseNodes: A visualiseNodes structure.
% ARG modelOptions: A struct containing the model options, usually obtained 
% from fgplvmOptions('...').  Default to FTC if not present.
% ARG modelLatentDim: Dimensionality of the latent space.  Defaults to 2.
% RETURN A visulaiseNodes structure with the field 'model' modified
% for each node to contain a GPLVM model structure for that node.
%
% COPYRIGHT : Andrew Moore, 2006

if nargin < 3
    modelLatentDim = 2;
end
if nargin < 2
    modelOptions = fgplvmOptions('ftc');
end

learnModels();

%Recursive function to traverse the hierarchy from bottom up, learning
%a GPLVM at each node.
    function learnModels(nodeIndex)
        if nargin < 1
            nodeIndex = 1;
        end
        nodeChildren = visualiseNodes(nodeIndex).children;
        modelData = [];
        if length(nodeChildren) > 0
            for i=1:length(nodeChildren)
                learnModels(nodeChildren(i));
                modelData = [modelData visualiseNodes(nodeChildren(i)).model.X];
            end
            
        else
             %subsample the model data.
             modelData = visualiseNodes(nodeIndex).subchans(1:4:end, :);
        end
        
        modelDataDim = size(modelData, 2);
        
        visualiseNodes(nodeIndex).model = fgplvmCreate(modelLatentDim, modelDataDim,...
            modelData, modelOptions);
        visualiseNodes(nodeIndex).labels = [];  
        
        %calculate padding for leaf nodes.
        if length(nodeChildren) == 0
            %find the max value of the channels index
            maxInd = 0;
            subskel = visualiseNodes(nodeIndex).subskel;
            for i=1:length(subskel.tree)
                for j=1:length(subskel.tree(i).rotInd)
                    if subskel.tree(i).rotInd(j) > maxInd
                        maxInd = subskel.tree(i).rotInd(j);
                    end
                end
                for j=1:length(subskel.tree(i).posInd)
                    if subskel.tree(i).posInd(j) > maxInd
                        maxInd = subskel.tree(i).posInd(j);
                    end
                end
            end
            visualiseNodes(nodeIndex).padding = maxInd - size(visualiseNodes(nodeIndex).model.y, 2);
        else
            visualiseNodes(nodeIndex).padding = [];
        end
        
    end  
end
