function [output] = factori(N, index)
% �׳˼���N��
value = 1;
for i=1:index
    value = value * (N-i+1);
output = value;
end

