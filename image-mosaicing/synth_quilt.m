function output = synth_quilt(tindex,tile_vec,tilesize,overlap)
%
% synthesize an output image given a set of tile indices
% where the tiles overlap, stitch the images together
% by finding an optimal seam between them
%
%  tindex : array containing the tile indices to use
%  tile_vec : array containing the tiles
%  tilesize : the size of the tiles  (should be sqrt of the size of the tile vectors)
%  overlap : overlap amount between tiles
%
%  output : the output image

if (tilesize ~= sqrt(size(tile_vec,1)))
  error('tilesize does not match the size of vectors in tile_vec');
end

% each tile contributes this much to the final output image width 
% except for the last tile in a row/column which isn't overlapped 
% by additional tiles
tilewidth = tilesize-overlap;  

% compute size of output image based on the size of the tile map
outputsize = size(tindex)*tilewidth+overlap;

colCount = 0;
for i = 1:(size(tindex,1))
    for j = 1:(size(tindex,2)-1)

    if (j == 1)
        lastImage = tile_vec(:,tindex(i,j));
        lastImage = reshape(lastImage, tilesize,tilesize);
    else               
        right_tile = tile_vec(:,tindex(i,j));
        right_tile = reshape(right_tile,tilesize,tilesize);
        lastImage = stitch(lastImage,right_tile,overlap);
    end
    end
    
    if (colCount == 0)
        output = rot90(lastImage);
        colCount = colCount + 1;
    else
        tempOut = stitch(output, rot90(lastImage), overlap);
        output = tempOut;     
    end
end
output = rot90(output,3);   
end


