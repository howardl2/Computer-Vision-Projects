
%load image
I = im2double(rgb2gray(imread('crooked_horizon.jpg')));
figure(1); imshow(I);
%get 2 points to straighten
[x,y] = ginput(2);
% formula for straightening 2 points
% theta = atan(tan((y(2)-y(1))/(x(2)-x(1)))) * 180/pi;
theta = atan((y(2)-y(1))/(x(2)-x(1))) * 180/pi;

%if rotation is 0 or 90 degrees
if x(1) == x(2)
  if y(1) == y(2)
    theta = 0;
  else 
    theta = 90;    
  end
end
%rotate the image by calling the correct function
rotated = rotate_image(I, theta);
%display the rotated image
figure(2); imshow(rotated);

