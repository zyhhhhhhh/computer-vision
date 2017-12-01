function [keyXs, keyYs] = getKeypoints(im, threshold)
%GETKEYPOINTS Get keypoints from im, using Harris detector
%   Input:
%   - im: image
%   - threshold: threshold
% In my implementation, I use Gaussian to smooth the Harris window

i = ndims(im);
if i == 3
    im = rgb2gray(im);
end

im = im2double(im);

% Calculate the gradient
dx = fspecial('sobel');
dy = dx';
    
dx = conv2(im, dx, 'same');    % Image derivatives
dy = conv2(im, dy, 'same');  

dx2 = dx.^2;
dy2 = dy.^2;
dxy = dx.*dy;

sigma = 1.5

% Convolution
bound = floor(3*sigma);
gaussian_filter = fspecial('gaussian', [2*bound+1, 2*bound+1], sigma);

dx2 = imfilter(dx2, gaussian_filter, 'same');
dy2 = imfilter(dy2, gaussian_filter, 'same');
dxy = imfilter(dxy, gaussian_filter, 'same');

result = (dx2.*dy2 - dxy.^2)./(dx2 + dy2 + eps(22));

radius = 6; 
wsize = 2*radius+1;                     
mx = ordfilt2(result,wsize^2,ones(wsize));
s = size(result)
temp = zeros(s);
temp(wsize - 1:end - wsize + 1, wsize - 1:end - wsize + 1) = 1;

key = (result==mx)&(result>threshold)&temp; 
	
[keyYs, keyXs] = find(key);

end