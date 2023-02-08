function [predict_person_name,predict_image_path]=FacePredict_Labview(test_image,DB_data_path)
load(DB_data_path)%DB����

% test_image=imresize(test_image,[200,200]);
test_reshape=double(reshape(test_image,numel(test_image),1));%��Ϊ������
Difference_test=double(test_reshape)-m; %1����ȥ��ֵ����m�������Ļ�
Projected_test=EigenFaces'*Difference_test;%2)ͶӰ

dist_list=[];
for i=1:size(Projected_Images,2)
    dis_value=(norm(Projected_Images(:,i)-Projected_test))^2;%3)���㵽n��ѵ�������Ķ��������룬�����ĸ���
    dist_list=[dist_list,dis_value];
end
class_index=find(dist_list==min(dist_list));%�ҵ�����������±�

%4)�ҵ�Ԥ������������+path
predict_person_name=Train_struct(class_index).person_name;
predict_image_path=Train_struct(class_index).path;

end