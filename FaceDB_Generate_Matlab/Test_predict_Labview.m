% Test_predict_Labview.m
% 输入分割后的脸部 灰度图像
Live_path='D:\FaceDetection_CVProject\FaceDB_Generate_Matlab\test_img.jpg';
test_image=imread(Live_path);
test_image=rgb2gray(test_image);
test_image=imresize(test_image,[200,200]);

DB_data_path='D:\FaceDetection_CVProject\FaceDB_Generate_Matlab\FaceDetect_DB_7_15.mat';
[predict_person_name,predict_image_path]=FacePredict_Labview(test_image,DB_data_path);

figure
subplot(1,2,1);imshow(test_image)
subplot(1,2,2);imshow(imread(predict_image_path));title(['预测为',predict_person_name])




