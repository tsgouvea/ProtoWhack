function updateControlVars(iTrial)
%% Define variables
global BpodSystem
global TaskParameters
global Latent
ABC = 'ABC';

%% Compute visited states
listStates = BpodSystem.Data.RawData.OriginalStateNamesByNumber{end};
visited = BpodSystem.Data.RawData.OriginalStateData(end); visited = visited{:};
if numel(visited) == 1
    return
end
stateTraj=listStates(visited); setup=stateTraj{strncmp(listStates(visited),'setup',5)};
BpodSystem.Data.Custom.Visits(iTrial) = find(setup=='1')-5;

%% Set State1 for next trial

if any(strncmp('water',listStates(visited),5))
    ndxRwdArm = listStates{visited(end)}(end)==ABC;
    Latent.State1 = 'setup000';
    Z = [TaskParameters.GUI.valueA, TaskParameters.GUI.valueB, TaskParameters.GUI.valueC];
    P = exp(Z)/sum(exp(Z));
    if true % enforce switching
        P(ndxRwdArm)=0; P=P/sum(P);
    end
    Latent.State1(5+randsample(3,1,1,P)) = '1';
    %% Custom data fields
    assert(BpodSystem.Data.Custom.Visits(iTrial) == find(ndxRwdArm));
    BpodSystem.Data.Custom.Latency(iTrial) = diff(BpodSystem.Data.RawEvents.Trial{end}.States.(BpodSystem.Data.RawData.OriginalStateNamesByNumber{end}{strncmp('setup',fieldnames(BpodSystem.Data.RawEvents.Trial{end}.States),5)}));
else
    BpodSystem.Data.Custom.Latency(iTrial) = nan;
end

BpodSystem.Data.Custom.Missed(iTrial) = any(strcmp('missed_choice',listStates(visited)));

end