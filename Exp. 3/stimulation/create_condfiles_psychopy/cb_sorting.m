% Once we have obj_names.all pasted from excel, we can run this short
% script to divide the names in different CB conditions.

% For easier handling
t=readtable('obj_names.csv');a=[t.Music,t.Household];b=a;
nobjs=length(a);
for i=1:nobjs
    b{i,1}=[a{i,1},'2'];
    b{i,2}=[a{i,2},'2'];
end

% Create CB lists
pred1=a;list=(1:1+11);
learn1=pred1(list,:);pred1(list,:)=[];
temp=b;
learn1=[learn1;temp(list,:)];temp(list,:)=[];pred1=[pred1;temp];

pred2=a;list=(13:13+11);
learn2=pred2(list,:);pred2(list,:)=[];
temp=b;
learn2=[learn2;temp(list,:)];temp(list,:)=[];pred2=[pred2;temp];

pred3=a;list=(25:25+11);
learn3=pred3(list,:);pred3(list,:)=[];
temp=b;
learn3=[learn3;temp(list,:)];temp(list,:)=[];pred3=[pred3;temp];

pred4=a;list=(33:33+11);
learn4=pred4(list,:);pred4(list,:)=[];
temp=b;
learn4=[learn4;temp(list,:)];temp(list,:)=[];pred4=[pred4;temp];

pred5=a;list=(36:36+11);
learn5=pred5(list,:);pred5(list,:)=[];
temp=b;
learn5=[learn5;temp(list,:)];temp(list,:)=[];pred5=[pred5;temp];

% Merge them in a 3-D matrix for storage
obj_names.learn=cat(3,learn1,learn2,learn3,learn4,learn5);
obj_names.pred=cat(3,pred1,pred2,pred3,pred4,pred5);

% Build new object names by adding "3" and "4"
for cbC=1:5
    for catC=1:2
        for i=1:length(obj_names.pred)
            if ~ismember('2',obj_names.pred{i,1})
                new{i,catC,cbC}=[obj_names.pred{i,catC,cbC},'3'];
            elseif ismember('2',obj_names.pred{i,1})
                new{i,catC,cbC}=[obj_names.pred{i,catC,cbC}(1:end-1),'4'];
                
            end
        end
    end
end
obj_names.new=new;


%% Now we do a little switch to run the new items as old for some participants
% Create copy
temp=obj_names.new;

% Put old into new
obj_names.new(:,:,2)=obj_names.pred(:,:,2);
obj_names.new(:,:,4)=obj_names.pred(:,:,4);

% Put new into old
obj_names.pred(:,:,2)=temp(:,:,2);
obj_names.pred(:,:,4)=temp(:,:,4);

%% Save
save('obj_names.mat', 'obj_names')
