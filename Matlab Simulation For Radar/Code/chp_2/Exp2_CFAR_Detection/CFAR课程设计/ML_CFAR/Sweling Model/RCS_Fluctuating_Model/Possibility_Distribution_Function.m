%% Swerling I/II Model
u = 2;
samples = 50000;
% ����5000��������
r = exprnd(u, [1,samples]);
bins = 30;
% standard exp_distribution
x = 0:0.5:40;
r_standard = exppdf(x, u);
figure (1);
pdf_hist = histogram(r, bins, 'BinWidth', 0.5, 'normalization', 'pdf');
title('Sweling I/II ģ�͵Ľ���pdf');
hold on;
plot(x, r_standard, 'r-', 'LineWidth', 1.0);
title('Swerling I/II ģ�͵�pdf');
grid on;

%% Swerling III/IV�� Model
u = 2;
sigma = 0:0.05:20;
pdf = 4 * sigma./(u^2)  .* exp(- 2*sigma/u);
figure (2);
plot(sigma, pdf);
grid on;
title('Swerling III/IV ģ�͵�pdf');