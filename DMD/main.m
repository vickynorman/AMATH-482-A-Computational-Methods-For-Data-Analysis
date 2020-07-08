v= VideoReader('woozo.MOV'); 
v2= VideoReader('vid2.MOV');
vid1 = read (v) ;
% vid1 = read (v2) ;
[n m h1 h2] = size(vid1);
frames = 80;

%%

X = [];

for i = 1:frames
    x = double(reshape(vid1(:,:,1,i),n*m,1));
    X= [X x];
end

%%

X1=X(:, 1:end-1); 
X2=X(:, 2:end);


%%

r = 20;
dt = 1;


%%
size(X)
[Phi,omega,lambda,b,Xdmd, S, time_dynamics] = DMD(X1,X2,r,dt);

%%

plot(diag(S)/sum(diag(S)), 'ro','Linewidth',[2]);
xlabel('Component')
ylabel('Singular value')

%%

X_lr = uint8(abs(Xdmd));

r = Xdmd-abs(Xdmd);

%%

X_s = uint8(X1 - abs(Xdmd) -r); 

%%

for i = 1:frames-1
    imshow((reshape(X_s(:,i),n, m))')
    drawnow
end
