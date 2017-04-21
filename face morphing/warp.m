function I_target = warp(I_source,pts_source,pts_target,tri)
%
% I_source : color source image  (HxWx3)
% pts_source : coordinates of keypoints in the source image  (2xN)
% pts_target : coordinates of where the keypoints end up after the warp (2xN)
% tri : list of triangles (triples of indices into pts_source)  (Kx3)
%       for example, the coordinates of the Tth triangle should be 
%       given by the expression:
%
%           pts_source(:,tri(T,:))
% 
%
% I_target : resulting warped image, same size as source image (HxWx3)
%

[h,w,d] = size(I_source);
assert(d == 3)  % we only are going to deal with color images
num_tri = size(tri,1);


% for each triangle, compute tranformation that 
% maps it to points in the source
T = zeros(3,3,num_tri); % tranformation matricies
for t = 1:num_tri
  T(:,:,t) = ttform(pts_target(:,tri(t,:)),pts_source(:,tri(t,:)));
end


% for each pixel in the target image, figure
% out which triangle it falls inside so we 
% know which transformation to use for those
% pixels
%
%  tindex(i,j) should be a value in 1...num_tri
%    which indicates what triangle contains pixel (i,j)
%    
%
tindex = zeros(h,w);

for t = 1:num_tri
  % get the 3 corners of this triangle t
  corners = pts_target(:,tri(t,:));
  mask = poly2mask(corners(1,:),corners(2,:),h,w);
    
  [size_h, size_w] = size(mask);
  for i = 1:size_h
      for j = 1:size_w
          if (mask(i,j) == 1)
              tindex(i,j) = t;
          end
      end
  end
end


%
% visualize the result to make sure it looks reasonable. 
%
% figure(1); clf;
% 
% subplot(1,2,1);
% imagesc(I_source); axis image; hold on;
% for t = 1:num_tri
%   source_tri = pts_source(:,tri(t,:));
%   plot(source_tri(1,:),source_tri(2,:),'g-');
% end
% hold off;
% title('source triangulation');

% subplot(1,2,2);
% imagesc(tindex); axis image; hold on;
% for t = 1:num_tri
%   target_tri = pts_target(:,tri(t,:));
%   plot(target_tri(1,:),target_tri(2,:),'r-');
% end
% hold off;
% title('target triangulation');




% coordinates of pixels in target image we will assume 
% target image is same size as source

[xx,yy] = meshgrid(1:w,1:h);
Xtarg = [xx(:) yy(:) ones(h*w,1)]';
% now tranform target pixels back to 
% source image
Xsrc = zeros(size(Xtarg));
for t = 1:num_tri
  % find the indicies of pixels in triangle t
  ptlist = find(tindex==t);
  % warp the coordinates of those pixels with the corresponding transformation
  Xsrc(:,ptlist) = T(:,:,t) * Xtarg(:,ptlist);
end
 
% now we know where each point in the target 
% image came from in the source, we can interpolate
% to figure out the colors
R = interp2(I_source(:,:,1),Xsrc(1,:),Xsrc(2,:), 'spline');
G = interp2(I_source(:,:,2),Xsrc(1,:),Xsrc(2,:), 'spline');
B = interp2(I_source(:,:,3),Xsrc(1,:),Xsrc(2,:), 'spline');



I_warped = zeros(h,w,3);
I_warped(:,:,1) = reshape(R,h,w);
I_warped(:,:,2) = reshape(G,h,w);
I_warped(:,:,3) = reshape(B,h,w);

I_target = I_warped;

% subplot(1,2,2);
% imagesc(tindex); axis image; hold on;
% for t = 1:num_tri
%   target_tri = pts_target(:,tri(t,:));
%   plot(target_tri(1,:),target_tri(2,:),'r-');
% end
% imagesc(I_target); axis image; hold on;
% plot(I_target);
% hold off;
% title('target triangulation');

end




