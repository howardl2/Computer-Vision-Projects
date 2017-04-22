function [path] = shortest_path(costs)
% given a 2D array of costs, compute the minimum cost vertical path
% from top to bottom which, at each step, either goes straight or
% one pixel to the left or right.
%
% costs:  a HxW array of costs
%
% path: a Hx1 vector containing the indices (values in 1...W) for 
%       each step along the path
    [N,M] = size(costs);
 
    T = padarray(costs,[0 1]);

    path = zeros([N 1]);

    s = size(T);
    
    for i = 2:s(1)
        for j = 2:(s(2)-1)
            findMin = [T(i-1,j-1) T(i-1,j) T(i-1,j+1)];
            if (j == 2)
                findMin = [T(i-1,j) T(i-1,j+1)];
            end
            if (j == (s(2)-1))
                findMin = [T(i-1,j-1) T(i-1,j)];
            end
            T(i,j) = T(i,j) + min(findMin);
        end
    end
    
    T = T(1:s(1),2:(s(2)-1));
    
    minValue = min(T(s(1),:));
    minPath = find(T(s(1),:) == minValue);
    
    minPath = minPath(1);
    path(N) = minPath;
    
    i = N-1;
   
    backtrackIndex = zeros([N 1]);
    backtrackCost = zeros([N 1]);
    
    while (i >= 1)
        
        if (minPath == 1)
            neighbors = [T(i,minPath) T(i,minPath+1)];    
            indexes = [minPath minPath+1];
        elseif (minPath == M)
            neighbors = [T(i,minPath-1) T(i,minPath)];
            indexes = [minPath-1 minPath];
        else
            neighbors = [T(i, minPath-1) T(i,minPath) T(i, minPath+1)];
            indexes = [minPath-1 minPath minPath+1];
        end

        [minVal,minIndex] = min(neighbors);

        y = find(neighbors == minVal);
        if (size(y) > 1)
           backtrackIndex(i) = i;
           backtrackCost(i) = backtrackCost(i) + minVal;      
        end
        
        x = indexes(minIndex);
        path(i) = x(1);
        minPath = x(1);

        i = i - 1;
    end
end