function Xrot = rotate(X, angle)
% function Xrot = rotate(X,angle)
 % 
 %   This function takes a set of points stored in X and
 %   applies a rotation specified by angle.
 %   
 % arguments: 
 %
 %   X :  a 2xN matrix of points where the first row gives the x coordinate
 %        of each point and the second row gives the y coordinate of each point
 %
 %   angle : the amount to rotate counter-clockwise, in degrees
 %
 %
 % return value:
 %  
 %  Xrot : a 2xN matrix containing the rotated points.
 %  
 if ~exist('X','var')
     error('rotate.m is missing input arguments.');
 end
 if ~exist('angle','var')
     error('rotate.m is missing input arguments.');
 end
 if ~isnumeric(angle)
     error('Invalid angle value for function rotate.m');
 end
 [a,b] = size(angle);
 if a ~= 1 || b ~= 1
     error('Invalid angle dimension for function rotate.m');
 end
 [m,n] = size(X);
 if m ~= 2
     error('Input matrix for rotate.m should be 2xN, but instead got %dX%d',m,n);
 end
% convert the angle to radians to be used on sin and cos
 radianAngle = degtorad(angle);
% create the rotation matrix using sin and cos to create a 2x2 matrix
 rotationMatrix = [cos(radianAngle), -sin(radianAngle); sin(radianAngle), cos(radianAngle)];
 % multiply the rotation matrix with the original input matrix to create
 % the rotated matrix
 Xrot = rotationMatrix * X;

end

