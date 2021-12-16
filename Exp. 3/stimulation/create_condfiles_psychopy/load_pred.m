%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------

%% Prediction phase

%%% Select the appropriate stimuli based on subject number (counterbalance)
% Scenes categories (1 beach, 2 dessert, 3 mountain, 4 road).
if CB_lvl_list==1
    pred.sel_scns_tag={'beach';'desert';'mountain';'savannah';'seabed';'road';};
    pred.sel_cats=repmat(objCats,3,1);
elseif CB_lvl_list==2
    pred.expDes(:,2)=pred.expDes(:,2)+2;
    pred.expDes(pred.expDes(:,2)==7,2)=1;pred.expDes(pred.expDes(:,2)==8,2)=2;
    pred.sel_scns_tag={'mountain';'savannah';'seabed';'road';'beach';'desert';};
    pred.sel_cats=repmat(objCats(end:-1:1),3,1);
elseif CB_lvl_list==3
    pred.expDes(:,2)=pred.expDes(:,2)+4;
    pred.expDes(pred.expDes(:,2)==7,2)=1;pred.expDes(pred.expDes(:,2)==8,2)=2;
    pred.expDes(pred.expDes(:,2)==9,2)=3;pred.expDes(pred.expDes(:,2)==10,2)=4;
    pred.sel_scns_tag={'seabed';'road';'beach';'desert';'mountain';'savannah';};
    pred.sel_cats=repmat(objCats,3,1);
elseif CB_lvl_list==4
    pred.sel_scns_tag={'beach';'desert';'mountain';'savannah';'seabed';'road';};
    pred.sel_cats=repmat(objCats(end:-1:1),3,1);
elseif CB_lvl_list==5
    pred.expDes(:,2)=pred.expDes(:,2)+2;
    pred.expDes(pred.expDes(:,2)==7,2)=1;pred.expDes(pred.expDes(:,2)==8,2)=2;
    pred.sel_scns_tag={'mountain';'savannah';'seabed';'road';'beach';'desert';};
    pred.sel_cats=repmat(objCats,3,1);
end

% Objects
if CB_lvl_list==2 || CB_lvl_list ==4 
    pred.sel_objs=obj_names.pred(:,:,CB_lvl_list);
else
    pred.sel_objs=obj_names.pred(:,end:-1:1,CB_lvl_list);
end
    
% When are the filler trials presented?
fill_cat1_ind=pred.expDes(:,4)==1 & pred.expDes(:,7)==2;
fill_cat2_ind=pred.expDes(:,4)==2 & pred.expDes(:,7)==2;

% Select filler objects
clear temp
pred.filler_objs=pred.sel_objs(1:20,:);
pred.target_objs=pred.sel_objs(21:end,:);
temp(fill_cat1_ind)=[
repmat(pred.filler_objs(1:5,1),pred.repFillers(1),1);...
repmat(pred.filler_objs(6:10,1),pred.repFillers(1),1);...
repmat(pred.filler_objs(11:15,1),pred.repFillers(3),1);...
repmat(pred.filler_objs(16:20,1),pred.repFillers(5),1);...
];
temp(fill_cat2_ind)=[
repmat(pred.filler_objs(1:5,2),pred.repFillers(2),1);...
repmat(pred.filler_objs(6:10,2),pred.repFillers(2),1);...
repmat(pred.filler_objs(11:15,2),pred.repFillers(4),1);...
repmat(pred.filler_objs(16:20,2),pred.repFillers(6),1);
];

% When are the target trials presented?
target_cat1_ind=pred.expDes(:,4)==1 & pred.expDes(:,7)==1;
target_cat2_ind=pred.expDes(:,4)==2 & pred.expDes(:,7)==1;

% Select target objects
temp(target_cat1_ind)=pred.target_objs(:,1);
temp(target_cat2_ind)=pred.target_objs(:,2);

% Store 
pred.trial_ObjInst=temp';

%% Store objects on separate variables. We want objects to be coded as a
% function of their condition on the prediction phase. This is useful for
% the following phase.
'Arranging stimuli according to conditions... This may take a bit.'

% First we need a bunch of counters to make every cross between conditions
% and categories independent from each other
cat1C=1;cat2C=1;
cWeakMism1=1;cWeakMatch1=1;cStrongMism1=1;cStrongMatch1=1;
cWeakMism2=1;cWeakMatch2=1;cStrongMism2=1;cStrongMatch2=1;

% Loop through trials to select the correct filenames with the full path
for cTrial=1:pred.nTrials
    
    % Get this trial's info
    pred.trial_ObjCat{cTrial}=pred.sel_cats{pred.expDes(cTrial,4)};

    % Get stim names
    pred.obj_file{cTrial}=['stim/objects/',pred.trial_ObjCat{cTrial},...
        '/', pred.trial_ObjInst{cTrial},'.png'];
    pred.scn_file{cTrial}=['stim/',...
        num2str(pred.expDes(cTrial,2)), num2str(pred.expDes(cTrial,3)),'.jpeg'];
end
