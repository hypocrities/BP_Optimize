%% 该代码为基于自适应变异PSO和BP网络的预测
% 由于只有 0.5 0.7 0.9 0.3 这4种输出，因此我们将这个转化为分类预测问题
%% 清空环境
clc
clear
close all
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

%构建网络
%节点个数
inputnum=13;
hiddennum=15;
outputnum=4;
net=newff(inputn,outputn,[hiddennum]);
%% BP网络训练
%网络进化参数
net.trainParam.epochs=1000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00000001;
net.trainParam.max_fail = 200;

%网络训练
[net]=train(net,inputn,outputn);
%BP网络预测
test_simu=sim(net,inputn_test);
Y_test=reverse_data(test_simu);
T_test=reverse_data(outputn_test);
figure
plot(Y_test,'o-')
hold on
plot(T_test,'*-')
title('未优化的BP')
legend('实际输出','期望输出')
xlabel('测试集样本编号')
ylabel('心理状况')
axis([-inf inf 0 1])
hold off
%% 粒子群优化BP
% 参数初始化
%粒子群算法中的参数
c1 = 1.49445;
c2 = 1.49445;
maxgen=20;   % 进化次数  
sizepop=10;   %种群规模
Vmax=1;
Vmin=-1;
popmax=1;
popmin=0;
d=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum;
% 随机初始化种群
for i=1:sizepop
    pop(i,:)=(popmax-popmin)*rands(1,d)+popmin;
    V(i,:)=(Vmax-Vmin)*rands(1,d)+Vmin;
    fitness(i)=fun(pop(i,:),inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);
end


% 个体极值和群体极值
[bestfitness bestindex]=min(fitness);
zbest=pop(bestindex,:);   %全局最佳
gbest=pop;    %个体最佳
fitnessgbest=fitness;   %个体最佳适应度值
fitnesszbest=bestfitness;   %全局最佳适应度值

%% 迭代寻优
for i=1:maxgen
    i
    
    for j=1:sizepop
        
        %速度更新
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %种群更新
        pop(j,:)=pop(j,:)+0.2*V(j,:);
        pop(j,find(pop(j,:)>popmax))=popmax;
        pop(j,find(pop(j,:)<popmin))=popmin;
        
        %自适应变异
        pos=unidrnd(d);
        if rand>0.95
            pop(j,pos)=rands(1,1);
        end
      
        %适应度值
        fitness(j)=fun(pop(j,:),inputnum,hiddennum,outputnum,inputn,outputn,inputn_test,outputn_test);
    end
    
    for j=1:sizepop
    %个体最优更新
    if fitness(j) < fitnessgbest(j)
        gbest(j,:) = pop(j,:);
        fitnessgbest(j) = fitness(j);
    end
    
    %群体最优更新 
    if fitness(j) < fitnesszbest
        zbest = pop(j,:);
        fitnesszbest = fitness(j);
    end
    
    end
    
    yy(i)=fitnesszbest;    
        
end

%% 结果分析
figure
plot(yy)
title(['适应度曲线  ' '终止代数＝' num2str(maxgen)]);
xlabel('进化代数');ylabel('适应度');

x=zbest;
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
net.trainParam.goal=0.00000001;
net.trainParam.max_fail = 200;% 最小确认失败次数 

%网络训练
[net,per2]=train(net,inputn,outputn);

%% BP网络预测
%数据归一化
test_simu=sim(net,inputn_test);
error=test_simu-outputn_test;
pso_test1=reverse_data(test_simu);
T_test=reverse_data(outputn_test);

figure
plot(Y_test,'o-')
hold on
plot(pso_test1,'o-')
plot(T_test,'*-')
title('粒子群优化的BP')
legend('未优化的BP实际输出','PSO-BP实际输出','期望输出')
xlabel('测试集样本编号')
ylabel('心理状况')
axis([-inf inf 0 1])
hold off
% 保存结果
tracepso=yy;
save pso pso_test1 T_test Y_test tracepso