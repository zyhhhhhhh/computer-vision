function P = predictTranslation( startX, startY, Ix, Iy, im0, im1, sigma)
%PREDICTTRANSLATIONSINGLEPT Calculating translation for a single corner pt
% startX, startY - the starting point
% im0, im1 - image frames at t and t+1
% Return value:
%   P - the new position in im1


Hassian = [sum(sum(Ix.*Ix)), sum(sum(Ix.*Iy)); sum(sum(Ix.*Iy)), sum(sum(Iy.*Iy))];
d = det(Hassian);
if abs(d) < eps(22)
    return
end
P = [startX, startY]; 
P = P';
[x,y] = meshgrid(startX-sigma:startX+sigma, startY-sigma:startY+sigma);
mat0 = interp2(im0, x,y, 'cubic');
mat1 = interp2(im1, x,y, 'cubic');
temp = mat1 - mat0;
convergence = 0.02; 
count = 0;
flag = true;
while flag
    if P(1) - sigma <= 0 || P(1) + sigma > size(im0,2) || P(2) - sigma <= 0 || P(2) + sigma > size(im0,1)
        disp('Out of Image Range');
        break;
    end
    b = - [sum(sum(Ix.*temp)); sum(sum(Iy.*temp))];
    d = Hassian\b;
    P = P + d;
    n = norm(d);
    if n < convergence || count > 20
        flag = false;
    else
        [x,y] = meshgrid(P(1)-sigma:P(1)+sigma, P(2)-sigma:P(2)+sigma);
        mat1 = interp2(im1, x, y, 'spline');
        temp = mat1 - mat0;
        count = count + 1;
    end
end

end
