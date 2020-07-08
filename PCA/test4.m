clear all; close all;
% load videos
load cam1_4.mat vidFrames1_4
load cam2_4.mat vidFrames2_4
load cam3_4.mat vidFrames3_4


%%

num_frames = 226;
test = 4;
% initialising matrices
lightx = zeros(num_frames,1);
lighty = zeros(num_frames,1);

X = zeros(num_frames, 6);

for n = 1:3

cam = eval(sprintf('vidFrames%d_%d',n,test));
size(cam);

% truncating videos
if n == 1
    thresh = 240;
    ytrunk = 200:480;
    xtrunk = 180:450;
end
if n == 2
    thresh = 245;
    cam = cam(:,:,:,8:end);
    ytrunk = 70:400;
    xtrunk = 180:450;
    
end
if n == 3
    thresh = 230;
    cam = permute(cam,[2 1 3 4]);
    ytrunk = 250:460;
    xtrunk = 100:350;
end


for i = 1:num_frames
    [y x] = find(cam(ytrunk, xtrunk,2,i)>thresh);
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


%%

% average using filered peak average
coeff = ones(1,10)/10;
ave = filter(coeff, 1, X);
plot( 1-5:num_frames-5,[ave(:,2) ave(:,4) ave(:,6)])
axis([0 inf -inf inf])
legend('cam 1','cam 2','cam 3')
xlabel('Frame number')
ylabel('Displacement in z direction (averaged)')

figure
plot( 1-5:num_frames-5,[ave(:,1) ave(:,3) ave(:,5)])
axis([0 inf -inf inf])
legend('cam 1','cam 2','cam 3')
xlabel('Frame number')
ylabel('Displacement in x direction (averaged)')



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

% calculate second component
figure
Y2 = S(2,2)*V(:,2);
plot(Y2)
xlabel('Frame number')
ylabel('Displacement in x direction')

% calculate third component
figure
Y3 = S(3,3)*V(:,3);
plot(Y3)
xlabel('Frame number')
ylabel('Displacement in y direction')
    