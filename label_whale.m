function label_whale(whaleNo)
% Activated when one of the whale buttons is pushed. Takes the highlighted
% points on figure 139 and stores them as whaleNo. 


global REMORA

REMORA.brushing_previous = REMORA.brushing; % Store previous state of plot for undo function

fig = figure(139);

N1 = [];    % initialize indices of displayed points to be removed, array 1
N2 = [];    % initialize indices of displayed points to be removed, array 2


for spn = 1:length(fig.Children) % iterate through each subplot of fig 139
    ylabelStrings{spn} = fig.Children(spn).YLabel.String;
    
    % find reference subplot number for each array (TDet vs Az)
    if strcmp(fig.Children(spn).YLabel.String, 'AZ1')
        spn1 = spn;
    elseif strcmp(fig.Children(spn).YLabel.String, 'AZ2')
        spn2 = spn;
    end
    
    % Find indices of all datapoints to be labeled
    brushData = fig.Children(spn).Children.BrushData; % select the data from the most recent brush
    
    if ~isempty(brushData)
        
        arrayNo = fig.Children(spn).YLabel.String(3); % get array number

        switch arrayNo
            case '1'
                Ntemp = find(brushData~=0);
                N1 = [N1, Ntemp];
            case '2'
                Ntemp = find(brushData~=0);
                N2 = [N2, Ntemp];
        end

    end
%     clear fig.Children(spn).Children.BrushData
end

N1 = unique(N1); % remove duplicate indices
N2 = unique(N2);

N1rem = REMORA.brushing.plotted.AR1(N1);
N2rem = REMORA.brushing.plotted.AR2(N2);

REMORA.brushing.all.AR1.label(N1rem) = whaleNo;
REMORA.brushing.all.AR2.label(N2rem) = whaleNo;


% brush off


plot_angles;
