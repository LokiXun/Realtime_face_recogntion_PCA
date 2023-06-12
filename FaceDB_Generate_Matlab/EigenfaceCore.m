function [m, A, Eigenfaces] = EigenfaceCore(T)
% 运用主成分分析法PCA
%
% 参数:      TestImage              - 输入图像的路径
%
%                m                      - 训练集数据库的均值,它是由“EigenfaceCore”函数输出的。
%
%                Eigenfaces             - 训练数据库协方差矩阵的特征向量，是由“EigenfaceCore”函数的输出的。
%
%                A                      - 中心化图像矩阵的向量（每个图像向量-均值图像向量）,它是由“EigenfaceCore”函数输出的。
% 
% 
% 结果:       OutputName             - 在训练集数据库中所识别图象的名字。
%
% 调用函数:   EIG
            
%%%%%%%%%%%%%%%%%%%%%%%% 计算图像均值
m = mean(T,2); % 计算各行均值(所有列求均值）>>均值向量m
Train_Number = size(T,2);%返回T的列数（图像个数）

%%%%%%%%%%%%%%%%%%%%%%%% 计算每张图像和均值的差
A = [];  
for i = 1 : Train_Number
    temp = double(T(:,i)) - m; %化为double，防止原来uint8无符号不能计算负数
    A = [A temp]; % 合并为所有的中心化图片（减去均值）
end

%%%%%%%%%%%%%%%%%%%%%%%% 快速特征脸算法
L = A'*A; % L 是C的协方差矩阵>>图像个数x》L：x*x 大小
size(A)
size(L)
[V D] = eig(L); % 求矩阵A的全部特征值，对角阵D,A的特征向量构成V的列向量
size(V(:,1))
% 注：对角阵D中特征值已经从小->大排列好了

%%%%%%%%%%%%%%%%%%%%%%%% 排序和消除特征值
L_eig_vec = [];
sum=0;
for i=1: size(V,2)
    sum=sum+D(i,i);%所有特征值之和
end
sub=0;rate=0;
while (rate<0.99)
    sub=sub+D(i,i);%从大到小取特征值，取对应的特征向量
    rate=sub/sum;  %类似累计概率（相当于取99%的特征值）
    L_eig_vec = [L_eig_vec V(:,i)];    %求主分量（从后向前取特征向量》》转置的变换矩阵） 
    i=i-1; 
end
%注：最后取了第6-20列的特征值
%%%%%%%%%%%%%%%%%%%%%%%% 计算协方差矩阵C的特征向量
Eigenfaces = A * L_eig_vec; % 求特征脸》》降维k维，k个特征脸
