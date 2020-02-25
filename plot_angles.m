function fig = plot_angles()

global REMORA



fig = figure(139);

% colors of each labeled whale:
col = [0.1, 0.4, 0.8;
     0.9, 0.1, 0.3;
	 0.25, 0.5, 0.05;
	 0.7, 0.1, 0.6;
	 0.9, 0.4, 0.1;
	 0.27, 0.94, 0.94;
	 0.1, 0.9, 0.1;
	 0.9, 0.74, 0.95;
     0, 0, 0];

ms = 6; % marker size

% set new vectors of plotted indices for look-up table:
REMORA.brushing.plotted.AR1 = REMORA.brushing.all.AR1.ind(REMORA.brushing.all.AR1.label>=0);
REMORA.brushing.plotted.AR2 = REMORA.brushing.all.AR2.ind(REMORA.brushing.all.AR2.label>=0);

% Define new axes for plots
mint = min([REMORA.brushing.all.AR1.TDet(REMORA.brushing.plotted.AR1); REMORA.brushing.all.AR2.TDet(REMORA.brushing.plotted.AR2)]);
maxt = max([REMORA.brushing.all.AR1.TDet(REMORA.brushing.plotted.AR1); REMORA.brushing.all.AR2.TDet(REMORA.brushing.plotted.AR2)]);

minaz1 = min(REMORA.brushing.all.AR1.Ang(REMORA.brushing.plotted.AR1, 1)); % lower bound of azimuth for array 1
minel1 = min(REMORA.brushing.all.AR1.Ang(REMORA.brushing.plotted.AR1, 2));
minaz2 = min(REMORA.brushing.all.AR2.Ang(REMORA.brushing.plotted.AR2, 1));
minel2 = min(REMORA.brushing.all.AR2.Ang(REMORA.brushing.plotted.AR2, 2));

maxaz1 = max(REMORA.brushing.all.AR1.Ang(REMORA.brushing.plotted.AR1, 1));
maxel1 = max(REMORA.brushing.all.AR1.Ang(REMORA.brushing.plotted.AR1, 2));
maxaz2 = max(REMORA.brushing.all.AR2.Ang(REMORA.brushing.plotted.AR2, 1));
maxel2 = max(REMORA.brushing.all.AR2.Ang(REMORA.brushing.plotted.AR2, 2));
%% Array 1 plotting

labels = REMORA.brushing.all.AR1.label; % pull out all labels
labels(labels==0) = 9; % shift all 0 labels to 9 so I don't get indexing errors when plotting
N = find(labels>0);
cvec = zeros(length(N), 3); % matrix of colors for plotting (rows 1-8: whale 1-8, row 9: unlabeled)

% assign cvec values for array 1:
for labelNo = 1:9
    if ismember(labelNo, labels)
        cvec(labels(N)==labelNo, :) = repmat(col(labelNo, :), [size(cvec(labels(N)==labelNo, :), 1), 1]);
    end
end

sp1 = subplot(4, 6, [1, 4]);
scatter(REMORA.brushing.all.AR1.TDet(N), REMORA.brushing.all.AR1.Ang(N,1), ms, cvec, 'filled')
datetick
set(gca, 'Xticklabel', [])
xlim([mint, maxt])
ylim([minaz1-2, maxaz1+2])
ylabel('AZ1')
grid on
subpos = get(sp1, 'Position');
set(sp1, 'Position', subpos + [-.08, .005, .08, .068])

sp2 = subplot(4, 6, [7, 10]);
scatter(REMORA.brushing.all.AR1.TDet(N), REMORA.brushing.all.AR1.Ang(N,2), ms, cvec, 'filled')
datetick
set(gca, 'Xticklabel', [])
xlim([mint, maxt])
ylim([minel1-2, maxel1+2])
ylabel('EL1')
grid on
subpos = get(sp2, 'Position');
set(sp2, 'Position', subpos + [-.08, -.025, .08, .068])
% linkaxes([sp1, sp2], 'x')

sp1 = subplot(4, 6, [5,12]);
scatter(REMORA.brushing.all.AR1.Ang(N,1), REMORA.brushing.all.AR1.Ang(N,2), ms, cvec, 'filled')
axis([minaz1-2, maxaz1+2, minel1-2, maxel1+2])
xlabel('AZ1')
ylabel('EL1')
grid on
subpos = get(sp1, 'Position');
set(sp1, 'Position', subpos + [0, 0, .08, .07])

%% Array 2 plotting

labels = REMORA.brushing.all.AR2.label; % pull out all labels
labels(labels==0) = 9; % shift all 0 labels to 9 so I don't get indexing errors when plotting
N = find(labels>0);
cvec = zeros(length(N), 3); % matrix of colors for plotting (rows 1-8: whale 1-8, row 9: unlabeled)

% assign cvec values for array 1:
for labelNo = 1:9
    if ismember(labelNo, labels)
        cvec(labels(N)==labelNo, :) = repmat(col(labelNo, :), [size(cvec(labels(N)==labelNo, :), 1), 1]);
    end
end

sp3 = subplot(4, 6, [13, 16]);
scatter(REMORA.brushing.all.AR2.TDet(N), REMORA.brushing.all.AR2.Ang(N,1), ms, cvec, 'filled')
datetick
set(gca, 'Xticklabel', [])
xlim([mint, maxt])
ylim([minaz2-2, maxaz2+2])
ylabel('AZ2')
grid on
subpos = get(sp3, 'Position');
set(sp3, 'Position', subpos + [-.08, -.055, .08, .068])

sp4 = subplot(4, 6, [19, 22]);
scatter(REMORA.brushing.all.AR2.TDet(N), REMORA.brushing.all.AR2.Ang(N,2), ms, cvec, 'filled')
datetick
xlim([mint, maxt])
ylim([minel2-2, maxel2+2])
ylabel('EL2')
grid on
subpos = get(sp4, 'Position');
set(sp4, 'Position', subpos + [-.08, -0.085, .08, .068])
% linkaxes([sp3, sp4], 'x')



sp1 = subplot(4, 6, [17,24]);
scatter(REMORA.brushing.all.AR2.Ang(N,1), REMORA.brushing.all.AR2.Ang(N,2), ms, cvec, 'filled')
axis([minaz2-2, maxaz2+2, minel2-2, maxel2+2])
xlabel('AZ2')
ylabel('EL2')
grid on
subpos = get(sp1, 'Position');
set(sp1, 'Position', subpos + [0, -.06, .08, .07])

%% autosave current data
track = REMORA.track;
brushing = REMORA.brushing;
hydLoc.H1 = REMORA.H1;
hydLoc.H2 = REMORA.H2;
hydLoc.H0 = REMORA.H0;

save('d:\tempsave.mat', 'track', 'brushing', 'hydLoc')

%% Allow keyboard commands instead of GUI button clicks

% override MATLAB's disabling of 'WindowKeyPressFcn' while brushing tool
% is active:
hManager = uigetmodemanager(fig);
[hManager.WindowListenerHandles.Enabled] = deal(false); 

% Get pressed key:
set(fig,'WindowKeyPressFcn',@keyPressCallback);

function keyPressCallback(source,eventdata)

key = eventdata.Key;

switch key
    case 'd' % delete
        delete_selection
    case 'decimal' % delete
        delete_selection
    case 'u' % undo
        global REMORA
        temp = REMORA.brushing;
        REMORA.brushing = REMORA.brushing_previous; % Store previous state of plot for undo function
        REMORA.brushing_previous = temp;
        
        plot_angles;
    case 'subtract' % undo
        global REMORA
        temp = REMORA.brushing;
        REMORA.brushing = REMORA.brushing_previous; % Store previous state of plot for undo function
        REMORA.brushing_previous = temp;
        
        plot_angles;
    case 'r' % remove label
        label_whale(0)
    case '0' % remove label
        label_whale(0)
    case 'numpad0' % remove label
        label_whale(0)
    case '1' % whale 1
        label_whale(1)
    case '2' % whale 2
        label_whale(2)
    case '3' % whale 3
        label_whale(3)
    case '4' % whale 4
        label_whale(4)
    case '5' % whale 5
        label_whale(5)
    case '6' % whale 6
        label_whale(6)
    case '7' % whale 7
        label_whale(7)
    case '8' % whale 8
        label_whale(8)
    case 'numpad1' % whale 1
        label_whale(1)
    case 'numpad2' % whale 2
        label_whale(2)
    case 'numpad3' % whale 3
        label_whale(3)
    case 'numpad4' % whale 4
        label_whale(4)
    case 'numpad5' % whale 5
        label_whale(5)
    case 'numpad6' % whale 6
        label_whale(6)
    case 'numpad7' % whale 7
        label_whale(7)
    case 'numpad8' % whale 8
        label_whale(8)
        
end
