% function plot_ltsa_doa
global REMORA PARAMS PARAMS2 HANDLES2

tc = 31/35; % time correction for time slices ~= 5s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot
MS = 4;  % DOA marker size

% make plot window active:
fig = figure(REMORA.ltsa_doa.fig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,1,1) % top panel
% change plot freq axis
pwr = PARAMS.ltsa.pwr(PARAMS.ltsa.fimin:PARAMS.ltsa.fimax,:);
c = (PARAMS.ltsa.contrast/100) .* pwr + PARAMS.ltsa.bright;
% plot image
REMORA.plt.ltsa1 = image(tc.*PARAMS.ltsa.t,PARAMS.ltsa.f/1000,c);
axis xy
colormap(PARAMS.ltsa.cmap)
% xlabel('Time [hours]')
ylabel('Frequency [kHz]')
% title - always displayed
sa_title = sprintf([' CH=%d'], PARAMS.ltsa.ch);
title([PARAMS.ltsa.inpath,PARAMS.ltsa.infile, sa_title])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,1,2) % 1st doa

% time window of this plot:
toff = datenum([2000 0 0 0 0 0]);
ta = PARAMS.ltsa.plot.dnum ;
tb = PARAMS.ltsa.plot.dnum + tc * datenum([0 0 0 PARAMS.ltsa.tseg.hr 0 0]);

% detections within this time window
I = find(REMORA.doa.TDet1 >= ta + toff ...
    & REMORA.doa.TDet1 <=  tb + toff);
if isempty(I)
    T1 = ta  + tc * datenum([0 0 0 PARAMS.ltsa.tseg.hr/2 0 0]);
    D1 = 0;
    plot(T1,D1,'r*','MarkerSize',15)
else
    T1 = REMORA.doa.TDet1(I) - toff;
    D1 = REMORA.doa.Ang1(I,:);
    plot(T1,D1,'.','MarkerSize',MS)
    grid on
end
ylabel('Angles (\circ)')
v(1) = ta;
v(2) = tb;
% v(3) = -0.8e-3;
% v(4) = 0.8e-3;
v(3) = 0;
v(4) = 360;
axis(v)
datetick('keeplimits')
title([REMORA.doa.inpath1,REMORA.doa.infile1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,1,3) % lower (2nd) ltsa

PARAMS2.ltsa.plot.dnum = PARAMS.ltsa.plot.dnum;
PARAMS2.ltsa.tseg = PARAMS.ltsa.tseg;

% save orignial globals
PARAMSsav = PARAMS;
HANDLESsav = HANDLES;
PARAMS = PARAMS2;
HANDLES = HANDLES2;
read_ltsadata  % read LTSA
% save 2nd ltsa globals
PARAMS2 = PARAMS;
HANDLES2 = HANDLES;
% put original globals back
PARAMS = PARAMSsav;
HANDLES = HANDLESsav;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use same parameters as LTSA 1
PARAMS2.ltsa.fimin = PARAMS.ltsa.fimin;
PARAMS2.ltsa.fimax = PARAMS.ltsa.fimax;
PARAMS2.ltsa.contrast = PARAMS.ltsa.contrast;
PARAMS2.ltsa.bright = PARAMS.ltsa.bright;
PARAMS2.ltsa.cmap = PARAMS.ltsa.cmap;

%%%
pwr2 = PARAMS2.ltsa.pwr(PARAMS2.ltsa.fimin:PARAMS2.ltsa.fimax,:);
c2 = (PARAMS2.ltsa.contrast/100) .* pwr2 + PARAMS2.ltsa.bright;

% plot image
REMORA.plt.ltsa2 = image(tc.*PARAMS2.ltsa.t,PARAMS2.ltsa.f/1000,c2);
axis xy
colormap(PARAMS2.ltsa.cmap)
% xlabel('Time [hours]')
ylabel('Frequency [kHz]')
% title - always displayed
sa_title = sprintf([' CH=%d'], PARAMS2.ltsa.ch);
title([PARAMS2.ltsa.inpath,PARAMS2.ltsa.infile, sa_title])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,1,4)  % bottom (2nd) DOA plot

% detections within current time window
J = find(REMORA.doa.TDet2 >= ta + toff ...
    & REMORA.doa.TDet2 <=  tb + toff);
if isempty(J)
    T2 = ta  + tc * datenum([0 0 0 PARAMS.ltsa.tseg.hr/2 0 0]);
    D2 = 0;
    plot(T2,D2,'r*','MarkerSize',15)
else
    T2 = REMORA.doa.TDet2(J) - toff;
    D2 = REMORA.doa.Ang2(J,:);
    plot(T2,D2,'.','MarkerSize',MS)
    grid on
end
ylabel('Angles (\circ)')
axis(v) % use same limits as subplot 2
datetick('keeplimits')
title([REMORA.doa.inpath2,REMORA.doa.infile2])
dstr = datestr(ta + toff,'mm/dd/yyyy');
text(v(1) - (v(2) - v(1))*0.05, v(3)*1.33, dstr) 

