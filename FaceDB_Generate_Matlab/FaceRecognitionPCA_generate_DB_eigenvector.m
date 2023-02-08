% EXP7_FaceRecognitionPCA.m
% 短学期Labview项目 PCA方法实现人脸识别
% 2021.7.15
% 荀镕基 1819660230
clear;clc;close all

% 注：Labview调用Mathscript返回中文字符串有乱码！！！》》路径全换为英文

% 1获取数据：每个文件夹（一个人的10张图）取前8张训练，后2测试
% DB_path='D:\FaceDetection_CVProject\Face_Database';
current_dir = pwd;
DB_path=strcat(fileparts(current_dir), '\Face_Database');
change_size=[200,200];%统一图像大小
[Train_struct,Test_struct,T]=CreateDB_getT(DB_path,change_size);

% test_image_path='D:\FaceDetection_CVProject\Face_Database\XunRongJi\1.jpg';%测试文件
test_image_path = strcat(DB_path, '\XunRongJi\1.jpg');
test_image=imread(test_image_path);
test_image=rgb2gray(test_image);
test_image=imresize(test_image,change_size);%输入RGB化为灰度，统一大小到200*200

% 2.PCA降维，获取特征脸
[m,A,EigenFaces]=EigenfaceCore(T);%T为所有训练图像（化为列向量）组合起来的矩阵

% 显示特征脸(降维为K维度，K张特征脸）
figure;subplot(1,2,1);imshow(reshape(EigenFaces(:,1),size(test_image)),[]);
subplot(1,2,2);imshow(reshape(EigenFaces(:,2),size(test_image)),[]);
sgtitle('降维到K维度，K张特征脸(部分）');

% 3.识别
[Predict_index,Difference_valuelist,Projected_Images]=RecognizeTest(Test_struct,EigenFaces,A,m,change_size);

%4.随机选取5个测试样本显示结果
display_num=5;
display_index=randi([1,size(Test_struct,2)],1,display_num);
figure
for i=1:display_num 
    show_index=display_index(i);
    subplot(display_num,2,2*i-1);imshow(imread(Test_struct(show_index).path));
    title(['测试样本 ',Test_struct(show_index).person_name])
    subplot(display_num,2,2*i);imshow(imread(Train_struct(Predict_index(show_index)).path))
    title(['预测样本 ',Train_struct(Predict_index(show_index)).person_name])
end
sgtitle('PCA人脸识别程序结果')
% 显示全部预测结果
for i=1:size(Test_struct,2)
    figure;
    subplot(1,2,1);imshow(imread(Test_struct(i).path));
    title(Test_struct(i).person_name)
    subplot(1,2,2);imshow(imread(Train_struct(Predict_index(i)).path))
    title(Train_struct(Predict_index(i)).person_name)
end

% 5.计算分类结果
error_num=0;
for i=1:size(Predict_index,2)
    predict_person=Train_struct(Predict_index(i)).person_name;
    true_person=Test_struct(i).person_name;
    if ~strcmp(predict_person,true_person)
        error_num=error_num+1; 
    end
end
Accuracy=1-error_num/size(Test_struct,2);

disp('PCA人脸识别程序')
disp(['测试集预测结果：Accuracy=',num2str(Accuracy),...
    ' error num=',num2str(error_num)]);


% 保存预测时候需要的文件》》DB中文件
save('FaceDetect_DB_23_2_9.mat','m','EigenFaces','Projected_Images','Train_struct')
    
    
    






















