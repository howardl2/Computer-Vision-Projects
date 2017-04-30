
I = im2double(rgb2gray(imread('insta.png')));

figure(1); imshow(I);

Irot = rotate_image(I, 45);

figure(2); imshow(Irot);