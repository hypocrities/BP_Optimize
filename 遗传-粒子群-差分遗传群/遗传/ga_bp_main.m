%% �ô���Ϊ�����Ŵ��㷨��BP�������Ԥ�����
% ��ջ�������
clc
clear
close all
warning off 
format long
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
%�ڵ����
inputnum=13;
hiddennum=15;
outputnum=4;
%��������
net=newff(inputn,outputn,[hiddennum ]);

%% �Ŵ��㷨������ʼ��
maxgen=20;                         %��������������������
sizepop=5;                        %��Ⱥ��ģ
pcross=[0.2];                       %�������ѡ��0��1֮��
pmutation=[0.1];                    %�������ѡ��0��1֮��

%�ڵ�����
numsum=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;

lenchrom=ones(1,numsum);        
bound=[-ones(numsum,1) ones(numsum,1)];    %���ݷ�Χ

%------------------------------------------------------��Ⱥ��ʼ��--------------------------------------------------------
individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��
avgfitness=[];                      %ÿһ����Ⱥ��ƽ����Ӧ��
bestfitness=[];                     %ÿһ����Ⱥ�������Ӧ��
bestchrom=[];                       %��Ӧ����õ�Ⱦɫ��
%��ʼ����Ⱥ
for i=1:sizepop
        %�������һ����Ⱥ
    individuals.chrom(i,:)=Code(lenchrom,bound);
    x=individuals.chrom(i,:);
    %������Ӧ��
    individuals.fitness(i)=fun(x,inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);   %Ⱦɫ�����Ӧ��
end
FitRecord=[];
%����õ�Ⱦɫ��
[bestfitness bestindex]=min(individuals.fitness);
bestchrom=individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
avgfitness=sum(individuals.fitness)/sizepop; %Ⱦɫ���ƽ����Ӧ��
% ��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
trace=[]; 
 
%% ���������ѳ�ʼ��ֵ��Ȩֵ
% ������ʼ
for i=1:maxgen
    iter=i
    % ѡ��
    individuals=select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %����
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    % ����
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
    
    % ������Ӧ�� 
    for j=1:sizepop
                x=individuals.chrom(j,:); %����
        individuals.fitness(j)=fun(x,inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);   
    end
    
  %�ҵ���С�������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [worestfitness,worestindex]=max(individuals.fitness);
    % ������һ�ν�������õ�Ⱦɫ��
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:)=bestchrom;
    individuals.fitness(worestindex)=bestfitness;
    
    avgfitness=sum(individuals.fitness)/sizepop;
    
    trace=[trace;avgfitness bestfitness]; %��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
    FitRecord=[FitRecord;individuals.fitness];
end

%% �Ŵ��㷨������� 

figure
[r c]=size(trace);
plot([1:r]',trace(:,2),'b--');
title(['��Ӧ������  ' '��ֹ������' num2str(maxgen)]);
xlabel('��������');ylabel('��Ӧ��/��һ��ֵ��ľ�����');



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
net.trainParam.goal=0.00001;

%����ѵ��
[net,per2]=train(net,inputn,outputn);

%% BP����Ԥ��
test_simu=sim(net,inputn_test);

ga_test1=reverse_data(test_simu);
T_test=reverse_data(outputn_test);
figure

hold on
plot(ga_test1,'o-')
plot(T_test,'*-')
title('�Ŵ��Ż���BP')
legend('GA-BPʵ�����','�������')
xlabel('���Լ��������')
ylabel('����״��')
axis([-inf inf 0 1])
hold off
% ������
tracega=trace;
save GA ga_test1 T_test tracega