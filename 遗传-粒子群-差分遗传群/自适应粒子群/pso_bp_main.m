%% �ô���Ϊ��������Ӧ����PSO��BP�����Ԥ��
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

%��������
%�ڵ����
inputnum=13;
hiddennum=15;
outputnum=4;
net=newff(inputn,outputn,[hiddennum]);
%% BP����ѵ��
%�����������
net.trainParam.epochs=1000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00000001;
net.trainParam.max_fail = 200;

%����ѵ��
[net]=train(net,inputn,outputn);
%BP����Ԥ��
test_simu=sim(net,inputn_test);
Y_test=reverse_data(test_simu);
T_test=reverse_data(outputn_test);
figure
plot(Y_test,'o-')
hold on
plot(T_test,'*-')
title('δ�Ż���BP')
legend('ʵ�����','�������')
xlabel('���Լ��������')
ylabel('����״��')
axis([-inf inf 0 1])
hold off
%% ����Ⱥ�Ż�BP
% ������ʼ��
%����Ⱥ�㷨�еĲ���
c1 = 1.49445;
c2 = 1.49445;
maxgen=20;   % ��������  
sizepop=10;   %��Ⱥ��ģ
Vmax=1;
Vmin=-1;
popmax=1;
popmin=0;
d=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;
% �����ʼ����Ⱥ
for i=1:sizepop
    pop(i,:)=(popmax-popmin)*rands(1,d)+popmin;
    V(i,:)=(Vmax-Vmin)*rands(1,d)+Vmin;
    fitness(i)=fun(pop(i,:),inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);
end


% ���弫ֵ��Ⱥ�弫ֵ
[bestfitness bestindex]=min(fitness);
zbest=pop(bestindex,:);   %ȫ�����
gbest=pop;    %�������
fitnessgbest=fitness;   %���������Ӧ��ֵ
fitnesszbest=bestfitness;   %ȫ�������Ӧ��ֵ

%% ����Ѱ��
for i=1:maxgen
    i
    
    for j=1:sizepop
        
        %�ٶȸ���
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %��Ⱥ����
        pop(j,:)=pop(j,:)+0.2*V(j,:);
        pop(j,find(pop(j,:)>popmax))=popmax;
        pop(j,find(pop(j,:)<popmin))=popmin;
        
        %����Ӧ����
        pos=unidrnd(d);
        if rand>0.95
            pop(j,pos)=rands(1,1);
        end
      
        %��Ӧ��ֵ
        fitness(j)=fun(pop(j,:),inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);
    end
    
    for j=1:sizepop
    %�������Ÿ���
    if fitness(j) < fitnessgbest(j)
        gbest(j,:) = pop(j,:);
        fitnessgbest(j) = fitness(j);
    end
    
    %Ⱥ�����Ÿ��� 
    if fitness(j) < fitnesszbest
        zbest = pop(j,:);
        fitnesszbest = fitness(j);
    end
    
    end
    
    yy(i)=fitnesszbest;    
        
end

%% �������
figure
plot(yy)
title(['��Ӧ������  ' '��ֹ������' num2str(maxgen)]);
xlabel('��������');ylabel('��Ӧ��');

x=zbest;
%% �����ų�ʼ��ֵȨֵ��������Ԥ��
% %���Ŵ��㷨�Ż���BP�������ֵԤ��
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);

net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=B2';

%% BP����ѵ��
%�����������
net.trainParam.epochs=1000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00000001;
net.trainParam.max_fail = 200;% ��Сȷ��ʧ�ܴ��� 

%����ѵ��
[net,per2]=train(net,inputn,outputn);

%% BP����Ԥ��
%���ݹ�һ��
test_simu=sim(net,inputn_test);
error=test_simu-outputn_test;
pso_test1=reverse_data(test_simu);
T_test=reverse_data(outputn_test);

figure
plot(Y_test,'o-')
hold on
plot(pso_test1,'o-')
plot(T_test,'*-')
title('����Ⱥ�Ż���BP')
legend('δ�Ż���BPʵ�����','PSO-BPʵ�����','�������')
xlabel('���Լ��������')
ylabel('����״��')
axis([-inf inf 0 1])
hold off
% ������
tracepso=yy;
save pso pso_test1 T_test Y_test tracepso