

disco = [dir('/Users/vick/Docs/AMATH482/hw3/genres/disco')];

Yc = [];


for i = 3:102
    [y, Fs] = audioread(disco(i).name);
    j = randi(20);
    start = 22050*j;
    fin = start + 22050*5;
    yclip = y(start:fin);
    z = spectrogram(yclip);
    ry = reshape(z,[],1);
    Yc = [Yc, ry];
end


%%

metal = [dir('/Users/vick/Docs/AMATH482/hw3/genres/metal')];

Y1c = [];

for i = 3:102
    [y, Fs] = audioread(metal(i).name);
    j = randi(20);
    start = 22050*j;
    fin = start + 22050*5;
    yclip = y(start:fin,1);
    z = spectrogram(yclip);
    ry = reshape(z,[],1);
    Y1c = [Y1c, ry];
end

%%

classical = [dir('/Users/vick/Docs/AMATH482/hw3/genres/classical')];


Y2c = [];

for i = 3:102
    [y, Fs] = audioread(classical(i).name);
    j = randi(20);
    start = 22050*j;
    fin = start + 22050*5;
    yclip = y(start:fin);
    z = spectrogram(yclip);
    ry = reshape(z,[],1);
    Y2c = [Y2c, ry];
    
end

%%


Xc = [Yc Y1c Y2c];

size(Xc)

[uc, sc, vc] = svd(Xc,'econ');



%%

plot(diag(sc)/sum(diag(sc)), 'ro', 'Linewidth', [2]);
xlabel('Component')
ylabel('Singular value')


%%

plot3(vc(1:99,1),vc(1:99,2),vc(1:99,3),'ro')
hold on
plot3(vc(100:199,1),vc(100:199,2),vc(100:199,3),'bo')
hold on
plot3(vc(200:299,1),vc(200:299,2),vc(200:299,3),'go')

%%

v1 = real(vc(1:99,1:3));
v2 = real(vc(100:199,1:3));
v3 = real(vc(200:299,1:3));

accuracy = [];

for i = 1:1000

q1 = randperm(99);
q2 = randperm(99);
q3 = randperm(99);

xtrain = [v1(q1(1:90),:); v2(q1(1:90),:); v3(q1(1:90),:)];
xtest = [v1(q1(91:end),:); v2(q2(91:end),:); v3(q3(91:end),:)];

labels = [ones(90,1); 2*ones(90,1); 3*ones(90,1)];
labels2 = [ones(9,1); 2*ones(9,1); 3*ones(9,1)];

kn = fitcnb(xtrain, labels);

pre = kn.predict(xtest);

score = 0;

for i = 1:length(pre)
    if labels2(i) == pre(i)
        score = score + 1;
    end
end

accuracy = [accuracy score/length(pre)];

end

mean(accuracy)