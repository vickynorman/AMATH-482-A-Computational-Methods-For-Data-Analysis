

bruno = [dir('/Users/vick/Docs/AMATH482/hw3/Bruno Mars')];

Yb = [];


for i = 3:12
    [y, Fs] = audioread(bruno(i).name);
    for j = 1:30
        start = 44100*j;
        fin = start + 44100*5;
        yclip = y(start:fin,1);
        z = spectrogram(yclip);
        ry = reshape(z,[],1);
        Yb = [Yb, ry];
    end
end


%%

ellie = [dir('/Users/vick/Docs/AMATH482/hw3/ellie golding')];

Y1b = [];

for i = 3:12
    [y, Fs] = audioread(ellie(i).name);
    for j = 1:30
        start = 44100*j;
        fin = start + 44100*5;
        yclip = y(start:fin,1);
        z = spectrogram(yclip);
        ry = reshape(z,[],1);
        Y1b = [Y1b, ry];
    end
end

%%

foster = [dir('/Users/vick/Docs/AMATH482/hw3/Foster the People')];

Y2b = [];

for i = 3:12
    [y, Fs] = audioread(foster(i).name);
    for j = 1:30
        start = 44100*j;
        fin = start + 44100*5;
        yclip = y(start:fin,1);
        z = spectrogram(yclip);
        ry = reshape(z,[],1);
        Y2b = [Y2b, ry];
    end
    
end

%%

% [u,s,v] = svd(Y,'econ');
% [u1,s1,v1] = svd(Y1,'econ');
% [u2,s2,v2] = svd(Y2,'econ');
% plot(diag(s),'ro','Linewidth',[2]);
% hold on
% plot(diag(s1),'ko','Linewidth',[2]);
% hold on
% plot(diag(s2),'go','Linewidth',[2]);
% hold on

Xb = [Yb Y1b Y2b];

[u, s, vb] = svd(Xb,'econ');

size(vb)

% plot(real(v(1:10,:)),'ro','Linewidth',[2])
% hold on
% plot(real(v(11:20,:)),'go','Linewidth',[2])
% hold on
% plot(real(v(21:30,:)),'bo','Linewidth',[2])
% plot(diag(sx), 'ro', 'Linewidth', [2]);

%%

figure

vd = real(vb);

for i = 1:6
    for j = 1:6
        subplot(6,6,6*(i-1)+j)
        r = 6*(i-1)+j;
        for k = 1:300
            scatter(vb(k,i), vb(k,j), 'r', 'filled');
            xlabel(j)
            ylabel(i)
            hold on
        end
        for k = 301:600
            scatter(vb(k,i), vb(k,j), 'g', 'filled');
            xlabel(j)
            ylabel(i)
            hold on
        end
        for k = 601:900
            scatter(vb(k,i), vb(k,j), 'b', 'filled');
            xlabel(j)
            ylabel(i)
            hold on
        end
    end
end

%%

plot(diag(s)/sum(diag(sc)), 'ro', 'Linewidth', [2]);
xlabel('Component')
ylabel('Singular value')

%%

plot3(v(1:300,1),v(1:300,2),v(1:300,3),'ro')
hold on
plot3(v(301:600,1),v(301:600,2),v(301:600,3),'bo')
hold on
plot3(v(601:900,1),v(601:900,2),v(601:900,3),'go')

%%

v1 = real(v(1:300,1:3));
v2 = real(v(301:600,1:3));
v3 = real(v(601:900,1:3));

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