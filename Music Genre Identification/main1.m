

monkeys = [dir('/Users/vick/Docs/AMATH482/hw3/ArcticMonkeys')];

Y = [];

for i = 4:13
    [y, Fs] = audioread(monkeys(i).name);
    for j = 1:30
        start = 44100*j;
        fin = start + 44100*5;
        yclip = y(start:fin,1);
        z = spectrogram(yclip);
        ry = reshape(z,[],1);
        Y = [Y, ry];
    end
end


%%

eminem = [dir('/Users/vick/Docs/AMATH482/hw3/Eminem')];

Y1 = [];

for i = 4:13
    [y, Fs] = audioread(eminem(i).name);
    for j = 1:30
        start = 44100*j;
        fin = start + 44100*5;
        yclip = y(start:fin,1);
        z = spectrogram(yclip);
        ry = reshape(z,[],1);
        Y1 = [Y1, ry];
    end
end

%%

SClub = [dir('/Users/vick/Docs/AMATH482/hw3/SClub7')];

Y2 = [];

for i = 3:12
    [y, Fs] = audioread(SClub(i).name);
    for j = 1:30
        start = 44100*j;
        fin = start + 44100*5;
        yclip = y(start:fin,1);
        z = spectrogram(yclip);
        ry = reshape(z,[],1);
        Y2 = [Y2, ry];
    end
    
end

%%

X = [Y Y1 Y2];

[u, s, v] = svd(X,'econ');

%%

plot(diag(s)/sum(diag(sc)), 'ro', 'Linewidth', [2]);
xlabel('Component')
ylabel('Singular value')

%%

plot3(v(1:300,4),v(1:300,5),v(1:300,6),'ro')
hold on
plot3(v(301:600,4),v(301:600,5),v(301:600,6),'bo')
hold on
plot3(v(601:900,4),v(601:900,5),v(601:900,6),'go')

%%

plot(v(1:300,3),v(1:300,2),'ro')
hold on
plot(v(301:600,3),v(301:600,2),'bo')
hold on
plot(v(601:900,3),v(601:900,2),'go')


%%

v1 = real(v(1:300,1:6));
v2 = real(v(301:600,1:6));
v3 = real(v(601:900,1:6));

accuracy = [];

for i = 1:1000

q1 = randperm(300);
q2 = randperm(300);
q3 = randperm(300);

xtrain = [v1(q1(1:290),:); v2(q1(1:290),:); v3(q1(1:290),:)];
xtest = [v1(q1(291:end),:); v2(q2(291:end),:); v3(q3(291:end),:)];

labels = [ones(290,1); 2*ones(290,1); 3*ones(290,1)];
labels2 = [ones(10,1); 2*ones(10,1); 3*ones(10,1)];

kn = fitcknn(xtrain, labels, 'NumNeighbors', [3]);

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






