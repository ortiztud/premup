%% Project PREMUP: Prediction Error and Memory updating
% Design set up and definition of important variables
% ----------------------------------------------------------

% Recognition memory phase %
%% Define useful variables
% ----------------------------------------------------------
rec.header = {'Trial type'; 'Obj-cat'};
rec.nConditions = 3;                % number of conditions
rec.nTrials_per_cell = 20;
rec.nCont_perCond = 2;
rec.nTrials_old = 100;
rec.nTrials_new = 100; % number of lures
rec.nTrials= rec.nTrials_old + rec.nTrials_new;% nTrials total
rec.priors=pred.priors;
% rec.fixTime = .5;                         % fixation duration (secs)
% rec.trialDur = 4.5;                         % trial duration (secs)

%% Experimental design.
% ----------------------------------------------------------

% Exp structure. Trials X variables
rec.expDes(:,1)=[repmat(1,rec.nTrials_per_cell,1);...
    repmat(2,rec.nTrials_per_cell*rec.nCont_perCond,1);...
    repmat(3,rec.nTrials_per_cell*rec.nCont_perCond,1);
    zeros(100,1)]; % Context type
rec.expDes(:,2)=[repmat(sort(repmat(1:2,1,20/2)),1,10)]; % Object category
rec.expDes(:,3)=[repmat(rec.priors(1,1),20,1);... % Flat
    repmat(rec.priors(3,1),10,1);repmat(rec.priors(3,2),10,1);... % Middle
    repmat(rec.priors(4,1),10,1);repmat(rec.priors(4,2),10,1);... % Middle
    repmat(rec.priors(5,1),10,1);repmat(rec.priors(5,2),10,1);... % Strong
    repmat(rec.priors(6,1),10,1);repmat(rec.priors(6,2),10,1);... % Strong.
    zeros(100,1)]; % PE level
rec.expDes(:,4)=[repmat(1,100,1);repmat(2,100,1)]; %OvsN
 
if pD
    figure(desFig)
    subplot(2,3,3), imagesc(rec.expDes)
     xticks([1:4]);xticklabels({'Context type'; 'Obj categ'; 'PE level';'OvsN'})
    xtickangle(45);
    ylabel('Trials')
    title('Mem Phase')
end
