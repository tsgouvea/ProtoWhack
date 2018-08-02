function sma = stateMatrix()
global Latent

%% Define ports

sma = NewStateMatrix();
sma = AddState(sma, 'Name', 'state_0',...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', Latent.State1},...
    'OutputActions', {});

while any(~logical(sma.StatesDefined))
    sma = WhackStateMaker(sma);
end
end