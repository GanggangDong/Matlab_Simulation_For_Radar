%% Transmitted Signal
f = 10;% Hz
Fs = 1000;% ����������Ϊ20Hz
t = 0:1/Fs:0.1;% ʱ��������
transmitted_signal = sin(2*pi*f*t);
%% Received Signal
% ��ʱ�źŸ��ݲ������ڵ����ã��޶�Ϊ��������������
delay = 2.5*1/Fs;% �ӳ������������� �����յ��ź�
t1 = 0:1/Fs:(0.1+ceil(delay*Fs)*1/Fs);
padding_zero = ceil(delay/(1/Fs));
received_signal = [zeros(1, padding_zero), transmitted_signal];

% Add Guass Noise
sigma = 0.1;% ����guass noise�ı�׼��
guass_noise = randn(1, length(received_signal)) * 0.1;
noised_received_signal = received_signal + guass_noise;
%% Plot
figure (1);
plot(t, transmitted_signal, 'r-', 'LineWidth', 1.0);
grid on;
hold on;
plot(t1, received_signal, 'b-.', 'LineWidth', 1.0);
grid on;
hold on;
plot(t1, noised_received_signal, 'g--', 'LineWidth', 1.0);
xlabel('t/Ts');
ylabel('����ֵ');
title('Transmitted Signal and Received Signal Compare');
legend('Transmitted Signal', 'Received Signal', 'Noised Received Signal');
%% Matched Filter

% ʱ������
% Conv������� ʵ�źŲ���Ҫ������
% ��Noised Received Signal�� Transmitted Signal�����
H = fliplr(received_signal);
% ��ʱ ��0
t0 = 0;
padding_zero_1 = ceil(t0/(1/Fs));
H_padding = [zeros(1, padding_zero_1),H];
conv_output = conv(noised_received_signal, H_padding);
t2 = (0:1/Fs:(length(conv_output)-1)*1/Fs) - t1(end);% ʱ����任
figure (2);
plot(t2, conv_output, 'k-', 'LineWidth', 1.0);
xlabel('t/s');
ylabel('The Matched Filter Response');
title('Convolution Method');
grid on;
% Auto_Correlation����
% �������
t0 = 0;
depadding_zero = ceil(t0/(1/Fs));
H_depadding = received_signal(depadding_zero+1:end);
corr_output = xcorr(H_depadding, noised_received_signal);
t3 = (0:1/Fs:(length(corr_output)-1)*1/Fs) - t1(end);
figure (3);
plot(t3, corr_output, 'b-', 'Linewidth', 1.0);
xlabel('t/s');
ylabel('The Matched Filter Response');
title('Correlation Method');
grid on;

% Ƶ������
% ����ʱ���еľ������ ����ת����Ƶ�� ʹ�ÿ��ٸ���Ҷ�任���������㸴�Ӷ�
nfft_points_1 = 2^nextpow2(length(noised_received_signal));
nfft_points_2 =2^nextpow2(length(received_signal));
spectrum_of_noised_signal = fftshift(fft(noised_received_signal, nfft_points_1));
spectrum_of_received_signal = fftshift(fft(received_signal, nfft_points_2));
figure (4);
subplot(2,1,1);
plot((0:1:(nfft_points_1-1))*Fs/nfft_points_1 - Fs/2, abs(spectrum_of_noised_signal), 'k-', 'LineWidth', 1.0);
xlabel('f/Hz');
title('Noised Received Signal Spectrum');
subplot(2,1,2);
plot((0:1:(nfft_points_2-1))*Fs/nfft_points_2 - Fs/2, abs(spectrum_of_received_signal), 'k-.', 'LineWidth', 1.0);
xlabel('f/Hz');
title('Received Signal');

% Ƶ����Ӧת����ʱ��
time_response = ifft(spectrum_of_noised_signal.*spectrum_of_received_signal, length(spectrum_of_noised_signal));
figure (5);
t4 = (0:1:(length(time_response)-1))*1/Fs - t1(end);
plot(t4, time_response);
xlabel('t/s');
title('Frequency Domain Method');
grid on;