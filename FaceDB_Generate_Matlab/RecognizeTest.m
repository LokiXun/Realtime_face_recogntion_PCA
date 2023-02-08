function [Predict_index,Difference_valuelist,ProjectedImages]=RecognizeTest(Test_struct,Eigenfaces,A,m,change_size)
% 识别过程：1）计算每个训练样本的投影向量
%           2）每个测试样本计算到n个训练投影向量哪个近，进行分类
%           3）根据struct中的person_name进行判断分类是否正确

%1）计算每个训练样本的投影向量
ProjectedImages = [];
Train_Number=size(A,2);
for i = 1 : Train_Number
temp = Eigenfaces'*A(:,i); %选取了x个特征向量》》temp为x*1的向量
ProjectedImages = [ProjectedImages temp]; %训练集每个图像向特征向量投影 （每个图化为x*1大小的向量）
% 保存！！！
end

% 2）每个测试样本计算到n个训练投影向量哪个近，进行分类
Predict_index=[];
Difference_valuelist=[];
for i=1:size(Test_struct,2)
    test_image=imread(Test_struct(i).path);
    test_image=rgb2gray(test_image);
    test_image=imresize(test_image,change_size);
    
    test_reshape=reshape(test_image,numel(test_image),1);%化为列向量
    Difference = double(test_reshape)-m; %中心化测试图像（减均值）
    ProjectedTestImage = Eigenfaces'*Difference; % 测试样本向特征向量投影
    
    dist_list=[];
    for j=1:size(ProjectedImages,2)
        dist_value=(norm(ProjectedImages(:,j)-ProjectedTestImage))^2;
        dist_list=[dist_list,dist_value];
    end
    class_index=find(dist_list==min(dist_list));%找到最近样本的下标
    Predict_index=[Predict_index,class_index];
    Difference_valuelist=[Difference_valuelist,min(dist_list)];
    
end









end