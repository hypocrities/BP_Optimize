% ��ͼ
clear
load pso
load GA
load DE_GA
% ��Ӧ�����߶Ա�
figure
plot(tracepso)
hold on
plot(tracega(:,2))
plot(tracedega(:,2))
hold off
legend('����Ⱥ','�Ŵ�','����Ŵ�')
xlabel('Ѱ�Ŵ���')
ylabel('��Ӧ��ֵ')
title('��Ӧ�����߶Ա�')

% ����Ա�
figure
plot(T_test)
hold on
plot(pso_test1,'*')
plot(ga_test1,'*')
plot(de_ga_test1,'*')
title('��ͬ��������Ա�')
legend('�������','����Ⱥ���','�Ŵ����','����Ŵ����')
xlabel('���Լ����')
axis([-inf inf 0 1])