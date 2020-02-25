% From local planar coordinate system to latitude longitude geographical
% coordinate system involves translation, rotation, and scaling of
% coordinate system.
%Input 
% (x,y):        the points location of local planar coordinate system. unit in meter
% (lat0,lon0):	the latitude longitude for the origin point of the local planar coordinate system
% azimuth:      the azimuth angle of x-axis of the local coordinate system,
%               y-axis is clockwise from x-axis.
%
% output    points with Lat=LatLon(1); Lon=LatLon(2);
% Notice:   Not suitable for calculing large scale points. For points within 1 km,
%           the accuracy depends on the azimuth angle.

% example: Set the local origin point (0,0) at (55.709264 N, 13.201449 E), a building corner
%          the azimuth angle of x-axis is 104.5 deg
%          the the point (74.59,14.75) of the local coordinate system has lat
%          lon as 
%          LatLon = xy2latlon(74.59,14.75,55.709264,13.201449,104.5);
%
% See also latlon2xy  
% Hongxiao Jin  Nov 29 2014

function LatLon = xy2latlon(x,y,lat0,lon0,azimuth)
LatLon = [];
if size(x,1) >size(x,2), x=x'; end
if size(y,1) >size(y,2), y=y'; end
if size(x,1) ~= 1
    msgbox('x should be a vector!');return;
end
if size(y,1) ~= 1
    msgbox('y should be a vector!');return;
end
if size(y,2) ~= size(x,2)
    msgbox('x y should be vectors of equal length !');return;
end    
    
R = 6371007.181; % earth radius Spheric model, same as Sinosoidal projection system
PI=3.141592653589793238;
theta=azimuth-90;
LatLon= [lat0 lon0]'*ones(size(x)) + (180/PI) * [1 0;0 1/cos(PI*lat0/180)]*[cos(PI*theta/180) -sin(PI*theta/180); sin(PI*theta/180) cos(PI*theta/180)]*[y;x]/R;

