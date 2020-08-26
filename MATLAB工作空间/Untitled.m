%准备好训练集
[NUM]=xlsread('各年级生源数据(全)1.30张- 副本(1).xlsx',1);
%输入数据矩阵
p = NUM';
%目标（输出）数据矩阵
[NUM]=xlsread('各年级生源数据(全)1.30张- 副本(1).xlsx',2);
t = NUM';
%对训练集中的输入数据矩阵和目标数据矩阵进行归一化处理
[pn, inputStr] = mapminmax(p);
[tn, outputStr] = mapminmax(t);

%建立BP神经网络
net = newff(pn, tn, [7 14], {'purelin', 'logsig'});

%每10轮回显示一次结果
net.trainParam.show = 10;
%最大训练次数
net.trainParam.epochs = 5000;

%网络的学习速率
net.trainParam.lr = 0.05;

%训练网络所要达到的目标误差
net.trainParam.goal = 0.65 * 10^(-3);

%网络误差如果连续6次迭代都没变化，则matlab会默认终止训练。为了让程序继续运行，用以下命令取消这条设置
net.divideFcn = '';
%开始训练网络
net = train(net, pn, tn);
%使用训练好的网络，基于训练集的数据对BP网络进行仿真得到网络输出结果
%(因为输入样本（训练集）容量较少，否则一般必须用新鲜数据进行仿真测试)
answer = sim(net, pn);
%反归一化
answer1 = mapminmax('reverse', answer, outputStr);

%绘制测试样本神经网络输出和实际样本输出的对比图(figure(1))-------------------------------------------
t = 1:1504;

%测试样本网络输出心理状态
a1 = answer1(1,:); 

figure(1);
subplot(2, 1, 1); plot(t, a1, 'ro', t,tn, 'b+');
legend('网络输出心理状态', '实际心理状态');
xlabel('学生'); ylabel('心理状态');
title('神经网络心理状态学习与测试对比图');
grid on;

%使用训练好的神经网络对新输入数据进行预测

%新输入数据(16项)
newInput = [0.5;0.3;0;1;1.1;0.4;0.81;0.7;1;0;0;0;0.5;0;0;0.5]; 

%利用原始输入数据(训练集的输入数据)的归一化参数对新输入数据进行归一化
newInput = mapminmax('apply', newInput, inputStr);

%进行仿真
newOutput = sim(net, newInput);
%反归一化

newOutput = mapminmax('reverse',newOutput, outputStr);

disp('预测的学生的心理状态为：');
newOutput(1,:)
%在figure(1)的基础上绘制预测情况-------------------------------------------------------
figure(2);
t1 = 1:1505;

subplot(2, 1, 1); plot(t1, [a1 newOutput(1,:)], 'ro', t,tn, 'b+');
legend('网络输出心理状态', '实际心理状态');
xlabel('学生'); ylabel('心理状态');
title('神经网络心理状态学习与测试对比图(添加了预测数据)');
grid on;

