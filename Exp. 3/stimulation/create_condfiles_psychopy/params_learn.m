%% Project PREMUP: Prediction Error and Memory updating
% Design set up and definition of important variables
% ----------------------------------------------------------

% Contingency learning phase %
%% Define parameters
% ----------------------------------------------------------

learn.nConditions = 3;                      % number of conditions
learn.nCont_perCond = 2;                    % number of contexts per condition
learn.nContCat=learn.nConditions*learn.nCont_perCond;
learn.nContInst=4;
learn.nTrials_perCont = 40;       % number of trials per context type
learn.nTrials = learn.nTrials_perCont * learn.nCont_perCond * learn.nConditions;
learn.priors=[.5,.5;...
    .5,.5;...
    .3,.7;...
    .7,.3;...
    .1,.9;...
    .9,.1]; % contingencies for the three types of contexts
learn.numbers=round(learn.priors*learn.nTrials_perCont); % instances for the two types of contexts
learn.nObjectCat = 2;                       % number of objects categories

%% Experimental design.
% ----------------------------------------------------------

% Exp structure. Trials X variables (context type/context instance/trial
% type)
learn.expDes(:,1)=sort(repmat([1;2;3],learn.nTrials_perCont*learn.nCont_perCond,1)); % Context type (1 flat, 2 weak, 3 strong)
learn.expDes(:,2)=sort(repmat([1;2;3;4;5;6],learn.nTrials_perCont,1)); % Scene category (e.g., beach, mountain, etc.)
learn.expDes(:,3)=repmat([1:4]',learn.nTrials/4,1); % Scene instance (e.g., beach1, beach2, etc.)
temp=[];
for i=1:length(learn.numbers)
    for j=1:learn.nObjectCat
        temp=[temp;repmat(repmat(j,learn.numbers(i,j)/2,1),2,1)];
    end
end
learn.expDes(:,4)=temp; % Object category (musical instruments, household objects)
temp=[];
for i=1:length(learn.numbers)
    for j=1:learn.nObjectCat
        temp=[temp;repmat(learn.priors(i,j),learn.nTrials_perCont*learn.priors(i,j),1)];
    end
end
learn.expDes(:,5)=temp; % PE level
temp=repmat(1:4,1,(learn.nTrials_perCont*learn.nCont_perCond)/4'); % Screen quadrant in which the object is appearing
learn.expDes(:,6)=[temp(randperm(length(temp)))';
    temp(randperm(length(temp)))';
    temp(randperm(length(temp)))';
    ];% Screen quadrant in which the object is appearing

if pD
    desFig=figure;
    subplot(2,3,1),imagesc(learn.expDes)
    xticks([1:6]);xticklabels({'Cont type';'Scn categ'; 'Scn instance'; 'Obj cat';'PE level';'Quadrant'})
    xtickangle(45);title('Learn Phase');ylabel('Trials')
end