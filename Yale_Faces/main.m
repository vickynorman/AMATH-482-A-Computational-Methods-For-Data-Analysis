clear all; close all;

images = [dir('./yaleB15')];


numfiles = length(images)
mydata = cell(1, numfiles);


for k = 3:numfiles
    mydata{k-2} = imread(sprintf(images(k).name));
    data(:,k-2) = reshape(double(mydata{k-2}),[],1);
end
% for k = 3:numfiles
%     data(:,k-2) = reshape(double(imread(image(k))),[],1);
% end


[u,s,v] = svd(data, 'econ');

s1 = diag(s);
%figure
%plot(s1,'ro','Linewidth',[2])
%figure
%semilogy(s1,'ro','Linewidth',[2])

%%

% for i = 1:6
%     A = u(:,i)*s1(i)*v(:,i)';
% end

%A = u(:,1:6)*s(1:6,1:6)*v(:,1:6)';

figure

image = 7;

imshow(uint8(reshape(data(:,image),192,168)))

l = 1;
figure
for j = l+1:l+6
    A = u(:,l:j)*s(l:j,l:j)*v(:,l:j)';
    subplot(2,3,j-l)
    imshow(uint8(reshape(A(:,image),192,168)))
end


