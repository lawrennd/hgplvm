function hierarchialLatentSpaceHandler(src, eventdata, action, visualiseNodes)
%Handler for mouse events on the latent space axes.  The UserData parameter
%of the CurrentAxes that has received the mouse event refers to a
%visualiseInfo structure containing the related skeleton data.
%visualiseNodes contains the model and skeleton info, and is passed in.
%visualiseInfo contains the plot, and is global.


global visualiseInfo
%check this has been called from a valid axes (one where there is a defined
%UserData).

if gcf ~= src %check that the latent window is actually the current figure.
    return;
end
axesIndex = get(gca, 'UserData');
if ~isempty(axesIndex)
    switch action
        case 'click'
            point  = get(gca, 'CurrentPoint');
            x = point(1, 1);
            y = point(1, 2);
            xlim = get(gca, 'XLim');
            ylim = get(gca, 'YLim');
            if (x > xlim(1) && x < xlim(2) && y > ylim(1) && y < ylim(2))
                visualiseInfo(axesIndex).latentPos = [x, y];
                visualiseInfo(axesIndex).clicked = ~visualiseInfo(axesIndex).clicked;
                if isfield(visualiseInfo(axesIndex).model, 'dynamics') & ~isempty(visualiseInfo(axesIndex).model.dynamics)
                    if visualiseInfo(axesIndex).runDynamics
                        visualiseInfo(axesIndex).dynamicsRunning = 1;
                        fhandle = str2func([visualiseInfo(axesIndex).model.type 'DynamicsRun']);
                        feval(fhandle);
                        visualiseInfo(axesIndex).dynamicsRunning = 0;
                    end
                else
                    visualiseInfo(axesIndex).dynamicsRunning = 0;
                end
            end
        case 'move'
            point  = get(gca, 'CurrentPoint');
            x = point(1, 1);
            y = point(1, 2);
            xlim = get(gca, 'XLim');
            ylim = get(gca, 'YLim');
            if (x > xlim(1) && x < xlim(2) && y > ylim(1) && y < ylim(2) &&...
                    visualiseInfo(axesIndex).clicked && ~visualiseInfo(axesIndex).runDynamics)
 %               set(visualiseInfo(axesIndex).latentHandle, 'xdata', x, 'ydata', y);
                updateVisualisation(axesIndex, x, y);
                fhandle = str2func([visualiseInfo(axesIndex).model.type 'PosteriorMeanVar']);
 %               [mu, varsigma] = getDataPoints(x, y, visualiseInfo(axesIndex));
 %               Y = mu;

                %should really adjust the positions for all child spaces.
                %Question of how deep to descend the hierarchy. 1 level
                %(current)?
                %all levels?
%                nodeChildren = visualiseNodes(axesIndex).children;
%                 if (length(nodeChildren) > 0)
%                     %mu should be of length 2*numChildren (2 coords per
%                     %latent space)
%                     for i = 1:length(nodeChildren)
%                         muX = mu(2*i - 1);
%                         muY = mu(2*i);
%                         set(visualiseInfo(nodeChildren(i)).latentHandle, 'xdata', muX, 'ydata', muY);
%                         visualiseInfo(nodeChildren(i)).latentPos=[muX, muY];
%                         [Y1, var1] = getDataPoints(muX, muY, visualiseInfo(nodeChildren(i)));
%                         %if the child is a leaf node, modify its skeleton,
%                         %else propagate the latent space movement through
%                         %the hierarchy.
%                         if length(visualiseNodes(nodeChildren(i)).children) == 0
%                             visualiseInfo(nodeChildren(i)).visualiseModify(visualiseInfo(nodeChildren(i)).visHandle, ...
%                                 Y1, visualiseNodes(nodeChildren(i)).subskel, visualiseNodes(nodeChildren(i)).padding);
%                         else
%                             childNodeChildren = visualiseInfo(nodeChildren(i)).children;
%                             for j = 1:length(childNodeChildren)
%                                 axes(visualiseInfo(childNodeChildren(j)).plotAxes);
%                                 
%                         end
%                     end
%                 else
%                     visualiseInfo(axesIndex).visualiseModify(visualiseInfo(axesIndex).visHandle, ...
%                         Y, visualiseNodes(axesIndex).subskel, visualiseNodes(axesIndex).padding);
%                     visualiseInfo(axesIndex).latentPos=[x, y];
%                 end
            end
    end
else
    error('No UserData property defined for this axis. The UserData property should contain an index to the visualiseInfo for this structure.');
end

    %Given latent points x and y, return expected data points and variance
    function [mu, sigma] = getDataPoints(x, y, visualiseInfo)
    fhandle = str2func([visualiseInfo.model.type 'PosteriorMeanVar']);
    [mu, sigma] = fhandle(visualiseInfo.model, [x y]);
    if isfield(visualiseInfo.model, 'noise')
        Y = noiseOut(visualiseInfo.model.noise, mu, varsigma);
    else
        Y = mu;
    end
    end

    %Updates the visualisation given the latent coordinates of the current node
    %(indicated by the axes the operation was performed on). Recursively works
    %through the hierarchy.  Remember, only leaf nodes represent a mapping to
    %data space.  
    function updateVisualisation(nodeIndex, coordX, coordY)
        [mu, varsigma] = getDataPoints(coordX, coordY, visualiseInfo(nodeIndex));
        visualiseInfo(nodeIndex).latentPos=[coordX, coordY];
        set(visualiseInfo(nodeIndex).latentHandle, 'xdata', coordX, 'ydata', coordY);
        Y = mu;
        nodeChildren = visualiseNodes(nodeIndex).children;
        if (length(nodeChildren) > 0)
            %mu should be of length 2*numChildren (2 coords per
            %latent space)
            for i = 1:length(nodeChildren)
                muX = mu(2*i - 1);
                muY = mu(2*i);
                %set(visualiseInfo(nodeChildren(i)).latentHandle, 'xdata', muX, 'ydata', muY);
                %visualiseInfo(nodeChildren(i)).latentPos=[muX, muY];
                %[Y1, var1] = getDataPoints(muX, muY, visualiseInfo(nodeChildren(i)));
                %if the child is a leaf node, modify its skeleton,
                %else propagate the latent space movement through
                %the hierarchy.
                updateVisualisation(nodeChildren(i), muX, muY);
            end
                %if length(visualiseNodes(nodeChildren(i)).children) == 0
                 %   visualiseInfo(nodeChildren(i)).visualiseModify(visualiseInfo(nodeChildren(i)).visHandle, ...
                  %      Y1, visualiseNodes(nodeChildren(i)).subskel, visualiseNodes(nodeChildren(i)).padding);
                %else
                 %   childNodeChildren = visualiseInfo(nodeChildren(i)).children;
                  %  for j = 1:length(childNodeChildren)
                   %     axes(visualiseInfo(childNodeChildren(j)).plotAxes);

                %end
            %end
        else
            visualiseInfo(nodeIndex).visualiseModify(visualiseInfo(nodeIndex).visHandle, ...
                Y, visualiseNodes(nodeIndex).subskel, visualiseNodes(nodeIndex).padding);
            %visualiseInfo(axesIndex).latentPos=[x, y];
        end
        
    end

end
