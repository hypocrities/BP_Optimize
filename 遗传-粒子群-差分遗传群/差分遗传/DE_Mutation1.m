function ret=DE_Mutation1(pmutation,lenchrom,chrom,sizepop,num,maxgen,bound)
% 本函数完成基于差分改进的变异操作,可对比Mutation.m中的普通变异操作
% pmutation             input  : 变异概率
% lenchrom              input  : 染色体长度
% chrom     input  : 染色体群
% sizepop               input  : 种群规模
% opts                  input  : 变异方法的选择
% pop                   input  : 当前种群的进化代数和最大的进化代数信息
% bound                 input  : 每个个体的上届和下届
% maxgen                input  ：最大迭代次数
% num                   input  : 当前迭代次数
% ret                   output : 变异后的染色体


% 自适应变异算子
   lamda=exp(1-num/(maxgen+1-num));
   F=pmutation*2^(lamda);
for m=1:sizepop  
    %%%% 差分变异和普通遗传变异的差别是，差分利用多个染色体对其中一个进行变异，而普通变异是只对一个进行变异
    %%%%r1 r2 m互不相同
    % 这里采用 r1 与 r2 来对m进行扰动变异
    r1=randi([1,sizepop],1,1);
    r2=randi([1,sizepop],1,1);
    while (m==r1)|(m==r2)|(r1==r2)
    r1=randi([1,sizepop],1,1);
    r2=randi([1,sizepop],1,1);
    end
    chrom(m,:)=chrom(m,:)+(chrom(r1,:)-chrom(r2,:))*F;
    for j=1:lenchrom %判断是否超出边界

        if chrom(m,j)>bound(2)|chrom(m,j)<bound(1)
            chrom(m,j)=bound(1)+(bound(2)-bound(1))*rand;
        end
    end
end
ret=chrom;