%% Project PREMUP: Prediction Error and Memory updating
% Design set up and definition of important variables
% ----------------------------------------------------------

% Prediction verification phase %
%% Define parameters
% ----------------------------------------------------------

pred.nConditions = 2;                      % number of conditions
pred.nCont_perCond = 2;                    % number of contexts per condition
pred.nCont=pred.nConditions*pred.nCont_perCond;
pred.nContInst=4;
pred.nTrials_perCont_weakPriors = 40;       % number of trials per context type
pred.nTrials_weakPriors = pred.nTrials_perCont_weakPriors * ...
    pred.nCont_perCond;                % number of trials on the weak prior condition
pred.nTrials_perCont_strongPriors = 40;    % number of trials per context type
pred.nTrials_strongPriors = pred.nTrials_perCont_strongPriors * ...
    pred.nCont_perCond;                % number of trials on the weak prior condition
pred.nTrials = pred.nTrials_weakPriors + pred.nTrials_strongPriors; % nTrials total
if mod(p.subjectcode,2)==1
    pred.priors=[.5,.5;...
        .5,.5;...
        .5,.5;...
        .5,.5]; % contingencies for the two types of contexts
elseif mod(p.subjectcode,2)==0
    pred.priors=[.5,.5;...
        .5,.5;...
        .5,.5;...
        .5,.5]; % contingencies for the two types of contexts
end
pred.numbers=[round(pred.priors(1,:)*pred.nTrials_perCont_weakPriors);...
    round(pred.priors(2,:)*pred.nTrials_perCont_weakPriors);...
    round(pred.priors(3,:)*pred.nTrials_perCont_strongPriors);...
    round(pred.priors(4,:)*pred.nTrials_perCont_strongPriors);...
    ]; % instances for the two types of contexts
pred.nObjectCat = 2;                       % number of objects categories
pred.nObject_perCat = 80;                  % number of objects per category
pred.fixTime = .5;                         % fixation duration (secs)
pred.predTime = 2;                         % prediction duration (secs)
pred.objTime = 3;                          % object on-screen time (secs)
pred.fbDur = 1;                            % feedback duration (secs)

%% Experimental design.
% ----------------------------------------------------------

% Exp structure. Trials X variables (context type/context instance/obj cond/
% trial type)
pred.expDes(:,1)=[repmat(1,pred.nTrials_weakPriors,1);...
    repmat(2,pred.nTrials_strongPriors,1)]; % Context type (1 weak, 2 strong)
pred.expDes(:,2)=[
    repmat(1,pred.nTrials_weakPriors/2,1);...
    repmat(2,pred.nTrials_weakPriors/2,1);...
    repmat(3,pred.nTrials_strongPriors/2,1);...
    repmat(4,pred.nTrials_strongPriors/2,1)]; % Scene category (e.g., beach, mountain, etc.)
pred.expDes(:,3)=repmat(1:4,1,pred.nTrials/4); % Scene instance (e.g., beach1, beach2, etc.)
temp=[];c=1;
for i=1:length(pred.numbers)
    for j=1:pred.nObjectCat
        temp=[temp;repmat(j,pred.numbers(i,j),1)];
        c=c+1;
    end
end
pred.expDes(:,4)=temp; % Object category
pred.expDes(:,5)=[
    repmat(3,pred.nTrials_perCont_weakPriors*pred.priors(1,1),1);... 
    repmat(2,pred.nTrials_perCont_weakPriors*pred.priors(1,2),1);...
    repmat(2,pred.nTrials_perCont_weakPriors*pred.priors(2,1),1);...
    repmat(3,pred.nTrials_perCont_weakPriors*pred.priors(2,2),1);...
    repmat(4,pred.nTrials_perCont_strongPriors*pred.priors(3,1),1);...
    repmat(1,pred.nTrials_perCont_strongPriors*pred.priors(3,2),1);...
    repmat(1,pred.nTrials_perCont_strongPriors*pred.priors(4,1),1);...
    repmat(4,pred.nTrials_perCont_strongPriors*pred.priors(4,2),1)
    ]; % PE level
temp=repmat(1:4,1,pred.nTrials/4');
pred.expDes(:,6)=temp(randperm(pred.nTrials)); % Screen quadrant in which the object is appearing

if pD
    figure(desFig)
    subplot(2,3,2), imagesc(pred.expDes)
    xticks([1:6]);xticklabels({'Cont type';'Scn categ'; 'Scn instance'; 'Obj cat';'Trial cond';'Quadrant'})
    xtickangle(45);title('Pred Phase');ylabel('Trials')
end
