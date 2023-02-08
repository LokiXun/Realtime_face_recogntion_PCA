function [Predict_index,Difference_valuelist,ProjectedImages]=RecognizeTest(Test_struct,Eigenfaces,A,m,change_size)
% ʶ����̣�1������ÿ��ѵ��������ͶӰ����
%           2��ÿ�������������㵽n��ѵ��ͶӰ�����ĸ��������з���
%           3������struct�е�person_name�����жϷ����Ƿ���ȷ

%1������ÿ��ѵ��������ͶӰ����
ProjectedImages = [];
Train_Number=size(A,2);
for i = 1 : Train_Number
temp = Eigenfaces'*A(:,i); %ѡȡ��x��������������tempΪx*1������
ProjectedImages = [ProjectedImages temp]; %ѵ����ÿ��ͼ������������ͶӰ ��ÿ��ͼ��Ϊx*1��С��������
% ���棡����
end

% 2��ÿ�������������㵽n��ѵ��ͶӰ�����ĸ��������з���
Predict_index=[];
Difference_valuelist=[];
for i=1:size(Test_struct,2)
    test_image=imread(Test_struct(i).path);
    test_image=rgb2gray(test_image);
    test_image=imresize(test_image,change_size);
    
    test_reshape=reshape(test_image,numel(test_image),1);%��Ϊ������
    Difference = double(test_reshape)-m; %���Ļ�����ͼ�񣨼���ֵ��
    ProjectedTestImage = Eigenfaces'*Difference; % ������������������ͶӰ
    
    dist_list=[];
    for j=1:size(ProjectedImages,2)
        dist_value=(norm(ProjectedImages(:,j)-ProjectedTestImage))^2;
        dist_list=[dist_list,dist_value];
    end
    class_index=find(dist_list==min(dist_list));%�ҵ�����������±�
    Predict_index=[Predict_index,class_index];
    Difference_valuelist=[Difference_valuelist,min(dist_list)];
    
end









end