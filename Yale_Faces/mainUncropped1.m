clear all; close all;
%load images
images = [dir('/Users/vick/Documents/AMATH482/hw1/yalefaces_uncropped/yalefaces/subject01.*')];

%read images and store data in a matrix with one column per image
numfiles = length(images)
mydata = cell(1, numfiles);

for k = 1:numfiles
    mydata{k} = imread(sprintf(images(k).name));
    data(:,k) = reshape(double(mydata{k}),[],1);
end

%perform svd
[u,s,v] = svd(data, 'econ');

%plot singular values
s1 = diag(s);
figure
plot(s1,'ro','Linewidth',[2])
title('Values of Sigma from SVD, subject 01, uncropped.')
ylabel('Sigma value')
xlabel('Index')
figure
semilogy(s1,'ro','Linewidth',[2])

%%
%show origional image
figure
image = 2;
imshow(uint8(reshape(data(:,image),243,320)))
title('Original image 2, subject 01, uncropped.')

%show images with different number of singular values
l = 1;
n = 6;
figure
for j = l:l+n-1
    %reconstruct image using svd
    A = u(:,l:j)*s(l:j,l:j)*v(:,l:j)';
    subplot(2,3,j-l+1)
    imshow(uint8(reshape(A(:,image),243,320)))
    xlabel(sprintf('Sigma = %d', j))
end


