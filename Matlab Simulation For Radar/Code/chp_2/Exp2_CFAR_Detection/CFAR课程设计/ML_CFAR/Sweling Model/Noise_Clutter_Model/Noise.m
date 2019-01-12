%% Noise Model
sigma = 0.1;% �����ı�׼��
% Generate 1000 Samples
Samples = 50000;
n_I = sigma * randn(1, Samples);
n_Q = sigma * randn(1, Samples);
% Square Law Detector
r_square = n_I.^2 + n_Q.^2;
r = sqrt(n_I.^2 + n_Q.^2);

%% Rayleigh Clutter
B = 0.1;% �����Ӳ�����Ĳ���
rayleigh_clutter_1 = raylrnd(B, [1, Samples]);
figure (1);
plot(rayleigh_clutter_1, 'k-', 'LineWidth', 1.0);
title('Rayleigh�Ӳ�');
%% Plot
figure (2);
subplot(2, 1, 1);
plot(n_I, 'k-', 'LineWidth', 1.0);
title('I·ͨ������');
subplot(2, 1 ,2);
plot(n_Q, 'k-', 'LineWidth', 1.0);
title('Q·ͨ������');

figure (3);
nbins = 100;
subplot(2, 1, 1);
y_1 = histogram(r, 'normalization', 'pdf');
title('����첨���Rayleigh�ֲ�');
subplot(2, 1, 2);
y_2 = histogram(r_square, 'normalization', 'pdf');
title('ƽ���ɼ첨���Exponential�ֲ�');