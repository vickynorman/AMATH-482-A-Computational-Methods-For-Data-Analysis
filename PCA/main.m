clear all; close all;
% load videos
load cam1_1.mat vidFrames1_1
load cam2_1.mat vidFrames2_1
load cam3_1.mat vidFrames3_1

%%
num_frames = 226;
test = 1;
% initialising matrices
lightx = zeros(num_frames,1);
lighty = zeros(num_frames,1);

X = zeros(num_frames, 6);

for n = 1:3

cam = eval(sprintf('vidFrames%d_%d',n,test));
size(cam);

% truncating videos
if n == 1
    thresh = 250;
    ytrunk = 200:480;
    xtrunk = 180:450;
end
if n == 2
    thresh = 250;
    cam = cam(:,:,:,10:end);
    ytrunk = 100:400;
    xtrunk = 180:450;
    
end
if n == 3
    thresh = 230;
    cam = permute(cam,[2 1 3 4]);
    ytrunk = 210:460;
    xtrunk = 180:450;
end


for i = 1:num_frames
    [y x] = find(cam(ytrunk,xtrunk,2,i)>thresh);
    lightx(i) = median(x);
    lighty(i) = median(y);
    
%     imshow(cam(ytrunk,xtrunk,2,i)>thresh);
%     drawnow
    
end

% remove mean value of x and y to center around 0
lightx = lightx-mean(lightx);
lighty = lighty-mean(lighty);

X(:,2*n-1) = lightx;
X(:,2*n) = lighty;


end
figure

%plot z position
plot(1:num_frames, X(:,2), 1:num_frames, X(:,4), 1:num_frames, X(:,6))
legend('cam 1','cam 2','cam 3')
xlabel('Frame number')
ylabel('Displacement in z direction')

%plot x position
figure
plot(1:num_frames, X(:,1), 1:num_frames, X(:,3), 1:num_frames, X(:,5))
legend('cam 1','cam 2','cam 3')
xlabel('Frame number')
ylabel('Displacement in x direction')

%%

% svd on X
[U, S, V] = svd(X','econ');

covX = cov(X);
size(covX);

% calculte the covarance of PCA basis
covY = 1/(num_frames-1)*S.^2;

% plot covariance values
figure
plot(diag(covY),'ro', 'Linewidth', [2])
ylabel('Variance')
xlabel('Component')

% calculate first component
Y1 = S(1,1)*V(:,1);
figure
plot(Y1)
xlabel('Frame number')
ylabel('Displacement in z direction')

figure
% calculate second component
Y2 = S(2,2)*V(:,2);
plot(Y2)
xlabel('Frame number')
ylabel('Displacement in x direction')
    