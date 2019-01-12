%% Params Setting
% ����PR�״����� ʹ�����Ե�Ƶ�źŽ��е���
B = 2e6;% ��������Ϊ2MHz
PRI = 1e-3;% �����ظ��������ó�2ms
taur = 2e-4;% ����������Ϊ0.2ms
Fs = 2*B;% ϵͳ�Ĳ���������Ϊ2������
c = 3e8;% ��Ų��������ٶ�
% Ĭ�������շ�����
% �ڷ��������ʱ���޷����ջز��ź�

% Paras Computing
% ��������Ӧ��taur�������£����������ܷ�����Զ����̽�������
% ����̽��ķ�ΧΪ��30km->150km����Ӧ�ڷ�������������Ⱥ������ظ����ֵ��
% ����ֱ���Ϊ��75m(delta_R = c/2B)
%% Notes
% Ϊ�˷���ʵ�飬��������Ƶ����Ƶ����Ϊ0Ƶ��
% �������Ӳ�������ֻ�ڸ�˹�����������½���ʵ��

%  Notes
% �������Ե�Ƶ�����ź�
% j = sqrt(-1);
% u = B/taur; % ���Ե�Ƶ�źŵĵ���ϵ��
% t = 0:1/Fs:taur;
% transmitted_signal = exp(j*2*pi*u*t.^2);

% Ŀ������
% R = 100e3;% ��ֹĿ��λ�ھ������100km��

% �����ź�

% delay = 2*R/c;
% sigma = 0.1;% �����ı�׼��
% alpha = 0.5;% �ز�����˥��
% �Է�������Ե�Ƶ�źŲ�������ѹ���������ȱ�Ϊ��1/B = 5e-7
% ������Ϊ Fs = 2*B������ʱ��Ϊ2.5e-7
% �������뵥Ԫ ����Ӧ�Ļز����壨������ѹ���� һ��ֻ��һ��������
% Ϊ�˱���ʵ�飬���²�������ѹ����ʵ����̽��з���

delta_R = c/(2*B);
% �۲�Ļز��ľ��뵥Ԫ
range_bins = 1:1:(1/2*c*PRI - 1/2*c*taur)/(delta_R);
% ��·���� guass_noise
sigma = 0.5;% ���õ�·�����ı�׼��
% �������ʵ�����������
noise_channel_i = sigma * randn(1, length(range_bins));
noise_channel_q = sigma * randn(1, length(range_bins));
% ��ƽ���ɼ첨��->ָ���ֲ�/�����ֲ�
V = noise_channel_i.^2 + noise_channel_q.^2;
% ��ƽ���ɼ첨���� ��������Ϊ��·��˹�����Ĺ��ʵĺ�

% �趨Ŀ��
index = 200;% Ŀ��λ�ڵ�200�����뵥Ԫ��
SNR_dB = 30;% ���������Ϊ30dB
SNR_numeric = 10^(SNR_dB/10);% ����ȵ���ֵ��ʽ
% Ŀ��Ļز����ʣ�����ƽ���ɼ첨����
target_echo = SNR_numeric * 2 * sigma^2;

echo_ = V;echo_(index) = target_echo;

%%% Single Target with Square Law Detection
% Normal Conditions�������Ӳ�(����)������Unifrom Clutter Background��
%% Threshold Compare
% ����ھ��뵥Ԫ���з���
N = 20;% ��������ѡ��Ϊ20�����뵥Ԫ��ǰ��ѡ��10����

% ���������Ĺ��ʣ������ֵ��֪Ϊ0��ֻ��Ҫ�������ķ�����й��ƣ�
% ʵ����Ӧ������guard cells����ֹĿ�������й¶��
% ����ʱֻ����Ŀ��ȫ������һ�����뵥Ԫ�����
% �������ʵ���ƫ����(��ƽ�� ƽ���ŵ����������)
noise_power_estimation = zeros(1, length((N/2+1):1:(length(range_bins)-N/2)));
for i = (N/2+1):1:(length(range_bins)-N/2)
    noise_power_estimation(i-N/2) = sum([echo_(i-N/2:i-1),echo_(i+1:i+N/2)]);
end
% �龯������
% �龯���ʲ���������������
Pfa = 1e-6;
T = Pfa^(-1/N) - 1;% ��һ���ı������

% ���ӻ�
figure (1);
plot(range_bins, 10*log10(echo_), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T*noise_power_estimation), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins, repelem(10*log10(N * T * 2 * sigma^2), length(range_bins)),...
    'r--', 'LineWidth', 1.0);
hold off;
xlabel('���뵥Ԫ/index');
ylabel('�ز�����/dB');
title('CA-CFAR��Ԫƽ�����龯');
legend('Echo', 'Estimate Threshold', 'Ideal Threshold');

%% ���龯�ʣ������ʺ�����ȵĹ�ϵ(����Ŀ��)
% ������Ԫȷ��
N_test =20;
Pfa_test = [1e-3, 1e-5, 1e-7];
SNR_dB_test = linspace(10, 30, 400);
SNR_numeric_test = 10.^(SNR_dB_test/10);
T = Pfa_test.^(-1/N_test) - 1;% ��һ���ı������
Label = cell(1, length(Pfa_test));
Color = {'r-', 'g-', 'b-'};
Pd = zeros(length(SNR_dB_test), length(Pfa_test));
figure (2);
for i = 1:length(Pfa_test)
    Pd(:, i) = (1 + T(i)./(1 + SNR_numeric_test)).^-N_test;
    plot(SNR_dB_test, Pd(:, i), char(string(Color(i))), 'LineWidth', 1.0);
    hold on;
    Label{i} = strcat('Pfa = ', num2str(Pfa_test(i)));
end
hold off;
grid on;
legend(Label);
xlabel('SNR/dB');
ylabel('Probability of Detection');
title('CA-CFAR Pd����SNR����');
%% ��Ŀ���� ������ԪN �Լ����ʵ�Ӱ��
N_1 = 4:2:70;% ������Ԫ N�������Ϊż��
SNR_dB_1 = 30;% �������Ϊ30dB�������½��в���
SNR_numeric_1 = 10^(SNR_dB_1/10);
Label_1 = cell(1, length(Pfa_test));
Color = {'r-', 'g-', 'b-'};
Pd = zeros(length(N_1), length(Pfa_test));
figure (3);
for i = 1:length(Pfa_test)
    T = Pfa_test(i).^(-1./N_1) - 1;% ��һ���ı������
    Pd(:, i) = (1 + T./(1 + SNR_numeric_1)).^-N_1;
    plot(N_1, Pd(:, i), char(string(Color(i))), 'LineWidth', 1.0);
    hold on;
    Label_1{i} = strcat('Pfa = ', num2str(Pfa_test(i)));
end
hold off;
legend(Label_1);
xlim([0, 70]);
ylim([0.6, 1]);
grid on;
xlabel('�����Ĵ�����/��');
ylabel('Probability of Detection');
title('CA-CFAR Pd����������Ԫ����');
%% CA-CFAR Loss
% ���ڶ��������ʹ��Ʋ�׼����������ʧ����Ҫ���������ȣ�
Pd_2 = 0.9;
Pfa_2 = [1e-3, 1e-6];
N_2 = 4:2:70;% ������Ԫ�ı仯
Label_2 = cell(1, length(Pfa_2));
Color_1 = {'r-', 'b-'};
figure (4);
subplot(2,1,1);
for j = 1:length(Pfa_2)
    % ���ں��龯�����������ʧ
    cfar_snr = ((Pd_2/Pfa_2(j)).^(1./N_2)-1)./(1 - Pd_2.^(1./N_2));
    actual_snr = log(Pfa_2(j)/Pd_2)/log(Pd_2);
    cfar_loss = 10*log10(cfar_snr./actual_snr);
    plot(N_1, cfar_loss, char(string(Color_1(j))), 'LineWidth', 1.0);
    hold on;
    Label_2{j} = strcat('Pd = ', num2str(Pd_2), 'Pfa = ', ...
        num2str(Pfa_2(j)));
end
hold off;
xlabel('������Ԫ�ĸ���/��');
ylabel('CFAR loss/dB');
title('CFAR Loss����������Ԫ');
legend(Label_2);
grid on;

subplot(2,1,2);
Pd_3 = [0.9, 0.95];
Pfa_3 = 1e-6;
N_3 = 4:2:70;% ������Ԫ�ı仯
Color_2 = {'r-', 'b-'};
Label_3 = cell(1, length(Pd_3));
for j = 1:length(Pd_3)
    % ���ں��龯�����������ʧ
    cfar_snr = ((Pd_3(j)/Pfa_3).^(1./N_3)-1)./(1 - Pd_3(j).^(1./N_3));
    actual_snr = log(Pfa_3/Pd_3(j))/log(Pd_3(j));
    cfar_loss = 10*log10(cfar_snr./actual_snr);
    if j == 2
        % ���������غ�
        plot(N_1 + 0.5, cfar_loss, char(string(Color_2(j))), 'LineWidth', 1.0);
    else
        plot(N_1, cfar_loss, char(string(Color_2(j))), 'LineWidth', 1.0);
    end
    hold on;
    Label_3{j} = strcat('Pd = ', num2str(Pd_3(j)), 'Pfa = ', ...
        num2str(Pfa_3));
end
hold off;
xlabel('������Ԫ�ĸ���/��');
ylabel('CFAR loss/dB');
title('CFAR Loss����������Ԫ');
legend(Label_3);
grid on;

%%% ��ҪĿ��� Reference Cells�а�����Ŀ��
% ���Ŀ��ߴ���󣨶��ɢ�������������뵥Ԫ�����ܻ�������Ƶ����ڱ�����
%% �ο���Ԫ����ǿ��Ŀ�������
% ���ײ���©�� ���� SO-CFAR�������иĽ�
index_2 = 200;% Ŀ��1λ�ڵ�200�����뵥Ԫ��
index_3 = 195;% Ŀ��2λ�ڵ�195�����뵥Ԫ��
SNR_dB_2 = 30;% Ŀ��1���������
SNR_dB_3 = 20;% Ŀ��2���������
SNR_numeric_2 = 10^(SNR_dB_2/10);% Ŀ��1������ȵ���ֵ��ʽ
SNR_numeric_3 = 10^(SNR_dB_3/10);% Ŀ��2������ȵ���ֵ��ʽ
% Ŀ��Ļز����ʣ�����ƽ���ɼ첨����
target_1_echo = SNR_numeric_2 * 2 * sigma^2;
target_2_echo = SNR_numeric_3 * 2 * sigma^2;
echo_1 = V;echo_1(index_2) = target_1_echo;echo_1(index_3) = target_2_echo;
N = 20;% �ο���Ԫ��Ȼѡ��Ϊ20�����뵥Ԫ�ĳ���

noise_power_estimation_1 = zeros(1, length((N/2+1):1:(length(range_bins)-N/2)));
for i = (N/2+1):1:(length(range_bins)-N/2)
    noise_power_estimation_1(i-N/2) = sum([echo_1(i-N/2:i-1),echo_1(i+1:i+N/2)]);
end

% �龯���ʲ���������������
Pfa = 1e-6;
T_1 = Pfa^(-1/N) - 1;% ��һ���ı������

% ���ӻ�
figure (5);
plot(range_bins, 10*log10(echo_1), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T_1*noise_power_estimation_1), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins, repelem(10*log10(N * T_1 * 2 * sigma^2), length(range_bins)),...
    'k--', 'LineWidth', 0.5);
hold off;
xlabel('���뵥Ԫ/index');
ylabel('�ز�����/dB');
title('CA-CFAR��Ԫƽ�����龯');
legend('Echo', 'Estimate Threshold', 'Ideal Threshold');
% ��߲ο���Ԫ�ĸ�������ͬ���龯�������ܹ���С���ں��龯��������ʧ
% ��Ŀ�����ܹ�ʹ�ü���������
% �ڶ�Ŀ��/ǿ����Ž���ο���Ԫ�������£�����/�Ӳ��������޵ĸ���Ҳ�����ˣ���Ŀ��ļ��������½���

%% �Ǿ����Ӳ�����
% ������Ȼ���� �Ӳ���Ȼ�����˹�ֲ�
% ͨ���������ʵ�ͻ����ģ���Ӳ��ı仯���Ǿ����ԣ�
sigma_1 = 0.5;% ���õ�·�����ı�׼��
sigma_2 = 1;
% �������ʵ�����������
noise_channel_i_1 = [sigma_1 * randn(1, floor(length(range_bins)/2)),...
                   sigma_2 * randn(1, ceil(length(range_bins)/2))];
noise_channel_q_1 = [sigma_1 * randn(1, floor(length(range_bins)/2)),...
                    sigma_2 * randn(1, ceil(length(range_bins)/2))];
% ��ƽ���ɼ첨��->ָ���ֲ�/�����ֲ�
V_1 = noise_channel_i_1.^2 + noise_channel_q_1.^2;

% Ŀ������
index_4 = 200;
SNR_dB_4 = 30;
% �Ӳ���Ե�ĵ��Ӳ������СĿ����ܳ���©��
index_5 = floor(length(range_bins)/2)-10;
SNR_dB_5 = 15;
% ����Ŀ�������ø���/��Ŀ�꣬�۲�Ӱ��
index_6 = 195;
SNR_dB_6 = 20;
% �Ӳ�����ĸ��Ӳ�������ܳ����龯
echo_2 = V_1;echo_2(index_4) = 2 * sigma_1^2 * 10^(SNR_dB_4/10);
echo_2(index_5) = 2 * sigma_1^2 * 10^(SNR_dB_5/10);
echo_2(index_6) = 2 * sigma_1^2 * 10^(SNR_dB_6/10);
% �ٶ���Ȼ���ɾ��ȣ���˹���Ӳ������µļ��
N = 20;
Pfa = 1e-6;
T_2 = Pfa^(-1/N) - 1;% ��һ���ı������

% GO_CFAR �����������
% �ɸ����龯������ƻ����ӵ�ֵ
% ��ΪGO_CFAR������SO_CFAR����ֻʹ���˰뻬���ڳ��ȵĹ��ʣ��������Ĵ��ڳ�������Ϊ֮ǰ��������
N_4 = 40;
Pfa_Go_given = 1e-6;
T_calculate_Go = fzero(@(T)Pfa_GO(T, 20) - Pfa_Go_given, 0.5);% ���õ�����ֵΪ0.5

% SO_CFAR �����������
Pfa_So_given = 1e-6;
T_calculate_So = fzero(@(T)Pfa_SO(T, 20) - Pfa_So_given, 0.5);% ���õ�����ֵΪ0.5

% CA_CFAR ������������
noise_power_estimation_2 = zeros(1, length((N/2+1):1:(length(range_bins)-N/2)));
for i = (N/2+1):1:(length(range_bins)-N/2)
    noise_power_estimation_2(i-N/2) = sum([echo_2(i-N/2:i-1),echo_2(i+1:i+N/2)]);
end

% GO_CFAR  SO_CFAR������������
noise_power_estimation_3 = zeros(1, length((N_4/2+1):1:(length(range_bins)-N_4/2)));
noise_power_estimation_4 = zeros(1, length((N_4/2+1):1:(length(range_bins)-N_4/2)));
for i = (N_4/2+1):1:(length(range_bins)-N_4/2)
    noise_power_estimation_3(i-N_4/2) = max([sum(echo_2(i-N_4/2:i-1)),...
        sum(echo_2(i+1:i+N_4/2))]);
    noise_power_estimation_4(i-N_4/2) = min([sum(echo_2(i-N_4/2:i-1)),...
        sum(echo_2(i+1:i+N_4/2))]);
end

% ���ӻ�
figure (6);
plot(range_bins, 10*log10(echo_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T_2*noise_power_estimation_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N_4/2+1):1:(length(range_bins)-N_4/2)), ...
    10*log10(T_calculate_Go*noise_power_estimation_3), 'r-', ...
             'LineWidth', 1.0);
hold on;
plot(range_bins, [repelem(10*log10(N * T_2 * 2 * sigma_1^2),... 
                        floor(length(range_bins)/2)),...
                  repelem(10*log10(N * T_2 * 2 * sigma_2^2),... 
                        ceil(length(range_bins)/2))], 'k--',...
                        'LineWidth', 0.5);
hold on;
xlabel('���뵥Ԫ/index');
ylabel('�ز�����/dB');
title('CA-CFAR��Ԫƽ�����龯');
legend('Echo', 'CA-CFAR Estimate Threshold', 'GO-CFAR Estimate Threshold',...
       'Ideal Threshold');
   
figure (7);
plot(range_bins, 10*log10(echo_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N/2+1):1:(length(range_bins)-N/2)), ...
    10*log10(T_2*noise_power_estimation_2), 'k-', 'LineWidth', 1.0);
hold on;
plot(range_bins((N_4/2+1):1:(length(range_bins)-N_4/2)), ...
    10*log10(T_calculate_So*noise_power_estimation_4), 'b-', ...
             'LineWidth', 1.0);
hold on;
plot(range_bins, [repelem(10*log10(N * T_2 * 2 * sigma_1^2),... 
                        floor(length(range_bins)/2)),...
                  repelem(10*log10(N * T_2 * 2 * sigma_2^2),... 
                        ceil(length(range_bins)/2))], 'k--',...
                        'LineWidth', 0.5);
hold on;
xlabel('���뵥Ԫ/index');
ylabel('�ز�����/dB');
title('CA-CFAR��Ԫƽ�����龯');
legend('Echo', 'CA-CFAR Estimate Threshold', 'SO-CFAR Estimate Threshold',...
       'Ideal Threshold');


%% GO_CFAR�㷨
% �����龯��Pfa_go��������ֵ����ֵ��
N = 10;% �������ڵĳ�������Ϊ20
T_Go_Plot = 0:0.01:100;
temp_sum = zeros(1, length(T_Go_Plot));
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i -1, i) * (2 + T_Go_Plot).^(-(N+i));
end
Pfa_go_Plot = 2 * (1 + T_Go_Plot).^(-N) - 2 * temp_sum;
% ���ӻ� Pfa_Go �ͱ�ƻ����ӵĹ�ϵ
% ����ȷ�� ��ƻ����ӵķ�Χ
figure (8);
subplot(2, 1, 1);
plot(T_Go_Plot, Pfa_go_Plot, 'k-', 'LineWidth', 1.0);
xlabel('��ƻ����ӵ�ֵ');
ylabel('�龯����');
title('ֱ������');
subplot(2, 1, 2);
Pfa_go_Plot(Pfa_go_Plot < 0) = 0;
semilogy(T_Go_Plot, Pfa_go_Plot, 'k-', 'LineWidth', 1.0);
grid on ;
xlabel('��ƻ����ӵ�ֵ');
ylabel('�龯����/dB');
title('���������');

%% SO_CFAR �㷨
N = 10;% �������ڵĳ�������Ϊ20
T_So_Plot = 0:0.01:100;
temp_sum = zeros(1, length(T_So_Plot));
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i -1, i) * (2 + T_So_Plot).^(-(N+i));
end
Pfa_so_Plot = 2 * temp_sum;
% ���ӻ� Pfa_So �ͱ�ƻ����ӵĹ�ϵ
% ����ȷ�� ��ƻ����ӵķ�Χ
figure (9);
subplot(2, 1, 1);
plot(T_So_Plot, Pfa_so_Plot, 'k-', 'LineWidth', 1.0);
xlabel('��ƻ����ӵ�ֵ');
ylabel('�龯����');
title('ֱ������');
subplot(2, 1, 2);
Pfa_so_Plot(Pfa_so_Plot < 0) = 0;
semilogy(T_So_Plot, Pfa_so_Plot, 'k-', 'LineWidth', 1.0);
grid on ;
xlabel('��ƻ����ӵ�ֵ');
ylabel('�龯����/dB');
title('���������');

%% �����壨�޸��ţ�ƽ���ɼ첨���������Ӳ������µļ�����ܱȽ�
N = [30, 50];
% �� N ȡֵΪ20ʱ��GO_CFAR������SO_CFAR���� �����޵Ĺ���ֵ��׼
Pfa = 1e-6;
SNR_dB_ = linspace(10, 30, 400);
Pd = zeros(length(N), length(SNR_dB_));
Label_Compare_Cfar = cell(1, length(N) * 3 + 1);
Color = cell(2,3);
Color(1,:) = {{'k-'}, {'r-'}, {'b-'}};
Color(2,:) = {{'k--'}, {'r--'}, {'b--'}};
figure (10);
for i = 1:length(N)
    T_Cacfar = Pfa^(-1/N(i)) - 1;
    T_Gocfar = fzero(@(T)Pfa_GO(T,N(i)/2) - Pfa, 0.5);
    T_Socfar = fzero(@(T)Pfa_SO(T,N(i)/2) - Pfa, 0.5);
    plot(SNR_dB_, (1 + T_Cacfar./(1 + 10.^(SNR_dB_/10))).^-N(i), ...
        char(string(Color(i, 1))), 'LineWidth', 1.0);
    Label_Compare_Cfar(1, (i-1)*3 + 1) = {strcat('CA-CFAR', ':N=', num2str(N(i)))};
    hold on;
    plot(SNR_dB_, Pd_GO(T_Gocfar, 10.^(SNR_dB_/10), N(i)), ...
        char(string(Color(i, 2))), 'LineWidth', 1.0);
    Label_Compare_Cfar(1, (i-1)*3 + 2) = {strcat('GO-CFAR', ':N=', num2str(N(i)))};
    hold on;
    plot(SNR_dB_, Pd_SO(T_Socfar, 10.^(SNR_dB_/10), N(i)), ...
        char(string(Color(i, 3))), 'LineWidth', 1.0);
    Label_Compare_Cfar(1, (i-1)*3 + 3) = {strcat('SO-CFAR', ':N=', num2str(N(i)))};
    hold on;
end
T_optimal_estimation = Pfa^(-1/length(range_bins)) - 1;
plot(SNR_dB_, (1 + T_optimal_estimation./(1 + 10.^(SNR_dB_/10))).^-length(range_bins), ...
        'r+', 'LineWidth', 0.1);
Label_Compare_Cfar(1, end) = {'Approximately Optimal Estimate'};
xlabel('SNR/dB');
ylabel('The Probability of Detection');
title('Pd Compare with Pfa = 1e-6');
grid on;
legend(Label_Compare_Cfar);