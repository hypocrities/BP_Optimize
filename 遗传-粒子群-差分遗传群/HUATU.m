% 画图
clear
load pso
load GA
load DE_GA
% 适应度曲线对比
figure
plot(tracepso)
hold on
plot(tracega(:,2))
plot(tracedega(:,2))
hold off
legend('粒子群','遗传','差分遗传')
xlabel('寻优代数')
ylabel('适应度值')
title('适应度曲线对比')

% 结果对比
figure
plot(T_test)
hold on
plot(pso_test1,'*')
plot(ga_test1,'*')
plot(de_ga_test1,'*')
title('不同方法输出对比')
legend('期望输出','粒子群输出','遗传输出','差分遗传输出')
xlabel('测试集编号')
axis([-inf inf 0 1])