%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------

%% Define global important variables
sceneSizeX = 1024;   % scene size horizontally in pixels
sceneSizeY = 768;    % scene size vertically in pixels

% Conditions
contextConditions={'Weak prior';'Strong prior'};
objCats={'HouseObjects';'Instruments';};

% Load stimuli names
load 'obj_names.mat'

% Select which objects go to which phase based on subject number
CB_lvl_cat=mod(p.subjectcode,2)+1;
CB_lvl_list=mod(p.subjectcode,5)+1;

%% Load stim for each phase
% (we do it in separate scripts to avoid a messy-super long script)
run load_learn.m
run load_pred.m
run load_rec.m

%% Store parameters for future usage
p.learn=learn;p.pred=pred;p.rec=rec;

