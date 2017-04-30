function Irot = rotate_image( I, angle )
 % function Irot = rotate_image(I,angle)
 % 
 %   This function takes an image I and creates a new version of the image
 %   which is rotated by amount angle
 %
 % arguments:
 %
 %   I - the original grayscale image, stored as a matrix
 %   angle - the amount by which to rotate the image
 %
 % return value:
 %   
 %   Irot - an image which containing the rotated original
 %
 if ~exist('I','var')
     error('rotate_image.m is missing input arguments.');
 end
 if ~exist('angle','var')
     error('rotate_image.m is missing input arguments.');
 end
 
 [h,w] = size(I); 
 % check if the width is even
 if mod(w,2) == 0
    x = -w/2:(w/2 - 1);
 else
    x = ceil(-w/2):floor(w/2); 
 end
 % check if the height is even
 if mod(h,2) == 0
    y = -h/2:(h/2 - 1);
 else
    y = ceil(-h/2):floor(h/2); 
 end
 % create a meshgrid
 [xcoord, ycoord] = meshgrid(x, y);
 % reshape the image brightness values
 Ivector = I(:)';
 % rotate the matrix with negative angle to keep it counterclockwise

 Xrot = rotate([xcoord(:) ycoord(:)]', -angle);
 % get the minimum and maximum coordinates in Xrot
 mincoords = round(min(Xrot'));
 maxcoords = round(max(Xrot'));
 minX = mincoords(1);
 maxX = maxcoords(1);
 minY = mincoords(2);
 maxY = maxcoords(2);
 % make new coordinates with a meshgrid using the min and max values
 [newxcoord, newycoord] = meshgrid(minX:maxX, minY:maxY);
 % use griddata to interpolate the brightness values from the old grid to
 % the new grid
 Irot = griddata(Xrot(1,:), Xrot(2,:), Ivector, newxcoord(:), newycoord(:));
 % reshape the new vector to be the same size as the new x coordinates 
    % so thet the image can be displayed at the same or similar size
    % as the original image
 Irot = reshape(Irot, size(newxcoord));

end

