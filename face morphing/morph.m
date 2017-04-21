%   %
%   % morphing script
%   %
% 

% TEST FROM PIAZZA
% [xx,yy] = meshgrid(linspace(0,1,100),linspace(0,1,120));
% C = double(xor(mod(floor(xx*10),2),mod(floor(yy*12),2)));
% I = cat(3,C,C,C);
%  
% % warp it using a triangular mesh of 5 points
% pts_source = [60; 50];
% pts_target = [80; 80];
% pts_source = [pts_source [0 100 100 0; 0 0 120 120]];
% pts_target = [pts_target [0 100 100 0; 0 0 120 120]];
% tri = [1 2 3; 1 3 4; 1 4 5; 1 5 2];
% Iwarped = warp(I,pts_source,pts_target,tri);


% load in two images...
I1 = im2double(imread('artistic_1.jpg'));
I2 = im2double(imread('artistic_2.jpg'));

% I1 = im2double(imread('brad_pitt.jpg'));
% I2 = im2double(imread('brittany_snow.jpg'));

% I1 = im2double(imread('scalene.jpg'));
% I2 = im2double(imread('equilateral.jpg'));

% get user clicks on keypoints using either ginput or cpselect tool

%I used 20 points typically
imshow(I1);
[x1,y1] = getpts();
pts_img1(1,:) = x1;
pts_img1(2,:) = y1;
  
imshow(I2);
[x2,y2] = getpts();
pts_img2(1,:) = x2;
pts_img2(2,:) = y2;

% the more pairs of corresponding points the better... ideally for 
% faces ~20 point pairs is good include several points around the
% outside contour of the head and hair.

% you may want to save pts_img1 and pts_img2 out to a .mat file at
% this point so you can easily reload it without having to click
% again. 

% append the corners of the image to your list of points
% this assumes both images are the same size and that your
% points are in a 2xN array

[h,w,~] = size(I1);
pts_img1 = [pts_img1 [0 0]' [w 0]' [0 h]' [w h]'];
pts_img2 = [pts_img2 [0 0]' [w 0]' [0 h]' [w h]'];


% generate triangulation 
pts_halfway = 0.5*pts_img1 + 0.5*pts_img2;

% disp(size(pts_halfway));

tri = delaunay(pts_halfway');



% now produce the frames of the morph sequence
nframes = 5;

for fnum = 1:nframes
    t = (fnum-1)/(nframes-1);

    % intermediate key-point locations
    pts_target = (1-t)*pts_img1 + t*pts_img2;                

    %warp both images towards target
    I1_warp = warp(I1, pts_img1, pts_target, tri);              
    I2_warp = warp(I2, pts_img2, pts_target, tri);          
    
    
    % blend the two warped images
    Iresult = (1-t)*I1_warp + t*I2_warp;                     

    % display frames
%     figure(1); clf; imagesc(Iresult); axis image; drawnow;   

    % alternately save them to a file to put in your writeup
    imwrite(Iresult,sprintf('frame_%2.2d.jpg',fnum),'jpg');   
    
    
    %from PIAZZA to make a GIF
    [Iind, Icm] = rgb2ind(Iresult, 256, 'nodither');
    if fnum == 1
        imwrite(Iind, Icm, 'result.gif', 'gif', 'DelayTime', 1, 'LoopCount', inf);
    elseif fnum == 61
        imwrite(Iind, Icm, 'result.gif', 'gif', 'DelayTime', 1, 'WriteMode', 'append');
    else
        imwrite(Iind, Icm, 'result.gif', 'gif', 'DelayTime', 0, 'WriteMode', 'append');
    end
end

disp('end');
