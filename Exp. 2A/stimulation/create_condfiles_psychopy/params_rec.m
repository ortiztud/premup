%% Project PREMUP: Prediction Error and Memory updating
% Design set up and definition of important variables
% ----------------------------------------------------------

% Recognition memory phase %
%% Define useful variables
% ----------------------------------------------------------
rec.header = {'Trial type'; 'Obj-cat'};
rec.nConditions = 2;                % number of conditions
rec.nTrials_match_strong = pred.nTrials_perCont_strongPriors*pred.priors(4,1)*2;              % number of trials with flat priors
rec.nTrials_match_weak = pred.nTrials_perCont_weakPriors*pred.priors(2,1)*2;               % number of expected trials 
rec.nTrials_mismatch_weak = pred.nTrials_perCont_weakPriors*pred.priors(1,1)*2;             % number of unexpected trials 
rec.nTrials_mismatch_strong = pred.nTrials_perCont_strongPriors*pred.priors(3,1)*2;          % number of repeated trials 
rec.nTrials_new = rec.nTrials_match_weak + rec.nTrials_mismatch_weak ...
    + rec.nTrials_match_strong + rec.nTrials_mismatch_strong; % number of lures
rec.nTrials= rec.nTrials_match_weak + rec.nTrials_mismatch_weak ...
    + rec.nTrials_match_strong + rec.nTrials_mismatch_strong + rec.nTrials_new;% nTrials total
rec.fixTime = .5;                         % fixation duration (secs)
rec.trialDur = 4.5;                         % trial duration (secs)

%% Experimental design.
% ----------------------------------------------------------

% Exp structure. Trials X variables (trial type -1 strong match,2 weak match
% 3 weak mismatch rep, 4 strong mismatch and 5 new-)
rec.expDes(:,1)=[repmat(1,rec.nTrials_match_strong,1);repmat(2,rec.nTrials_match_weak,1);...
    repmat(3,rec.nTrials_mismatch_weak,1);repmat(4,rec.nTrials_mismatch_strong,1);...
    repmat(5,rec.nTrials_new,1)]; % trial type
rec.expDes(:,2)=[sort(repmat(1:2,1,rec.nTrials_match_strong/2)),...
    sort(repmat(1:2,1,rec.nTrials_match_weak/2)),...
    sort(repmat(1:2,1,rec.nTrials_mismatch_weak/2)),...
    sort(repmat(1:2,1,rec.nTrials_mismatch_strong/2)),...
    sort(repmat(1:2,1,rec.nTrials_new/2)),...
    ]; % Object categ

% Split the matrix into two for the two memory phases
 rec.expDes1=rec.expDes(1:2:end,:);
 rec.expDes2=rec.expDes(2:2:end,:);
 
if pD
    figure(desFig)
    subplot(2,3,3), imagesc(rec.expDes)
     xticks([1,2]);xticklabels({'Trial type'; 'Obj categ'})
    xtickangle(45);
    ylabel('Trials')
    title('Mem Phase combined')
    subplot(2,3,4), imagesc(rec.expDes1)
    xticks([1,2]);xticklabels({'Trial type'; 'Obj categ'})
    xtickangle(45);
    ylabel('Trials')
    title('Mem Phase1')
    subplot(2,3,5), imagesc(rec.expDes2)
    xticks([1,2]);xticklabels({'Trial type'; 'Obj categ'})
    xtickangle(45);
    ylabel('Trials')
    title('Mem Phase2 (1 week lag)')
end

% Shuffle rows
% rec.expDes1=rec.expDes1(randperm(rec.nTrials/2),:);
% rec.expDes2=rec.expDes2(randperm(rec.nTrials/2),:);
