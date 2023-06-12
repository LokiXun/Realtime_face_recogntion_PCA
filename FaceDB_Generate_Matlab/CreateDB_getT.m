function [Train_struct,Test_struct,T]=CreateDB_getT(DB_path,change_size)
% ���룺�����ļ���·��    'D:\ģʽʶ��A\ʵ��\ʵ��7_����ʶ��\����ͼ��\100x100'
% 
% ���أ�1��ѵ�����������ݽṹ�壨������ͼ���·��+�����ַ�����
%       2��ÿ��չƽΪ����������ɵľ���T

% 1.��ѵ��������ͼ���·���ַ�������ṹ��
image_dirname=dir(DB_path);% ÿ���˵�����ͼ��洢�ڵ���һ���ļ�����
Train_index=1;Test_index=1;
filetype_simple_checklist = {'.tar', '.zip'};
for i=1:size(image_dirname,1)
    image_dir_name = image_dirname(i).name;
    
    % judge whether to skip this dir
    skip_this_dir_flag = false;
    for tmp=1:length(filetype_simple_checklist)
        if endsWith(image_dir_name, filetype_simple_checklist{tmp})
            skip_this_dir_flag = true;
            break;
        end
    end

    if strcmp(image_dirname(i).name,'.')||strcmp(image_dirname(i).name,'..')
        skip_this_dir_flag = true;
    end

    if skip_this_dir_flag
        continue;
    end


    person_path=strcat(DB_path,'\',image_dirname(i).name);%����s1��s2��·��
    personal_dirname=dir(person_path);%���˵�����ͼ�ļ���struct
    
    face_num=0;%�����˵�����ͼ�����
    for j=1:size(personal_dirname,1)
        if not(strcmp(personal_dirname(j).name,'.')|strcmp(personal_dirname(j).name,'..'))
            face_num=face_num+1;
        end
    end
    
    train_num=floor(face_num*0.9); % take parts as training set
    test_num=face_num-train_num;
    for j=1:size(personal_dirname,1)
        if not(strcmp(personal_dirname(j).name,'.')|strcmp(personal_dirname(j).name,'..'))
            if train_num>0 %ѵ��ͼ��ǰ80%�ţ�
                Train_struct(Train_index).person_name=image_dirname(i).name;
                Train_struct(Train_index).path=strcat(person_path,'\',personal_dirname(j).name);
                Train_index=Train_index+1;
                train_num=train_num-1;
            elseif test_num>0
                Test_struct(Test_index).person_name=image_dirname(i).name;
                Test_struct(Test_index).path=strcat(person_path,'\',personal_dirname(j).name);
                Test_index=Test_index+1;
                test_num=test_num-1;
            end
        end
    end
end

% 2.��ȡTrain_struct�ṹ����ѵ�����ݡ���ͼ��չƽ(T���к���ṹ����Ŷ�Ӧ��
T=[];
for i=1:size(Train_struct,2)
    image_train=imread(Train_struct(i).path);%�����rgbͼ��
    image_train=rgb2gray(image_train);
    image_train=imresize(image_train,change_size);%ͳһ��С200*200
    [row_n,col_n]=size(image_train);
    image_reshape=reshape(image_train,row_n*col_n,1);
    T=[T,image_reshape];%ÿ��һ��ͼ��
end

end