function updateControlVars()
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

%% Set State1 for next trial
if (strncmp('ITI',listStates{visited(end)},3))
    ndxRwdArm = listStates{visited(end)}(end)==ABC;
    Latent.State1 = 'setup000';
    others=find(~ndxRwdArm);
    if rand<(1/(1+exp(TaskParameters.GUI.(['value' ABC(others(2))])-TaskParameters.GUI.(['value' ABC(others(1))]))))
        Latent.State1(end-3+others(1))='1';
    else
        Latent.State1(end-3+others(2))='1';
    end
end

%% Custom data fields
BpodSystem.Data.Custom.Visits(end+1) = find(ndxRwdArm);
BpodSystem.Data.Custom.Latency(end+1) = diff(BpodSystem.Data.RawEvents.Trial{end}.States.(BpodSystem.Data.RawData.OriginalStateNamesByNumber{end}{strncmp('setup',fieldnames(BpodSystem.Data.RawEvents.Trial{end}.States),5)}));

end