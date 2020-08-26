%׼����ѵ����
[NUM]=xlsread('���꼶��Դ����(ȫ)1.30��- ����(1).xlsx',1);
%�������ݾ���
p = NUM';
%Ŀ�꣨��������ݾ���
[NUM]=xlsread('���꼶��Դ����(ȫ)1.30��- ����(1).xlsx',2);
t = NUM';
%��ѵ�����е��������ݾ����Ŀ�����ݾ�����й�һ������
[pn, inputStr] = mapminmax(p);
[tn, outputStr] = mapminmax(t);

%����BP������
net = newff(pn, tn, [7 14], {'purelin', 'logsig'});

%ÿ10�ֻ���ʾһ�ν��
net.trainParam.show = 10;
%���ѵ������
net.trainParam.epochs = 5000;

%�����ѧϰ����
net.trainParam.lr = 0.05;

%ѵ��������Ҫ�ﵽ��Ŀ�����
net.trainParam.goal = 0.65 * 10^(-3);

%��������������6�ε�����û�仯����matlab��Ĭ����ֹѵ����Ϊ���ó���������У�����������ȡ����������
net.divideFcn = '';
%��ʼѵ������
net = train(net, pn, tn);
%ʹ��ѵ���õ����磬����ѵ���������ݶ�BP������з���õ�����������
%(��Ϊ����������ѵ�������������٣�����һ��������������ݽ��з������)
answer = sim(net, pn);
%����һ��
answer1 = mapminmax('reverse', answer, outputStr);

%���Ʋ������������������ʵ����������ĶԱ�ͼ(figure(1))-------------------------------------------
t = 1:1504;

%�������������������״̬
a1 = answer1(1,:); 

figure(1);
subplot(2, 1, 1); plot(t, a1, 'ro', t,tn, 'b+');
legend('�����������״̬', 'ʵ������״̬');
xlabel('ѧ��'); ylabel('����״̬');
title('����������״̬ѧϰ����ԶԱ�ͼ');
grid on;

%ʹ��ѵ���õ�����������������ݽ���Ԥ��

%����������(16��)
newInput = [0.5;0.3;0;1;1.1;0.4;0.81;0.7;1;0;0;0;0.5;0;0;0.5]; 

%����ԭʼ��������(ѵ��������������)�Ĺ�һ�����������������ݽ��й�һ��
newInput = mapminmax('apply', newInput, inputStr);

%���з���
newOutput = sim(net, newInput);
%����һ��

newOutput = mapminmax('reverse',newOutput, outputStr);

disp('Ԥ���ѧ��������״̬Ϊ��');
newOutput(1,:)
%��figure(1)�Ļ����ϻ���Ԥ�����-------------------------------------------------------
figure(2);
t1 = 1:1505;

subplot(2, 1, 1); plot(t1, [a1 newOutput(1,:)], 'ro', t,tn, 'b+');
legend('�����������״̬', 'ʵ������״̬');
xlabel('ѧ��'); ylabel('����״̬');
title('����������״̬ѧϰ����ԶԱ�ͼ(�����Ԥ������)');
grid on;

