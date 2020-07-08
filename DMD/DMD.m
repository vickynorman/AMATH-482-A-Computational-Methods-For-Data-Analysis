function [Phi,omega,lambda,b,Xdmd, S, time_dynamics] = DMD(X1,X2,r,dt, time_dynamics)
% function [Phi,omega,lambda,b,Xdmd] = DMD(X1,X2,r,dt) 
% Computes the Dynamic Mode Decomposition of X1, X2
%
% INPUTS:
% X1 = X, data matrix
% X2 = X?, shifted data matrix
% Columns of X1 and X2 are state snapshots
% r = target rank of SVD
% dt = time step advancing X1 to X2 (X to X?)
%
% OUTPUTS:
% Phi, the DMD modes
% omega, the continuous-time DMD eigenvalues
% lambda, the discrete-time DMD eigenvalues
% b, a vector of magnitudes of modes Phi
% Xdmd, the data matrix reconstrcted by Phi, omega, b
%% DMD
[U, S, V] = svd(X1, 'econ'); 
r = min(r, size(U,2));
Ur = U(:, 1:r); % truncate to rank-r
Sr = S(1:r, 1:r);
Vr = V(:, 1:r);
Atilde = Ur' * X2 * Vr / Sr; % low-rank dynamics 
[Wr, D] = eig(Atilde);
Phi = X2 * Vr / Sr * Wr; % DMD modes 
lambda = diag(D); % discrete-time eigenvalues
omega = log(lambda)/dt; % continuous-time eigenvalues
%% Compute DMD mode amplitudes
x1 = X1(:, 1);
b = Phi\x1;
%% DMD reconstruction
mm1 = size(X1, 2); % mm1 = m - 1 
time_dynamics = zeros(r, mm1);
t = (0:mm1-1)*dt; % time vector 
for iter = 1:mm1
    time_dynamics(:,iter) = (b.*exp(omega*t(iter))); 
end
Xdmd = Phi * time_dynamics;


end
  