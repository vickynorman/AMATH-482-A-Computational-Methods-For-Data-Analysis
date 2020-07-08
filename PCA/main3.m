clear all; close all;
% load videos
load cam1_3.mat vidFrames1_3
load cam2_3.mat vidFrames2_3
load cam3_3.mat vidFrames3_3


%%

num_frames = 226;
test = 3;
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
    cam = cam(:,:,:,10:end);
    ytrunk = 200:480;
    xtrunk = 180:450;
end
if n == 2
    thresh = 254;
    cam = cam(:,:,:,:);
    ytrunk = 70:400;
    xtrunk = 180:450;
    
end
if n == 3
    thresh = 245;
    cam = permute(cam,[2 1 3 4]);
    cam = cam(:,:,:,5:end);
    ytrunk = 250:460;
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


%%

% average using filered peak average
coeff = ones(1,10)/10;
fDelay = (length(coeff)-1)/2;
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
covY = 1/(num_frames-1)*S.^2

% plot covariance values
figure
plot(diag(covY),'ro', 'Linewidth', [2])
ylabel('Variance')
xlabel('Component')


% calculate first component
Y1 = S(1,1)*V(:,1);
figure;
plot(Y1)
xlabel('Frame number')
ylabel('Displacement in z direction')

figure;
% calculate second component
Y2 = S(2,2)*V(:,2);
plot(Y2)
xlabel('Frame number')
ylabel('Displacement in x direction')
    