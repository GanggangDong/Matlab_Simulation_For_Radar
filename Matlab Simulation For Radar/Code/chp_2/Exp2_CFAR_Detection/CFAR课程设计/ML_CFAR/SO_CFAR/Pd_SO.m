function [Pd_go] = Pd_SO(T, SNR_numeric, N)
%PD_GO ������ƻ����Ӻ�����ȣ�����GO_CFAR�ļ�����
% input:�����龯�����µı�ƻ����� T��SNR����ֵ��ʽ���Լ��뻬�����
temp_sum = 0;
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i - 1, i) * (2 + T./(1 + SNR_numeric)).^(-(N+i));
end
Pd_go =  2 * temp_sum;
end

