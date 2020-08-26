%% �ô�������ѡ��������ڵ���
% ����ֻ�� 0.5 0.7 0.9 0.3 ��4�������������ǽ����ת��Ϊ����Ԥ������
%% ��ջ���
clc
clear
close all
format compact
%% ��ȡ����
data=xlsread('����','A2:P251');
input=[data(:,1:3) data(:,5:14)]';%��ָ�� %�����������������ȫһ������˲�Ҫ������
input=mapminmax(input,0,1);
outpu=data(:,4)';
output=trans_data(outpu);
%% �������ݼ�
rand('seed',0)
[m n]=sort(rand(1,250));
inputn=input(:,1:240);      %ѵ������
outputn=output(:,1:240);
inputn_test=input(:,241:end);%��������
outputn_test=output(:,241:end);
for i=1:30
%��������
%�ڵ����
inputnum=13;
hiddennum=i;
outputnum=4;
net=newff(inputn,outputn,[hiddennum]);
%% BP����ѵ��
%�����������
net.trainParam.epochs=100;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00000001;
net.trainParam.max_fail = 200;

%����ѵ��
[net]=train(net,inputn,outputn);
%BP����Ԥ��
test_simu=sim(net,inputn_test);
Y_test=reverse_data(test_simu);
T_test=reverse_data(outputn_test);
a(i)=mse(Y_test,T_test)

end