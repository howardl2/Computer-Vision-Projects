function [result] = stitch(leftI,rightI,overlap)

% 
% stitch together two grayscale images with a specified overlap
%
% leftI : the left image of size (H x W1)  
% rightI : the right image of size (H x W2)
% overlap : the width of the overlapping region.
%
% result : an image of size H x (W1+W2-overlap)
%
if (size(leftI,1)~=size(rightI,1)) % make sure the images have compatible heights
  error('left and right image heights are not compatible');
end


H = size(leftI,1);
leftW = size(leftI,2);
rightW = size(rightI,2);
newW = size(leftI,2) + size(rightI,2) - overlap;


leftOverlap = leftI(:,(leftW -(overlap)+1):end);
leftRest = leftI(:,1:(leftW-overlap));
rightOverlap = rightI(:,1:overlap);
rightRest = rightI(:,(overlap+1):end);

costVector = abs(leftOverlap - rightOverlap);

path = shortest_path(costVector);

% disp(path);
aMaskLeft = zeros(size(leftOverlap));
% disp(size(aMaskLeft));
aMaskRight = zeros(size(rightOverlap));
% disp('loop');

s = size(leftOverlap);
sR = size(rightOverlap);
for i = 1:s(1)
    for j = 1:s(2)
        if (path(i) == j)
            aMaskLeft(i,j) = 0.5;
        elseif (j < path(i))
            aMaskLeft(i,j) = 1;
        else
            aMaskLeft(i,j) = 0;
        end
    end
    for j = 1:sR(2)
        if (path(i) == j)
            aMaskRight(i,j) = 0.5;
        elseif (j < path(i))
            aMaskRight(i,j) = 0;
        else
            aMaskRight(i,j) = 1;
        end
    end
end


overlapMatrix = leftOverlap.*aMaskLeft + rightOverlap.*aMaskRight;
result = [leftRest overlapMatrix rightRest];


end

