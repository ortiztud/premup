%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------

%% Learning phase

%%% Select the appropriate stimuli based on subject number (counterbalance)
% Scenes categories (1 beach, 2 dessert, 3 mountain, 4 road).
if CB_lvl_list==1
    learn.sel_scns_tag={'beach';'desert';'mountain';'savannah';'seabed';'road';};
    learn.sel_cats=repmat(objCats,3,1);
elseif CB_lvl_list==2
    learn.expDes(:,2)=learn.expDes(:,2)+2;
    learn.expDes(learn.expDes(:,2)==7,2)=1;learn.expDes(learn.expDes(:,2)==8,2)=2;
    learn.sel_scns_tag={'mountain';'savannah';'seabed';'road';'beach';'desert';};
    learn.sel_cats=repmat(objCats(end:-1:1),3,1);
elseif CB_lvl_list==3
    learn.expDes(:,2)=learn.expDes(:,2)+4;
    learn.expDes(learn.expDes(:,2)==7,2)=1;learn.expDes(learn.expDes(:,2)==8,2)=2;
    learn.expDes(learn.expDes(:,2)==9,2)=3;learn.expDes(learn.expDes(:,2)==10,2)=4;
    learn.sel_scns_tag={'seabed';'road';'beach';'desert';'mountain';'savannah';};
    learn.sel_cats=repmat(objCats,3,1);
elseif CB_lvl_list==4
    learn.sel_scns_tag={'beach';'desert';'mountain';'savannah';'seabed';'road';};
    learn.sel_cats=repmat(objCats(end:-1:1),3,1);
elseif CB_lvl_list==5
    learn.expDes(:,2)=learn.expDes(:,2)+2;
    learn.expDes(learn.expDes(:,2)==7,2)=1;learn.expDes(learn.expDes(:,2)==8,2)=2;
    learn.sel_scns_tag={'mountain';'savannah';'seabed';'road';'beach';'desert';};
    learn.sel_cats=repmat(objCats,3,1);
end

% Objects themselves as well as the object category are counterbalanced
if CB_lvl_list==2 || CB_lvl_list ==4 
    learn.sel_objs=obj_names.learn(:,:,CB_lvl_list);
else
    learn.sel_objs=obj_names.learn(:,end:-1:1,CB_lvl_list);
end
    
% Get stim names
% First I will create a long list with multiple instances of the same
% objects to reach the desired repetitions. Only 4 tokens are used for
% every cell.
learn.obj_name=[
repmat(learn.sel_objs(1:4,1),learn.numbers(1,1)/4,1);repmat(learn.sel_objs(1:4,2),learn.numbers(1,2)/4,1);
repmat(learn.sel_objs(5:8,1),learn.numbers(2,1)/4,1);repmat(learn.sel_objs(5:8,2),learn.numbers(2,2)/4,1);
repmat(learn.sel_objs(9:12,1),learn.numbers(3,1)/4,1);repmat(learn.sel_objs(9:12,2),learn.numbers(3,2)/4,1);
repmat(learn.sel_objs(13:16,1),learn.numbers(4,1)/4,1);repmat(learn.sel_objs(13:16,2),learn.numbers(4,2)/4,1);
repmat(learn.sel_objs(17:20,1),learn.numbers(5,1)/4,1);repmat(learn.sel_objs(17:20,2),learn.numbers(5,2)/4,1);
repmat(learn.sel_objs(21:24,1),learn.numbers(6,1)/4,1);repmat(learn.sel_objs(21:24,2),learn.numbers(6,2)/4,1)];

c=1;d=1;
for cTrial=1:learn.nTrials
    
    if c==24
        c=1;
    end
    if d==24
        d=1;
    end
    % Reset variables for this particular trial
%     curr_obj=randi(24);
    
    % Select the appropriate stims for this trial
    %     learn.trial_ScnCond(cTrial)=learn.expDes(cTrial,1); % Current scene condition
    %     learn.trial_ScnCat(cTrial)=learn.expDes(cTrial,2); % Current scene category
    %     learn.trial_ScnInst(cTrial)=learn.expDes(cTrial,3); % Current scene instance
    %     learn.trial_ObjCat(cTrial)=learn.expDes(cTrial,4); % Current object cat
    learn.trial_ObjCat_label{cTrial}=learn.sel_cats{learn.expDes(cTrial,4)}; % Current object cat
    %     learn.trial_condition(cTrial)=learn.expDes(cTrial,5); % Current scene condition
    %     learn.trial_ObjPos(cTrial)=learn.expDes(cTrial,6); % Current object position
    
    learn.scn_file{cTrial}=['stim/',...
        num2str(learn.expDes(cTrial,2)), num2str(learn.expDes(cTrial,3)),'.jpeg'];
%     if learn.expDes(cTrial,4)==1
%         learn.obj_name{cTrial}=learn.sel_objs{c,learn.expDes(cTrial,4)};
%         c=c+1;
%     elseif learn.expDes(cTrial,4)==2
%         learn.obj_name{cTrial}=learn.sel_objs{d,learn.expDes(cTrial,4)};
%         d=d+1;
%     end
    learn.obj_file{cTrial}=['stim/objects/',num2str(learn.sel_cats{learn.expDes(cTrial,4)}),...
        '/', learn.obj_name{cTrial},'.png'];
    
end

% Create a nice small matrix for future usage. It points at the
% non-preferred category
learn.check_mat=learn.sel_cats;
learn.check_mat(:,2)=learn.sel_scns_tag;

% Store parameters for future usage
p.learn=learn;
