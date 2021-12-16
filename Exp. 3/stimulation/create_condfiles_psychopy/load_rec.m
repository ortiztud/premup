%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------

%% Recognition memory phase.
temp=[];c=1;d=1;
% Create new object files
for i=1:100
    if CB_lvl_list==2 || CB_lvl_list ==4
        if rec.expDes(i,2)==1
            temp{i}=obj_names.new{c,1,CB_lvl_list};c=c+1;
        else
            temp{i}=obj_names.new{d,2,CB_lvl_list};d=d+1;
        end
    else
        if rec.expDes(i,2)==1
            temp{i}=obj_names.new{c,2,CB_lvl_list};c=c+1;
        else
            temp{i}=obj_names.new{d,1,CB_lvl_list};d=d+1;
        end
    end
    rec.trial_ObjCat{i}=pred.sel_cats{rec.expDes(i,2)};
    new_names{i}= ['stim/objects/',rec.trial_ObjCat{i},...
        '/', temp{i},'.png'];
end
% We can take the objects directly from the prediction phase since no
% randomization has been done yet. In order to check the coding of the PE
% level run rec.trial_PElevel=pred.expDes(pred.expDes(:,7)==1,5) and
% compare it to rec.expDes(:,3)
rec.trial_ObjInst=pred.trial_ObjInst(pred.expDes(:,7)==1);
rec.obj_file=[pred.obj_file(pred.expDes(:,7)==1)';...
    new_names'];
rec.scn_file=[pred.scn_file(pred.expDes(:,7)==1)';...
    num2cell(repmat(0,100,1))];

% Get encoding details
rec.corr_scn_cat=[pred.expDes(pred.expDes(:,7)==1,2);zeros(100,1)];
rec.corr_scn_inst=[pred.expDes(pred.expDes(:,7)==1,3);zeros(100,1)];
rec.corr_loc=[pred.expDes(pred.expDes(:,7)==1,6);zeros(100,1)];

if pD
    figure(desFig)
    subplot(2,3,3), imagesc(rec.expDes)
    xticks([1:6]);xticklabels({'Cont type';'Obj cat';'PE level';'OvsN'})
    xtickangle(45);title('Pred Phase');ylabel('Trials')
end
