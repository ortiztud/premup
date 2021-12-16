%% Project PREMUP: Prediction Error and Memory updating
% Design set up and definition of important variables
% ----------------------------------------------------------

% Contingency learning phase %
%% Define parameters
% ----------------------------------------------------------

learn.nConditions = 2;                      % number of conditions
learn.nCont_perCond = 2;                    % number of contexts per condition
learn.nContCat=learn.nConditions*learn.nCont_perCond;
learn.nContInst=4;
learn.nTrials_perCont_weakPriors = 40;       % number of trials per context type
learn.nTrials_weakPriors = learn.nTrials_perCont_weakPriors * ...
    learn.nCont_perCond;                % number of trials on the weak prior condition
learn.nTrials_perCont_strongPriors = 40;    % number of trials per context type
learn.nTrials_strongPriors = learn.nTrials_perCont_strongPriors * ...
    learn.nCont_perCond;                % number of trials on the weak prior condition
learn.nTrials = learn.nTrials_weakPriors + learn.nTrials_strongPriors; % nTrials total
if mod(p.subjectcode,2)==1
    learn.priors=[.5,.5;...
        .5,.5;...
        .1,.9;...
        .9,.1]; % contingencies for the two types of contexts
elseif mod(p.subjectcode,2)==0
    learn.priors=[.1,.9;...
        .9,.1;...
        .5,.5;...
        .5,.5]; % contingencies for the two types of contexts
end
learn.numbers=[round(learn.priors(1,:)*learn.nTrials_perCont_weakPriors);...
    round(learn.priors(2,:)*learn.nTrials_perCont_weakPriors);...
    round(learn.priors(3,:)*learn.nTrials_perCont_weakPriors);...
    round(learn.priors(4,:)*learn.nTrials_perCont_strongPriors);...
    ]; % instances for the two types of contexts
learn.nObjectCat = 2;                       % number of objects categories
learn.nObject_perCat = 8;                  % number of objects per category
learn.fixTime = .5;                         % fixation duration (secs)
learn.trialDur = 2;                         % trial duration (secs)
learn.fbDur = 1;                            % feedback duration (secs)

%% Experimental design.
% ----------------------------------------------------------

% Exp structure. Trials X variables (context type/context instance/trial
% type)
learn.expDes(:,1)=[repmat(1,learn.nTrials_weakPriors,1);...
    repmat(2,learn.nTrials_strongPriors,1)]; % Context type (1 weak, 2 strong)
learn.expDes(:,2)=[
    repmat(1,learn.nTrials_weakPriors/2,1);...
    repmat(2,learn.nTrials_weakPriors/2,1);...
    repmat(3,learn.nTrials_strongPriors/2,1);...
    repmat(4,learn.nTrials_strongPriors/2,1)]; % Scene category (e.g., beach, mountain, etc.)
learn.expDes(:,3)=repmat(1:4,1,learn.nTrials/4); % Scene instance (e.g., beach1, beach2, etc.)
temp=[];
for i=1:length(learn.numbers)
    for j=1:learn.nObjectCat
        temp=[temp;repmat(repmat(j,learn.numbers(i,j)/2,1),2,1)];
    end
end
learn.expDes(:,4)=temp; % Object category (musical instruments, household objects)
learn.expDes(:,5)=[
    repmat(3,learn.nTrials_perCont_weakPriors*learn.priors(1,1),1);... 
    repmat(2,learn.nTrials_perCont_weakPriors*learn.priors(1,2),1);...
    repmat(2,learn.nTrials_perCont_weakPriors*learn.priors(2,1),1);...
    repmat(3,learn.nTrials_perCont_weakPriors*learn.priors(2,2),1);...
    repmat(4,learn.nTrials_perCont_strongPriors*learn.priors(3,1),1);...
    repmat(1,learn.nTrials_perCont_strongPriors*learn.priors(3,2),1);...
    repmat(1,learn.nTrials_perCont_strongPriors*learn.priors(4,1),1);...
    repmat(4,learn.nTrials_perCont_strongPriors*learn.priors(4,2),1)
    ]; % PE level
learn.expDes(:,6)=repmat(1:4,1,learn.nTrials/4'); % Screen quadrant in which the object is appearing

if pD
    desFig=figure;
    subplot(2,3,1),imagesc(learn.expDes)
    xticks([1:5]);xticklabels({'Cont type';'Scn categ'; 'Scn instance'; 'Obj cat';'Quadrant'})
    xtickangle(45);title('Learn Phase');ylabel('Trials')
end

% Shuffle rows
% learn.expDes=learn.expDes(randperm(learn.nTrials),:);
