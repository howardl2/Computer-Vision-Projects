% taken from homework directions
X = 10*rand(2,50);              % generate 50 random points in 2D
figure(1); clf;                 % display a figure and clear it.
plot(X(1,:),X(2,:),'b.');       % plot the original points as green dots
Xrot = rotate(X,45);            % rotate the points by 45 degrees counterclockwise
hold on;                        % tell matlab to not clear the figure when plotting additional points
plot(Xrot(1,:),Xrot(2,:),'r.'); % plot the rotated points on the same figure

% look at the rotation of 3 points to make it easier to see
X = 10*rand(2,3);
figure(2); clf;
plot(X(1,:), X(2,:), 'b.');
Xrot = rotate(X,45);
hold on;
plot(Xrot(1,:), Xrot(2,:), 'r.');




