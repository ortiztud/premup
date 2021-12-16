%% Project PREMUP: Prediction Error and Memory updating
% ----------------------------------------------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Javier Ortiz-Tudela
% ortiztudela@psych.uni-frankfurt.com
% LISCO Lab - Goethe Universitat
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Additional info %%%
% Thi task aims at exploring the relationship between prediction error and
% memory formation. The overall study is structure in three phases: 1)
% contingency learning, prediction verification and memory test.
%%%%%%%%%%%%%%%%%%%%%%%

%% Clean everything and define task name
clear; close all
p.taskName= 'premup_three';

%% Define whether test or experimental session and whether plotting the design is ok.
% ----------------------------------------------------------
% Plot design matrix
pD=0;

% Loop through CB lists
for CB_level =1:5
    p.subjectcode = CB_level;
    
    %% Initialize experiment
    % ----------------------------------------------------------
    %%% Contingency learning phase
    run params_learn.m
    
    %%% Prediction verification phase
    run params_pred.m
    
    %%% Recognition memory phase
    run params_rec.m
    
    run loadStim.m
    
    %% Create csv outputs params to use them in the PsychoPy
    run output_csv.m
end