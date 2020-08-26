%% 该代码用于选择隐含层节点数
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
for i=1:30
%构建网络
%节点个数
inputnum=13;
hiddennum=i;
outputnum=4;
net=newff(inputn,outputn,[hiddennum]);
%% BP网络训练
%网络进化参数
net.trainParam.epochs=100;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00000001;
net.trainParam.max_fail = 200;

%网络训练
[net]=train(net,inputn,outputn);
%BP网络预测
test_simu=sim(net,inputn_test);
Y_test=reverse_data(test_simu);
T_test=reverse_data(outputn_test);
a(i)=mse(Y_test,T_test)

end