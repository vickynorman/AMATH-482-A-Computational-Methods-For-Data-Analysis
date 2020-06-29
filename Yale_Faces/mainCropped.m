clear all; close all;
%load images
images = [dir('/Users/vick/Documents/AMATH482/hw1/CroppedYale/YaleB06')];

%read images and store data in a matrix with one column per image
numfiles = length(images);
mydata = cell(1, numfiles);

for k = 3:numfiles
    mydata{k-2} = imread(sprintf(images(k).name));
    data(:,k-2) = reshape(double(mydata{k-2}),[],1);
end

%perform svd
[u,s,v] = svd(data, 'econ');

%plot singular values
s1 = diag(s);
figure
plot(s1,'ro','Linewidth',[2])
title('Values of Sigma from SVD, subject 06, cropped.')
ylabel('Sigma value')
xlabel('Index')
figure
semilogy(s1,'ro','Linewidth',[2])

%%

%show origional image
figure
image = 2;
imshow(uint8(reshape(data(:,image),192,168)))
title('Original image 2, subject 06, cropped.')

%show images with different number of singular values
l = 1;
figure
for j = l+1:l+6
    %reconstruct image using svd
    A = u(:,l+1:j)*s(l+1:j,l+1:j)*v(:,l+1:j)';
    subplot(2,3,j-l)
    imshow(uint8(reshape(A(:,image),192,168)))
    xlabel(sprintf('Sigma = %d', j))
end


