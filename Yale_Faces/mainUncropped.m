clear all; close all;
%load images
images = [dir(pwd+'/yalefaces/')];

%read images and store data in a matrix with one column per image
numfiles = length(images);
mydata = cell(1, numfiles);


for k = 4:numfiles
    mydata{k-3} = imread(sprintf(images(k).name));
    data(:,k-3) = reshape(double(mydata{k-3}),[],1);
end

%perform svd
[u,s,v] = svd(data, 'econ');


%plot singular values
s1 = diag(s);
figure
plot(s1,'ro','Linewidth',[2])
title('Values of Sigma from SVD, all subjects, uncropped.')
ylabel('Sigma value')
xlabel('Index')
%plot singular values logarithmic
figure
semilogy(s1,'ro','Linewidth',[2])
title('Values of Sigma from SVD on log scale, all subjects, uncropped.')
ylabel('Sigma value (log)')
xlabel('Index')

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
% for j = l:l+n-1
%     reconstruct image using svd
%     A = u(:,l:j)*s(l:j,l:j)*v(:,l:j)';
%     subplot(2,3,j-l+1)
%     imshow(uint8(reshape(A(:,image),243,320)))
%     xlabel(sprintf('Sigma = %d', j))
% end

%reconstruct image using svd
%show for specific values of sigma
A = u(:,1:6)*s(1:6,1:6)*v(:,1:6)';
subplot(1,2,1)
imshow(uint8(reshape(A(:,image),243,320)))
xlabel('Sigma = 6')
A = u(:,1:50)*s(1:50,1:50)*v(:,1:50)';
subplot(1,2,2)
imshow(uint8(reshape(A(:,image),243,320)))
xlabel('Sigma = 30')



