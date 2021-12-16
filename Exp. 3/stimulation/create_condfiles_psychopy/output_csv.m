%% Create tables for outputting csv files

% Where are the experiment folders for Pavlovia?
exp_folder='/home/javier/pavlovia';
% exp_folder='C:\Users\Javier\Documents\pavlovia';
%% Learning phase
% Turn positions into Psychopy terms
psych_posX={};
psych_posY={};
for i=1:length(learn.expDes(:,6))
    if learn.expDes(i,6)==1
        psych_posX(i,:)={'-.2'};
        psych_posY(i,:)={'.15'};
    elseif learn.expDes(i,6)==2
        psych_posX(i,:)={'.2'};
        psych_posY(i,:)={'.15'};
    elseif learn.expDes(i,6)==3
        psych_posX(i,:)={'-.2'};
        psych_posY(i,:)={'-.15'};
    elseif learn.expDes(i,6)==4
        psych_posX(i,:)={'.2'};
        psych_posY(i,:)={'-.15'};
    end
end
corr_resp=[];
for i=1:length(learn.expDes(:,4))
    if learn.expDes(i,4)==1
        corr_resp{i}={'left'};
    elseif learn.expDes(i,4)==2
        corr_resp{i}={'right'};
    end
end
tabledata=[];
learn.header = {'scn_condition'; 'scn_cat'; 'scn_inst'; 'scn_file';...
    'obj_cat'; 'obj_cat_num'; 'obj_file';'trial_cond'; 'quadrant';'obj_x';'obj_y';'corr_ans'};
tabledata=[
    num2cell(learn.expDes(:,1)),...
    num2cell(learn.expDes(:,2)),...
    num2cell(learn.expDes(:,3)),...
    num2cell(learn.scn_file)',...
    num2cell(learn.trial_ObjCat_label)',...
    num2cell(learn.expDes(:,4)),...
    num2cell(learn.obj_file)',...
    num2cell(learn.expDes(:,5)),...
    num2cell(learn.expDes(:,6)),...
    psych_posX,...
    psych_posY,...
    corr_resp'
    ];
learn.table = array2table(tabledata, 'VariableNames', learn.header);
writetable(learn.table, [...
    exp_folder, '/premup-three_ses-01_part-01_label-phase1/condition_files/', ...
    num2str(p.subjectcode), '_phase1.csv'])
writetable(learn.table, [...
    exp_folder, '/premup-three_ses-02_part-02_label-phase2/condition_files/', ...
    num2str(p.subjectcode), '_phase1.csv'])

%% Prediction phase
% Turn positions into Psychopy terms
psych_pos={};
for i=1:length(pred.expDes(:,6))
    if pred.expDes(i,6)==1
        psych_posX(i,:)={'-.2'};
        psych_posY(i,:)={'.15'};
    elseif pred.expDes(i,6)==2
        psych_posX(i,:)={'.2'};
        psych_posY(i,:)={'.15'};
    elseif pred.expDes(i,6)==3
        psych_posX(i,:)={'-.2'};
        psych_posY(i,:)={'-.15'};
    elseif pred.expDes(i,6)==4
        psych_posX(i,:)={'.2'};
        psych_posY(i,:)={'-.15'};
    end
end


for i=1:length(pred.expDes(:,4))
    if pred.expDes(i,4)==1
        corr_resp{i}={'left'};
    elseif pred.expDes(i,4)==2
        corr_resp{i}={'right'};
    end
end
tabledata=[];

pred.header = {'scn_condition';'scn_cat'; 'scn_inst'; 'scn_file';...
    'obj_cat_num'; 'obj_cat'; 'obj_file';'trial_cond';'quadrant';'fillers';'obj_x';'obj_y';'corr_ans'};
tabledata=[
    num2cell(pred.expDes(:,1)),...
    num2cell(pred.expDes(:,2)),...
    num2cell(pred.expDes(:,3)),...
    num2cell(pred.scn_file)',...
    num2cell(pred.expDes(:,4)),...
    (pred.trial_ObjCat)',...
    num2cell(pred.obj_file)',...
    num2cell(pred.expDes(:,5)),...
    num2cell(pred.expDes(:,6)),...
    num2cell(pred.expDes(:,7)),...
    psych_posX,...
    psych_posY,...
    corr_resp'
    ];
pred.table = array2table(tabledata, 'VariableNames', pred.header);
writetable(pred.table, [...
    exp_folder, '/premup-three_ses-02_part-02_label-phase2/condition_files/', ...
    num2str(p.subjectcode), '_phase2.csv'])

%% Recognition phase

rec.header = {
    'context_type'; 'object_cat';'PE_level';'OvsN';...
    'obj_file';'scn_file';'corr_scn_cat';'assoc_file';'corr_scn_inst';'corr_loc'};
for i=1:length(rec.corr_scn_cat)
    assoc_file{i}=['stim/',num2str(rec.corr_scn_cat(i)),'.png'];
end
tabledata=[num2cell(rec.expDes),...
    num2cell(rec.obj_file),...
    num2cell(rec.scn_file),...
    num2cell(rec.corr_scn_cat),...
    assoc_file',...
    num2cell(rec.corr_scn_inst),...
    num2cell(rec.corr_loc)
    ];
rec.table = array2table(tabledata, 'VariableNames', rec.header);
writetable(rec.table, [...
    exp_folder, '/premup-three_ses-02_part-03_label-phase3/condition_files/',...
    num2str(p.subjectcode), '_phase3.csv'])

%% Priors table
prior.header = {'scn_cat'; 'scn_file';...
    'obj_cat_top'; 'min_resp_top'; 'max_resp_top';...
    'obj_cat_bottom'; 'min_resp_bottom'; 'max_resp_bottom'};
c=1;
for i=1:6
    % Select prior level. CB the position
    if i==1 || i==4 || i== 5
        tmp_top(i)=learn.priors(i,1);
        tmp_bottom(i)=learn.priors(i,2);
    elseif i==2 || i==3 || i==6
        tmp_bottom(i)=learn.priors(i,1);
        tmp_top(i)=learn.priors(i,2);
    end
    
    scn_tmp{i}=i;
    
    scn_tmp_file{i}=['stim/', num2str(scn_tmp{i}), '1.jpeg'];
    
end
obj_tmp=learn.check_mat(:,1);

for i=1:length(obj_tmp)
    % Select prior level. CB the position
    if i==1 || i==2 || i == 3
        if strcmpi(obj_tmp{i}, 'Instruments')
            obj_tmp_top{i}='Music items';
            obj_tpm_bottom{i}= 'Household items';
        elseif strcmpi(obj_tmp{i}, 'HouseObjects')
            obj_tmp_top{i}= 'Household items';
            obj_tpm_bottom{i}= 'Music items';
        end
    elseif i==4 || i==5 || i==6
        if strcmpi(obj_tmp{i}, 'Instruments')
            obj_tpm_bottom{i}='Music items';
            obj_tmp_top{i}= 'Household items';
        elseif strcmpi(obj_tmp{i}, 'HouseObjects')
            obj_tpm_bottom{i}= 'Household items';
            obj_tmp_top{i}= 'Music items';
        end
    end
end
tabledata=[
    scn_tmp',...
    num2cell(scn_tmp_file)',...
    num2cell(obj_tmp_top)',...
    num2cell((tmp_top-0.05)*100)',...
    num2cell((tmp_top+0.05)*100)',...
    num2cell(obj_tpm_bottom)',...
    num2cell((tmp_bottom-0.05)*100)',...
    num2cell((tmp_bottom+0.05)*100)',...
    ];
prior.table = array2table(tabledata, 'VariableNames', prior.header);
writetable(prior.table, [...
    exp_folder, '/premup-three_ses-01_part-01_label-phase1/condition_files/', ...
    num2str(p.subjectcode), '_priors.csv'])
writetable(prior.table, [...
    exp_folder, '/premup-three_ses-02_part-02_label-phase2/condition_files/', ...
    num2str(p.subjectcode), '_priors.csv'])
