%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------

%% Learning phase

%%% Select the appropriate stimuli based on subject number (counterbalance) %
% Scenes categories (1 beach, 2 dessert, 3 mountain, 4 road).
if mod(p.subjectcode,2)==1
    learn.sel_scns=['1';'2';'3';'4'];
    learn.sel_scns_tag={'beach';'desert';'mountain';'road'};
elseif mod(p.subjectcode,2)==0
    learn.sel_scns=['3';'4';'1';'2'];
    learn.sel_scns_tag={'mountain';'road';'beach';'desert';};
end

% Objects
avail_cat=1:learn.nObjectCat;
learn.sel_cats=repmat([objCats(CB_lvl_cat);objCats(avail_cat~=CB_lvl_cat)],2,1);
learn.sel_objs=[obj_names.learn(:,CB_lvl_cat,CB_lvl_list),...
    obj_names.learn(:,avail_cat~=CB_lvl_cat,CB_lvl_list)];


% Get stim names
for cTrial=1:learn.nTrials
    
    % Reset variables for this particular trial
%     current_scn=randi(learn.nTrials);
    curr_obj=randi(8);
    
    % Select the appropriate stims for this trial
    learn.trial_ScnCond(cTrial)=learn.expDes(cTrial,1); % Current scene condition
    learn.trial_ScnCat(cTrial)=learn.expDes(cTrial,2); % Current scene category
    learn.trial_ScnInst(cTrial)=learn.expDes(cTrial,3); % Current scene instance
    learn.trial_ObjCat(cTrial)=learn.expDes(cTrial,4); % Current object cat
    learn.trial_ObjCat_label{cTrial}=learn.sel_cats{learn.expDes(cTrial,4)}; % Current object cat
    learn.trial_condition(cTrial)=learn.expDes(cTrial,5); % Current scene condition
    learn.trial_ObjPos(cTrial)=learn.expDes(cTrial,6); % Current object position
    
    learn.scn_file{cTrial}=['stim/',...
        num2str(learn.trial_ScnCat(cTrial)), num2str(learn.trial_ScnInst(cTrial)),'.jpeg'];
    learn.obj_file{cTrial}=['stim/objects/',num2str(learn.sel_cats{learn.trial_ObjCat(cTrial)}),...
        '/', learn.sel_objs{curr_obj,learn.trial_ObjCat(cTrial)},'.png'];
    
end

% Create a nice small matrix for future usage. It points at the
% non-preferred category
learn.check_mat=learn.sel_cats;
learn.check_mat(:,2)=learn.sel_scns_tag;

% Store parameters for future usage
p.learn=learn;
