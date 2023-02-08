function [predict_person_name,predict_image_path]=FacePredict_Labview(test_image,DB_data_path)
load(DB_data_path)%DB数据

% test_image=imresize(test_image,[200,200]);
test_reshape=double(reshape(test_image,numel(test_image),1));%化为列向量
Difference_test=double(test_reshape)-m; %1）减去均值向量m》》中心化
Projected_test=EigenFaces'*Difference_test;%2)投影

dist_list=[];
for i=1:size(Projected_Images,2)
    dis_value=(norm(Projected_Images(:,i)-Projected_test))^2;%3)计算到n个训练样本的二范数距离，看离哪个近
    dist_list=[dist_list,dis_value];
end
class_index=find(dist_list==min(dist_list));%找到最近样本的下标

%4)找到预测结果》》人名+path
predict_person_name=Train_struct(class_index).person_name;
predict_image_path=Train_struct(class_index).path;

end