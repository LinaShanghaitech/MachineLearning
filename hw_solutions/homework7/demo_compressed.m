
clear all;
close all;

% n is the original signal length (4096)
n = 2^12; 
% m is the number of observations to make (1024)
m = 2^10;
% number of spikes to put down (number of nonzero elements in orignail signal)
n_spikes = 160;

% random +/- 1 signal
f = zeros(n,1);
q = randperm(n);
f(q(1:n_spikes)) = sign(randn(n_spikes,1));

% measurement matrix
disp('Creating measurement matrix...');
R = randn(m,n);

% orthonormalize rows
R = orth(R')';

disp('Finished creating matrix');

% Now we have A and A transposed
A = @(x) R*x;
At = @(x) R'*x;

% noisy observations
sigma = 0.01;
y = A(f) + sigma*randn(m,1);


tau = 0.1*max(abs(R'*y)); % Regualization parameter
tol = 10^-6;
x0 = zeros(n,1);

[theta_ist,obj_ist,times_ist,mses_ist]= ...
	 IST(y,A,tau,...
	'AT',At,... 
    'True_x',f,...
    'Maxiter',1e5,...
	'Initialization',x0,...
	'Tolerance',tol);

% Plot objective vs time
figure (1)
hold on;
plot(times_ist,obj_ist,'LineWidth',1.8)
xlabel('CPU time (Seconds)')
ylabel('Objective function')
hold off

% Plot MSE vs time
figure (2)
hold on;
plot(times_ist,mses_ist,'LineWidth',1.8)
xlabel('CPU time (Seconds)')
ylabel('MSE')

% Plot signals
figure(3)
subplot(3,1,1)
plot(y)
bar(f(:),'r');
title('The original signal');
subplot(3,1,2)
plot(y(:),'r')
title('The observed signal');
subplot(3,1,3)
bar(theta_ist(:),'r');
title(sprintf('The signal recovered by IST, MSE=%g',mses_ist(end)))
