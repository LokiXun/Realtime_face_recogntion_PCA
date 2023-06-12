function [Train_struct,Test_struct,T]=CreateDB_getT(DB_path,change_size)
% 传入：数据文件库路径    'D:\模式识别A\实验\实验7_人脸识别\人脸图像\100x100'
% 
% 返回：1）训练、测试数据结构体（存人脸图像的路径+人名字符串）
%       2）每个展平为列向量后组成的矩阵T

% 1.将训练、测试图像的路径字符串存入结构体
image_dirname=dir(DB_path);% 每个人的人脸图像存储于单独一个文件夹内
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


    person_path=strcat(DB_path,'\',image_dirname(i).name);%人名s1，s2的路径
    personal_dirname=dir(person_path);%该人的人脸图文件名struct
    
    face_num=0;%数此人的人脸图像个数
    for j=1:size(personal_dirname,1)
        if not(strcmp(personal_dirname(j).name,'.')|strcmp(personal_dirname(j).name,'..'))
            face_num=face_num+1;
        end
    end
    
    train_num=floor(face_num*0.9); % take parts as training set
    test_num=face_num-train_num;
    for j=1:size(personal_dirname,1)
        if not(strcmp(personal_dirname(j).name,'.')|strcmp(personal_dirname(j).name,'..'))
            if train_num>0 %训练图像（前80%张）
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

% 2.读取Train_struct结构体内训练数据》》图像展平(T的列号与结构体序号对应）
T=[];
for i=1:size(Train_struct,2)
    image_train=imread(Train_struct(i).path);%存的是rgb图像
    image_train=rgb2gray(image_train);
    image_train=imresize(image_train,change_size);%统一大小200*200
    [row_n,col_n]=size(image_train);
    image_reshape=reshape(image_train,row_n*col_n,1);
    T=[T,image_reshape];%每列一个图像
end

end