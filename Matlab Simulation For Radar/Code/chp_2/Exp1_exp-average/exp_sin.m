%% ����ָ��ƽ����Ч��
% ����0��1֮����ȷֲ��������
size = [1, 100];
index = sort(rand(size));
y_index = sin(2*pi*index);

% �������Һ�����ͼ
figure (1);
plot(index, y_index, 'r', 'linewidth', 2);
axis([-0.2, 1.2, -1.2, 1.2]);
hold on;

% �������
noise_square = 0.1;
y_awgn = noise_square * randn(size) + y_index;
plot(index, y_awgn, 'bo');
hold on;

%% ָ��ƽ��
% �趨ָ��ƽ���ĳ�ʼֵ
v = zeros(1, length(y_awgn) + 1);
v_norm = zeros(1, length(y_awgn) + 1);
v(1) = 0;
v_norm(1) = 0;
beta = 0.9;

n_points = 1/(1-beta);
% 
% % ����Ȩ��ϵ������
% exp_coefficients = zeros(1, n_points + 1);% ���ϵ�ǰ���ϵ��
% exp_coefficients(1) = beta^n_points;
% for i = 2:(n_points+1)
%     exp_coefficients(i) = (1 - beta) * beta^(n_points + 1 - i);
% end

for i = 1:length(y_awgn)
    v(i+1) = beta * v(i) + (1-beta) * y_awgn(i);
    % ϵ������
    % ϵ�������е��õ�v��δ������
    v_norm(i+1) = (beta * v(i) + (1-beta) * y_awgn(i)) * (1 - beta^i);
end

plot(index, v(2:end), 'k+', index, v_norm(2:end), 'y*');
plot(index, v_norm(2:end), 'y*');
title('ָ��ƽ��');
xlabel('t');
ylabel('value');
grid on;
hold off;
legend("y=sin(2*\pi*x)", "�����" ,"ָ��ƽ��\beta="+num2str(beta), "ϵ��������");
