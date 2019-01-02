%% ��ֹĿ��
n_scatter = 3;% ɢ�������
range_scatter = [908, 910, 912];% ɢ��������

% closing condition 1
% range_scatter = [909.8, 910, 912];
% 
% % closing condition 2
% range_scatter = [909.5, 910, 912];
% 
% % closing condition 3
% range_scatter = [909.2, 910, 912];

% unambiguious range widow
% range_scatter = [908, 910, 912, 920];

rcs_scat = [100, 10, 1];% ɢ����� RCS����
n = 64;% �������崮����������ĸ���
delta_f = 10e6;% ����Ƶ��Ϊ10Mhz
win_bool = 0;% �Ƿ���źŽ��мӴ�
SNR_dB = 40;% ����40dB

% �̶��Ĳ���
c = 3e8;
num_pulses = n;
freq_step = delta_f;

% �ز��źŵ�������������ȡ
% �ڴ�Ԥ����
% I Q��·�ز��źŲ���
Inphase_tgt = zeros(num_pulses, 1);
Quadrature_tgt = zeros(num_pulses, 1);
% I Q��·Ƶ������źţ��Ӵ���
Weighted_I_freq_domain = zeros((num_pulses), 1);
Weighted_Q_freq_domain = zeros((num_pulses), 1);
% I Q��·�źźϳ�һ·���ź� ������0Ԫ��
% FFT �� IFFT ���������ԭ��
Weighted_IQ_freq_domain = zeros((2*num_pulses), 1);
for jscat = 1:n_scatter
   ii = 0;
   for i = 1:num_pulses
      ii = ii+1;
      rec_freq = ((i - 1)*freq_step);
      Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
          2*range_scatter(jscat)/c);
      Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
          2*range_scatter(jscat)/c);
   end
end

if(win_bool >= 0)
    window(1:num_pulses) = hamming(num_pulses);
else
    window(1:num_pulses) = 1;
end

Inphase = Inphase_tgt;
Quadrature = Quadrature_tgt;
% �Ӵ�
Weighted_I_freq_domain(1:num_pulses) = Inphase(1:num_pulses).* window';
Weighted_Q_freq_domain(1:num_pulses) = Quadrature(1:num_pulses).* window';
% �ϳ�һ·���ź�
Weighted_IQ_freq_domain(1:num_pulses)= Weighted_I_freq_domain + ...
   Weighted_Q_freq_domain*1i;
Weighted_IQ_freq_domain(num_pulses:2*num_pulses)=0.+0.i;
% ���з��任 �õ�һά������
Weighted_IQ_time_domain = (ifft(Weighted_IQ_freq_domain));
abs_Weighted_IQ_time_domain = (abs(Weighted_IQ_time_domain));
dB_abs_Weighted_IQ_time_domain = 20.0*log10(abs_Weighted_IQ_time_domain)+SNR_dB;
% Plot Figure
Ru = c /2/delta_f;% ��ģ�����봰�Ĵ�С

numb = 2*num_pulses;% ����ֱ浥Ԫ�ĸ���
delx_meter = Ru / numb;
xmeter = 0:delx_meter:Ru-delx_meter;
figure (1);
plot(xmeter, dB_abs_Weighted_IQ_time_domain,'k-', 'LineWidth', 1.0);
% xlabel ('relative distance - meters');
% ylabel ('Range profile - dB');
% grid on;
hold on;
%% �����˶�Ŀ��
n_scatter = 3;% ɢ�������
range_scatter = [908, 910, 912];% ɢ��������

rcs_scat = [100, 10, 1];% ɢ����� RCS����
n = 64;% �������崮����������ĸ���
delta_f = 10e6;% ����Ƶ��Ϊ10Mhz
prf = 10e3;% �����ظ�Ƶ��10Khz
win_bool = 0;% �Ƿ���źŽ��мӴ�
SNR_dB = 40;% ����40dB
r_note = 900;% ����������
v = 200;% metre per second

% �̶��Ĳ���
c = 3e8;
num_pulses = n;
PRI = 1./prf;% �����ظ�����
nfft = 2*num_pulses;% ��ifft�ĵ���
freq_step = delta_f;
taur = 2*r_note/c;

% �ز��źŵ�������������ȡ
% �ڴ�Ԥ����
% I Q��·�ز��źŲ���
Inphase_tgt = zeros(num_pulses, 1);
Quadrature_tgt = zeros(num_pulses, 1);
% I Q��·Ƶ������źţ��Ӵ���
Weighted_I_freq_domain = zeros((num_pulses), 1);
Weighted_Q_freq_domain = zeros((num_pulses), 1);
% I Q��·�źźϳ�һ·���ź� ������0Ԫ��
% FFT �� IFFT ���������ԭ��
Weighted_IQ_freq_domain = zeros((2*num_pulses), 1);
for jscat = 1:n_scatter
   ii = 0;
   for i = 1:num_pulses
      ii = ii+1;
      rec_freq = ((i - 1)*freq_step);
      Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
          (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI + taur/2 + 2*range_scatter(jscat)/c)));
      Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
          (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI + taur/2 + 2*range_scatter(jscat)/c)));
      
        % �۲���λƫ����ĵ�һ���Ӱ��(�޷��۲� �����������ƫ��)
%       Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
%           (2*range_scatter(jscat)/c - 2*(v/c)*(taur/2 + 2*range_scatter(jscat)/c)));
%       Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
%           (2*range_scatter(jscat)/c - 2*(v/c)*(taur/2 + 2*range_scatter(jscat)/c)));
      
        % �۲���λƫ����ڶ����Ӱ��(����չ�� ��ֵ�½�)
%         Inphase_tgt(ii) = Inphase_tgt(ii) + sqrt(rcs_scat(jscat)) * cos(-2*pi*rec_freq*...
%             (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI)));
%         Quadrature_tgt(ii) = Quadrature_tgt(ii) + sqrt(rcs_scat(jscat))*sin(-2*pi*rec_freq*...
%             (2*range_scatter(jscat)/c - 2*(v/c)*((i-1)*PRI)));
   end
end

if(win_bool >= 0)
    window(1:num_pulses) = hamming(num_pulses);
else
    window(1:num_pulses) = 1;
end

Inphase = Inphase_tgt;
Quadrature = Quadrature_tgt;
% �Ӵ�
Weighted_I_freq_domain(1:num_pulses) = Inphase(1:num_pulses).* window';
Weighted_Q_freq_domain(1:num_pulses) = Quadrature(1:num_pulses).* window';
% �ϳ�һ·���ź�
Weighted_IQ_freq_domain(1:num_pulses)= Weighted_I_freq_domain + ...
   Weighted_Q_freq_domain*1i;
Weighted_IQ_freq_domain(num_pulses:2*num_pulses)=0.+0.i;
% ���з��任 �õ�һά������
Weighted_IQ_time_domain = (ifft(Weighted_IQ_freq_domain));
abs_Weighted_IQ_time_domain = (abs(Weighted_IQ_time_domain));
dB_abs_Weighted_IQ_time_domain = 20.0*log10(abs_Weighted_IQ_time_domain)+SNR_dB;
% Plot Figure
Ru = c /2/delta_f;% ��ģ�����봰�Ĵ�С

numb = 2*num_pulses;% ����ֱ浥Ԫ�ĸ���
delx_meter = Ru / numb;
xmeter = 0:delx_meter:Ru-delx_meter;
% figure (2);
plot(xmeter, dB_abs_Weighted_IQ_time_domain,'r--', 'LineWidth', 1.0);
xlabel ('relative distance - meters');
ylabel ('Range profile - dB');
grid on;
hold off;