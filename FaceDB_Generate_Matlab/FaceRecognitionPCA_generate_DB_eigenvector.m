% EXP7_FaceRecognitionPCA.m
% ��ѧ��Labview��Ŀ PCA����ʵ������ʶ��
% 2021.7.15
% ���F�� 1819660230
clear;clc;close all

% ע��Labview����Mathscript���������ַ��������룡��������·��ȫ��ΪӢ��

% 1��ȡ���ݣ�ÿ���ļ��У�һ���˵�10��ͼ��ȡǰ8��ѵ������2����
% DB_path='D:\FaceDetection_CVProject\Face_Database';
current_dir = pwd;
DB_path=strcat(fileparts(current_dir), '\Face_Database');
change_size=[200,200];%ͳһͼ���С
[Train_struct,Test_struct,T]=CreateDB_getT(DB_path,change_size);

% test_image_path='D:\FaceDetection_CVProject\Face_Database\XunRongJi\1.jpg';%�����ļ�
test_image_path = strcat(DB_path, '\XunRongJi\1.jpg');
test_image=imread(test_image_path);
test_image=rgb2gray(test_image);
test_image=imresize(test_image,change_size);%����RGB��Ϊ�Ҷȣ�ͳһ��С��200*200

% 2.PCA��ά����ȡ������
[m,A,EigenFaces]=EigenfaceCore(T);%TΪ����ѵ��ͼ�񣨻�Ϊ����������������ľ���

% ��ʾ������(��άΪKά�ȣ�K����������
figure;subplot(1,2,1);imshow(reshape(EigenFaces(:,1),size(test_image)),[]);
subplot(1,2,2);imshow(reshape(EigenFaces(:,2),size(test_image)),[]);
sgtitle('��ά��Kά�ȣ�K��������(���֣�');

% 3.ʶ��
[Predict_index,Difference_valuelist,Projected_Images]=RecognizeTest(Test_struct,EigenFaces,A,m,change_size);

%4.���ѡȡ5������������ʾ���
display_num=5;
display_index=randi([1,size(Test_struct,2)],1,display_num);
figure
for i=1:display_num 
    show_index=display_index(i);
    subplot(display_num,2,2*i-1);imshow(imread(Test_struct(show_index).path));
    title(['�������� ',Test_struct(show_index).person_name])
    subplot(display_num,2,2*i);imshow(imread(Train_struct(Predict_index(show_index)).path))
    title(['Ԥ������ ',Train_struct(Predict_index(show_index)).person_name])
end
sgtitle('PCA����ʶ�������')
% ��ʾȫ��Ԥ����
for i=1:size(Test_struct,2)
    figure;
    subplot(1,2,1);imshow(imread(Test_struct(i).path));
    title(Test_struct(i).person_name)
    subplot(1,2,2);imshow(imread(Train_struct(Predict_index(i)).path))
    title(Train_struct(Predict_index(i)).person_name)
end

% 5.���������
error_num=0;
for i=1:size(Predict_index,2)
    predict_person=Train_struct(Predict_index(i)).person_name;
    true_person=Test_struct(i).person_name;
    if ~strcmp(predict_person,true_person)
        error_num=error_num+1; 
    end
end
Accuracy=1-error_num/size(Test_struct,2);

disp('PCA����ʶ�����')
disp(['���Լ�Ԥ������Accuracy=',num2str(Accuracy),...
    ' error num=',num2str(error_num)]);


% ����Ԥ��ʱ����Ҫ���ļ�����DB���ļ�
save('FaceDetect_DB_23_2_9.mat','m','EigenFaces','Projected_Images','Train_struct')
    
    
    






















