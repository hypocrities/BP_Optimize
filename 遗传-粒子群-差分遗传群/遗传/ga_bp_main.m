%% 该代码为基于遗传算法与BP神经网络的预测代码
% 清空环境变量
clc
clear
close all
warning off 
format long
format compact
%% 读取数据
data=xlsread('数据','A2:P251');
input=[data(:,1:3) data(:,5:14)]';%各指标 %由于最后两列数据完全一样，因此不要这两列
input=mapminmax(input,0,1);
outpu=data(:,4)';
output=trans_data(outpu);
%% 划分数据集
rand('seed',0)
[m n]=sort(rand(1,250));
inputn=input(:,1:240);      %训练输入
outputn=output(:,1:240);
inputn_test=input(:,241:end);%测试输入
outputn_test=output(:,241:end);
%节点个数
inputnum=13;
hiddennum=15;
outputnum=4;
%构建网络
net=newff(inputn,outputn,[hiddennum ]);

%% 遗传算法参数初始化
maxgen=20;                         %进化代数，即迭代次数
sizepop=5;                        %种群规模
pcross=[0.2];                       %交叉概率选择，0和1之间
pmutation=[0.1];                    %变异概率选择，0和1之间

%节点总数
numsum=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;

lenchrom=ones(1,numsum);        
bound=[-ones(numsum,1) ones(numsum,1)];    %数据范围

%------------------------------------------------------种群初始化--------------------------------------------------------
individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %将种群信息定义为一个结构体
avgfitness=[];                      %每一代种群的平均适应度
bestfitness=[];                     %每一代种群的最佳适应度
bestchrom=[];                       %适应度最好的染色体
%初始化种群
for i=1:sizepop
        %随机产生一个种群
    individuals.chrom(i,:)=Code(lenchrom,bound);
    x=individuals.chrom(i,:);
    %计算适应度
    individuals.fitness(i)=fun(x,inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);   %染色体的适应度
end
FitRecord=[];
%找最好的染色体
[bestfitness bestindex]=min(individuals.fitness);
bestchrom=individuals.chrom(bestindex,:);  %最好的染色体
avgfitness=sum(individuals.fitness)/sizepop; %染色体的平均适应度
% 记录每一代进化中最好的适应度和平均适应度
trace=[]; 
 
%% 迭代求解最佳初始阀值和权值
% 进化开始
for i=1:maxgen
    iter=i
    % 选择
    individuals=select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %交叉
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
    % 变异
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
    
    % 计算适应度 
    for j=1:sizepop
                x=individuals.chrom(j,:); %解码
        individuals.fitness(j)=fun(x,inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);   
    end
    
  %找到最小和最大适应度的染色体及它们在种群中的位置
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [worestfitness,worestindex]=max(individuals.fitness);
    % 代替上一次进化中最好的染色体
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:)=bestchrom;
    individuals.fitness(worestindex)=bestfitness;
    
    avgfitness=sum(individuals.fitness)/sizepop;
    
    trace=[trace;avgfitness bestfitness]; %记录每一代进化中最好的适应度和平均适应度
    FitRecord=[FitRecord;individuals.fitness];
end

%% 遗传算法结果分析 

figure
[r c]=size(trace);
plot([1:r]',trace(:,2),'b--');
title(['适应度曲线  ' '终止代数＝' num2str(maxgen)]);
xlabel('进化代数');ylabel('适应度/归一化值后的均方差');



%% 把最优初始阀值权值赋予网络预测
% %用遗传算法优化的BP网络进行值预测
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=B2';

%% BP网络训练
%网络进化参数
net.trainParam.epochs=1000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00001;

%网络训练
[net,per2]=train(net,inputn,outputn);

%% BP网络预测
test_simu=sim(net,inputn_test);

ga_test1=reverse_data(test_simu);
T_test=reverse_data(outputn_test);
figure

hold on
plot(ga_test1,'o-')
plot(T_test,'*-')
title('遗传优化的BP')
legend('GA-BP实际输出','期望输出')
xlabel('测试集样本编号')
ylabel('心理状况')
axis([-inf inf 0 1])
hold off
% 保存结果
tracega=trace;
save GA ga_test1 T_test tracega