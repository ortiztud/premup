%% Project PREMUP: Prediction Error and Memory updating
% Design set up and definition of important variables
% ----------------------------------------------------------

% Prediction verification phase %
%% Define parameters
% ----------------------------------------------------------

pred.nConditions = 3;                      % number of conditions
pred.nCont_perCond = 2;                    % number of contexts per condition
pred.nCont=pred.nConditions*pred.nCont_perCond;
pred.nContInst=4;
pred.nTrials_perCont_flatPriors = 30;       % number of trials per context type
pred.nTrials_flatPriors = pred.nTrials_perCont_flatPriors * ...
    pred.nCont_perCond;                % number of trials on the weak prior condition
pred.nTrials_perCont_weakPriors = 35;       % number of trials per context type
pred.nTrials_weakPriors = pred.nTrials_perCont_weakPriors * ...
    pred.nCont_perCond;                % number of trials on the weak prior condition
pred.nTrials_perCont_strongPriors = 100;    % number of trials per context type
pred.nTrials_strongPriors = pred.nTrials_perCont_strongPriors * ...
    pred.nCont_perCond;                % number of trials on the weak prior condition
pred.nTrials = (pred.nTrials_flatPriors + pred.nTrials_weakPriors + pred.nTrials_strongPriors); % nTrials total
pred.nObjectCat = 2;                       % number of objects categories
pred.nFillers = 5; % Same number for all conditions
pred.priors=[.5,.5;.5,.5;...
    .3,.7;.7,.3;...
    .1,.9;.9,.1]; % contingencies for the three types of contexts
pred.repFillers=[2,2,3,3,16,16]; % Number of repetitions of the fillers per condition (flat, weak, strong)
pred.numbers=[round(pred.priors(1,:)*pred.nTrials_perCont_flatPriors);...
    round(pred.priors(2,:)*pred.nTrials_perCont_flatPriors);...
    floor(pred.priors(3,1)*pred.nTrials_perCont_weakPriors),...
    ceil(pred.priors(3,2)*pred.nTrials_perCont_weakPriors);...
    ceil(pred.priors(4,1)*pred.nTrials_perCont_weakPriors),...
     floor(pred.priors(4,2)*pred.nTrials_perCont_weakPriors);...
    round(pred.priors(5,:)*pred.nTrials_perCont_strongPriors);...
    round(pred.priors(6,:)*pred.nTrials_perCont_strongPriors);...
    ]; % instances for the two types of contexts
pred.nNoFillers=max(pred.numbers, [],2)-(pred.nFillers*pred.repFillers');
% pred.nObject_perCat = 80;                  % number of objects per category
% pred.fixTime = .5;                         % fixation duration (secs)
% pred.predTime = 2;                         % prediction duration (secs)
% pred.objTime = 3;                          % object on-screen time (secs)
% pred.fbDur = 1;                            % feedback duration (secs)

%% Experimental design.
% ----------------------------------------------------------

% Exp structure. Trials X variables (context type/context instance/obj cond/
% trial type)
pred.expDes(:,1)=[repmat(1,pred.nTrials_flatPriors,1);
    repmat(2,pred.nTrials_weakPriors,1);repmat(3,pred.nTrials_strongPriors,1)]; % Context type (1 flat, 2 weak, 3 strong)
pred.expDes(:,2)=[sort(repmat([1;2],pred.nTrials_perCont_flatPriors,1));
    sort(repmat([3;4],pred.nTrials_perCont_weakPriors,1));
    sort(repmat([5;6],pred.nTrials_perCont_strongPriors,1))]; % Scene category (e.g., beach, mountain, etc.)
pred.expDes(:,3)=[repmat([1:4]',pred.nTrials_flatPriors/4,1);...
    repmat([1:4]',32/4,1);[1;2;3];... % Ugly fix to account for 4 not being dividable by 5
    repmat([1:4]',32/4,1);[1;2;3];... % Ugly fix to account for 4 not being dividable by 5
    repmat([1:4]',pred.nTrials_strongPriors/4,1)];% Scene instance (e.g., beach1, beach2, etc.)
pred.expDes(:,4)=[repmat(1,pred.numbers(1,1),1);repmat(2,pred.numbers(1,2),1);...
     repmat(1,pred.numbers(2,1),1);repmat(2,pred.numbers(2,2),1);...
     repmat(1,pred.numbers(3,1),1);repmat(2,pred.numbers(3,2),1);...
     repmat(1,pred.numbers(4,1),1);repmat(2,pred.numbers(4,2),1);...
     repmat(1,pred.numbers(5,1),1);repmat(2,pred.numbers(5,2),1);...
     repmat(1,pred.numbers(6,1),1);repmat(2,pred.numbers(6,2),1);...
    ]; % Object category (musical instruments, household objects)
temp=[];
for i=1:length(pred.numbers)
    for j=1:pred.nObjectCat
        temp=[temp;repmat(pred.priors(i,j),pred.numbers(i,j),1)];
    end
end
pred.expDes(:,5)=temp; % PE level
temp=[repmat(1:4,1,(pred.nTrials_flatPriors)/4')'];temp1=temp(randperm(length(temp)))';
temp=[repmat(1:4,1,(pred.nTrials_weakPriors+2)/4')]';temp2=temp(randperm(length(temp)))';
temp=[repmat(1:4,1,(pred.nTrials_strongPriors)/4')'];temp3=temp(randperm(length(temp)))';
temp=[temp1';temp2';temp3'];% Ugly fix to account for 4 not being dividable by 5
pred.expDes(:,6)=temp(1:330);% Screen quadrant in which the object is appearing
pred.expDes(:,7)=[
    repmat(2,pred.repFillers(1)*pred.nFillers,1);repmat(1,pred.nNoFillers(1),1);repmat(2,pred.repFillers(1)*pred.nFillers,1);repmat(1,pred.nNoFillers(1),1);...
    repmat(2,pred.repFillers(2)*pred.nFillers,1);repmat(1,pred.nNoFillers(2),1);repmat(2,pred.repFillers(2)*pred.nFillers,1);repmat(1,pred.nNoFillers(2),1);...
    repmat(1,10,1);repmat(2,pred.repFillers(3)*pred.nFillers,1);repmat(1,pred.nNoFillers(3),1);...
    repmat(2,pred.repFillers(4)*pred.nFillers,1);repmat(1,pred.nNoFillers(4),1);repmat(1,10,1);...
    repmat(1,10,1);repmat(2,pred.repFillers(5)*pred.nFillers,1);repmat(1,pred.nNoFillers(5),1);...
    repmat(2,pred.repFillers(6)*pred.nFillers,1);repmat(1,pred.nNoFillers(6),1);repmat(1,10,1);...
    ]; % Fillers vs no fillers

if pD
    figure(desFig)
    subplot(2,3,2), imagesc(pred.expDes)
    xticks([1:6]);xticklabels({'Cont type';'Scn categ'; 'Scn instance'; 'Obj cat';'PE level';'Quadrant'})
    xtickangle(45);title('Pred Phase');ylabel('Trials')
end
