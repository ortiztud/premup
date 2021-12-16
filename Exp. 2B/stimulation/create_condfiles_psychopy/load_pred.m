%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------

%% Prediction phase

%%% Select the appropriate ones based on subject number (counterbalance)
% Objects
avail_cat=1:pred.nObjectCat;
pred.sel_cats=[objCats(CB_lvl_cat);objCats(avail_cat~=CB_lvl_cat)];
pred.sel_objs=[obj_names.pred(:,CB_lvl_cat,CB_lvl_list),...
    obj_names.pred(:,avail_cat~=CB_lvl_cat,CB_lvl_list)];

% Randomize object order
pred.sel_objs=pred.sel_objs(randperm(pred.nObject_perCat),:);

% Randomize trial order. This is a very non-elegant way of doing it.
try_again=1;
while try_again==1
    'Randomizing...'
    conditions=pred.expDes(:,5);
    
    ind=randi(numel(conditions));trial_cond=conditions(ind);conditions(ind)=[];
    for i=2:pred.nTrials
        win=0;
        while win==0
            ind=randi(numel(conditions));
            trial_cond(i)=conditions(ind);
            if trial_cond(i)==trial_cond(i-1)
                if mean(conditions)==unique(conditions)
                    try_again=1;
                    break
                end
                win=0;
            else
                if i==160
                    try_again=0;
                end
                win=1;
            end
        end
        conditions(ind)=[];
    end
end
ind=[];
for i=1:4
    ind{i}=find(pred.expDes(:,5)==i);
end
counter=ones(4,1);
for i=1:pred.nTrials
    trial_order(i)=ind{trial_cond(i)}(counter(trial_cond(i)));
    counter(trial_cond(i))=counter(trial_cond(i))+1;
end
pred.expDes=pred.expDes(trial_order,:);

%% Store objects on separate variables. We want objects to be coded as a
% function of their condition on the prediction phase. This is useful for
% the following phase.
'Arranging stimuli according to conditions... This may take a bit.'

% First we need a bunch of counters to make every cross between conditions
% and categories independent from each other
cat1C=1;cat2C=1;
cWeakMism1=1;cWeakMatch1=1;cStrongMism1=1;cStrongMatch1=1;
cWeakMism2=1;cWeakMatch2=1;cStrongMism2=1;cStrongMatch2=1;

% This is a monstrous loop that goes through the every trial and stores the
% appropriate trial type (condXcateg) in different variables. The order of
% these objects has already been shuffled above so they can be picked
% one by one.
for cTrial=1:pred.nTrials
    
    % Get this trial's info
    pred.trial_ScnCat(cTrial)=pred.expDes(cTrial,2);
    pred.trial_ScnInst(cTrial)=pred.expDes(cTrial,3);
    pred.trial_ObjCat{cTrial}=pred.sel_cats{pred.expDes(cTrial,4)};
    pred.trial_ObjCat_num{cTrial}=pred.expDes(cTrial,4);
    pred.trial_condition(cTrial)=pred.expDes(cTrial,5);
    pred.trial_ObjPos(cTrial)=pred.expDes(cTrial,6);
    
    % Get this trial's object name and store it in a condXcat variable
    if pred.expDes(cTrial,5)==3 % weak mismatch
        if pred.expDes(cTrial,4)==1 % Cat 1
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat1C,1);
            pred.objs_weakMism(cWeakMism1,1)=pred.trial_ObjInst(cTrial);
            cat1C=cat1C+1;cWeakMism1=cWeakMism1+1;
        elseif pred.expDes(cTrial,4)==2 % Cat 2
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat2C,2);
            pred.objs_weakMism(cWeakMism2,2)=pred.trial_ObjInst(cTrial);
            cat2C=cat2C+1;cWeakMism2=cWeakMism2+1;
        end
    elseif pred.expDes(cTrial,5)==2 % weak match
        if pred.expDes(cTrial,4)==1 % Cat 1
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat1C,1);
            pred.objs_weakMatch(cWeakMatch1,1)=pred.trial_ObjInst(cTrial);
            cat1C=cat1C+1;cWeakMatch1=cWeakMatch1+1;
        elseif pred.expDes(cTrial,4)==2 % Cat 2
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat2C,2);
            pred.objs_weakMatch(cWeakMatch2,2)=pred.trial_ObjInst(cTrial);
            cat2C=cat2C+1;cWeakMatch2=cWeakMatch2+1;
        end
    elseif pred.expDes(cTrial,5)==4 % strong mismatch
        if pred.expDes(cTrial,4)==1 % Cat 1
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat1C,1);
            pred.objs_strongMism(cStrongMism1,1)=pred.trial_ObjInst(cTrial);
            cat1C=cat1C+1;cStrongMism1=cStrongMism1+1;
        elseif pred.expDes(cTrial,4)==2 % Cat 2
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat2C,2);
            pred.objs_strongMism(cStrongMism2,2)=pred.trial_ObjInst(cTrial);
            cat2C=cat2C+1;cStrongMism2=cStrongMism2+1;
        end
    elseif pred.expDes(cTrial,5)==1 % strong match
        if pred.expDes(cTrial,4)==1 % Cat 1
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat1C,1);
            pred.objs_strongMatch(cStrongMatch1,1)=pred.trial_ObjInst(cTrial);
            cat1C=cat1C+1;cStrongMatch1=cStrongMatch1+1;
        elseif pred.expDes(cTrial,4)==2 % Cat 2
            pred.trial_ObjInst(cTrial)=pred.sel_objs(cat2C,2);
            pred.objs_strongMatch(cStrongMatch2,2)=pred.trial_ObjInst(cTrial);
            cat2C=cat2C+1;cStrongMatch2=cStrongMatch2+1;
        end
    end
    
    % Get stim names
    pred.obj_file{cTrial}=['stim/objects/',pred.trial_ObjCat{cTrial},...
        '/', pred.trial_ObjInst{cTrial},'.png'];
    pred.scn_file{cTrial}=['stim/',...
        num2str(pred.trial_ScnCat(cTrial)), num2str(pred.trial_ScnInst(cTrial)),'.jpeg'];
    
end