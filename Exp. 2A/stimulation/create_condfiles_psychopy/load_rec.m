%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------

%% Recognition memory phase.
% We will create a long list with all the stimuli and then split it in half
% for the two memory tests (1 day lagged).

rec.objs_weakMism=pred.objs_weakMism;
rec.objs_weakMatch=pred.objs_weakMatch;
rec.objs_strongMatch=pred.objs_strongMatch;
rec.objs_strongMism=pred.objs_strongMism;
rec.objs_new=[obj_names.new(:,CB_lvl_cat,CB_lvl_list),...
    obj_names.new(:,avail_cat~=CB_lvl_cat,CB_lvl_list)];

% First we need a bunch of counters to make every cross between conditions
% and categories independent from each other
cat1C=1;cat2C=1;count1=1;count2=1;
cWeakMism1=1;cWeakMatch1=1;cStrongMism1=1;cStrongMatch1=1;cNew1=1;
cWeakMism2=1;cWeakMatch2=1;cStrongMism2=1;cStrongMatch2=1;cNew2=1;

% This is a monstrous loop that does the same thing as the previous one but
% for the memory phase.

for cTrial=1:rec.nTrials
    
    % Select the appropriate matrix for the two memory phases.
    % All of the objects are put together in the same variables. Will
    % select the first half for the first mem test and the second for the
    % second one.
    if cTrial<=rec.nTrials/2
        temp_row=rec.expDes1(count1,:);
        count1=count1+1;
    else
        temp_row=rec.expDes2(count2,:);
        count2=count2+1;
    end
    
    % Get this trial's info
    rec.trialCat{cTrial}=pred.sel_cats{temp_row(1,2)};
    rec.trialCond(cTrial)=temp_row(1,1);
    
    % Get this trial's object name and store it in a condXcat variable
    if temp_row(1,1)==3 % weak mismatch
        if temp_row(1,2)==1 % Cat 1
            rec.trialObj(cTrial)=rec.objs_weakMism(cWeakMism1,1);
            cWeakMism1=cWeakMism1+1;
        elseif temp_row(1,2)==2 % Cat 2
            rec.trialObj(cTrial)=rec.objs_weakMism(cWeakMism2,2);
            cWeakMism2=cWeakMism2+1;
        end
    elseif temp_row(1,1)==2 % % weak match
        if temp_row(1,2)==1 % Cat 1
            rec.trialObj(cTrial)=rec.objs_weakMatch(cWeakMatch1,1);
            cWeakMatch1=cWeakMatch1+1;
        elseif temp_row(1,2)==2 % Cat 2
            rec.trialObj(cTrial)=rec.objs_weakMatch(cWeakMatch2,2);
            cWeakMatch2=cWeakMatch2+1;
        end
    elseif temp_row(1,1)==4 % strong mismatch
        if temp_row(1,2)==1 % Cat 1
            rec.trialObj(cTrial)=rec.objs_strongMism(cStrongMism1,1);
            cStrongMism1=cStrongMism1+1;
        elseif temp_row(1,2)==2 % Cat 2
            rec.trialObj(cTrial)=rec.objs_strongMism(cStrongMism2,2);
            cStrongMism2=cStrongMism2+1;
        end
    elseif temp_row(1,1)==1 % strong match
        if temp_row(1,2)==1 % Cat 1
            rec.trialObj(cTrial)=rec.objs_strongMatch(cStrongMatch1,1);
            cStrongMatch1=cStrongMatch1+1;
        elseif temp_row(1,2)==2 % Cat 2
            rec.trialObj(cTrial)=rec.objs_strongMatch(cStrongMatch2,2);
            cStrongMatch2=cStrongMatch2+1;
        end
    elseif temp_row(1,1)==5 % New
        if temp_row(1,2)==1 % Cat 1
            rec.trialObj(cTrial)=rec.objs_new(cNew1,1);
            cNew1=cNew1+1;
        elseif temp_row(1,2)==2 % Cat 2
            rec.trialObj(cTrial)=rec.objs_new(cNew2,2);
            cNew2=cNew2+1;
        end
    end
    
    % Get stim names
    rec.obj_file{cTrial}=['stim/objects/',rec.trialCat{cTrial},...
        '/', rec.trialObj{cTrial},'.png'];
    pred_indx=find(strcmpi(rec.trialObj{cTrial},pred.trial_ObjInst));
    if isempty(pred_indx)
        rec.scn_file{cTrial}='';
        rec.corr_scn(cTrial)=0;rec.corr_scn_file{cTrial}='';
        rec.corr_loc(cTrial)=0;
    else
        rec.scn_file{cTrial}=['stim/',...
            num2str(pred.trial_ScnCat(pred_indx)),'.png'];
        rec.corr_scn(cTrial)=pred.trial_ScnCat(pred_indx);
        rec.corr_scn_file{cTrial}=['stim/',...
            num2str(pred.trial_ScnCat(pred_indx)),...
            num2str(pred.trial_ScnInst(pred_indx)),...
            '.jpeg'];
        rec.corr_loc(cTrial)=pred.trial_ObjPos(pred_indx);
    end
end
