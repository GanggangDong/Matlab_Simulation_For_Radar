function [Pfa_go] = Pfa_GO(T, N)
%Pfa_Go GO_CFAR�����и����龯������ ��ƻ����ӵ�ֵ 
temp_sum = 0;
for i = 0:N-1
    temp_sum =temp_sum + nchoosek(N + i - 1, i) * (2 + T).^(-(N+i));
end
Pfa_go = 2 * (1 + T).^(-N) - 2 * temp_sum;
end

