function ret=DE_Mutation1(pmutation,lenchrom,chrom,sizepop,num,maxgen,bound)
% ��������ɻ��ڲ�ָĽ��ı������,�ɶԱ�Mutation.m�е���ͨ�������
% pmutation             input  : �������
% lenchrom              input  : Ⱦɫ�峤��
% chrom     input  : Ⱦɫ��Ⱥ
% sizepop               input  : ��Ⱥ��ģ
% opts                  input  : ���췽����ѡ��
% pop                   input  : ��ǰ��Ⱥ�Ľ������������Ľ���������Ϣ
% bound                 input  : ÿ��������Ͻ���½�
% maxgen                input  ������������
% num                   input  : ��ǰ��������
% ret                   output : ������Ⱦɫ��


% ����Ӧ��������
   lamda=exp(1-num/(maxgen+1-num));
   F=pmutation*2^(lamda);
for m=1:sizepop  
    %%%% ��ֱ������ͨ�Ŵ�����Ĳ���ǣ�������ö��Ⱦɫ�������һ�����б��죬����ͨ������ֻ��һ�����б���
    %%%%r1 r2 m������ͬ
    % ������� r1 �� r2 ����m�����Ŷ�����
    r1=randi([1,sizepop],1,1);
    r2=randi([1,sizepop],1,1);
    while (m==r1)|(m==r2)|(r1==r2)
    r1=randi([1,sizepop],1,1);
    r2=randi([1,sizepop],1,1);
    end
    chrom(m,:)=chrom(m,:)+(chrom(r1,:)-chrom(r2,:))*F;
    for j=1:lenchrom %�ж��Ƿ񳬳��߽�

        if chrom(m,j)>bound(2)|chrom(m,j)<bound(1)
            chrom(m,j)=bound(1)+(bound(2)-bound(1))*rand;
        end
    end
end
ret=chrom;