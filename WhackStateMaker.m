function [ sma ] = WhackStateMaker( sma )
%FLUXSTATEMAKER Defines states listed but yet undefined in SMA

if all(logical(sma.StatesDefined))
    return
end

stateName = sma.StateNames{find(~logical(sma.StatesDefined),1)};

try
    assert(strncmp(stateName,'ITI',3) | strncmp(stateName,'setup',5) | strncmp(stateName,'water',5) | strcmp(stateName,'missed_choice'))
catch
    error('Don''t know how to handle state with this name (TG, Jul31 18)')
end

%%
global Latent
global TaskParameters
smaTimer = 0;
smaChange = {};
smaOut = {};
ABC = 'ABC';
Ports_ABC = num2str(TaskParameters.GUI.Ports_ABC);
Wires_ABC =  num2str(TaskParameters.GUI.Wires_ABC);

if strncmp(stateName,'setup',5)
    smaTimer = TaskParameters.GUI.ChoiceDeadLine;
    smaChange = {'Tup','missed_choice'};
    for iPatch = 1:3
        if strcmp(stateName(5+iPatch),'1')
            PortIn = ['Port' Ports_ABC(iPatch) 'In'];
            nextState = ['water_' ABC(iPatch)];
            smaChange = {smaChange{:}, PortIn, nextState};
            if TaskParameters.GUI.Cued
                smaOut = {smaOut{:}, strcat('PWM',Ports_ABC(iPatch)),255,'WireState',2^(str2double(Wires_ABC(iPatch))-1)};
            end
        end
    end
elseif strncmp(stateName,'water',5)
    Port = floor(mod(TaskParameters.GUI.Ports_ABC/10^(3-find(ABC==stateName(end))),10));
    ValveTime = GetValveTimes(TaskParameters.GUI.rewardAmount, Port);
    smaTimer = ValveTime;
    smaChange = {'Tup',strcat('ITI_',stateName(end))};
    smaOut = {smaOut{:}, 'ValveState', 2^(Port-1)};
    if TaskParameters.GUI.Cued
        smaOut = {smaOut{:},strcat('PWM',Ports_ABC(ABC==stateName(end))),0,'WireState',0};
    end
elseif strncmp(stateName,'ITI',3)
    if TaskParameters.GUI.VI
        smaTimer = TaskParameters.GUI.ITI;
    else
        smaTimer = exprnd(TaskParameters.GUI.ITI);
    end
    smaChange = {'Tup','exit'};
elseif strcmp(stateName,'missed_choice')
    smaTimer = 0;
    smaChange = {'Tup','ITI'};
end

%%
sma = AddState(sma, 'Name', stateName,...
    'Timer', smaTimer,...
    'StateChangeConditions', smaChange,...
    'OutputActions', smaOut);