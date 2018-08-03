function ProtoWhack
% Reproduction on Bpod of protocol used in the PatonLab, MATCHINGvFix
global Latent
global BpodSystem
global TaskParameters

%% Task parameters
TaskParameters = BpodSystem.ProtocolSettings;
if isempty(fieldnames(TaskParameters))
    %% General
    TaskParameters.GUI.Ports_ABC = '123';
    TaskParameters.GUI.Wires_ABC = '134';
    TaskParameters.GUI.ITI = 1; % (s)
    TaskParameters.GUI.VI = false; % random ITI
    TaskParameters.GUI.ChoiceDeadline = 10;
    TaskParameters.GUIMeta.VI.Style = 'checkbox';
    TaskParameters.GUI.Cued = false; % random ITI
    TaskParameters.GUIMeta.Cued.Style = 'checkbox';
    TaskParameters.GUI.rewardAmount = 30;
    TaskParameters.GUI.valueA = 0; % ln(Pa/Pb)=valueA-valueB, Pa: P(reward at a)
    TaskParameters.GUI.valueB = .5;
    TaskParameters.GUI.valueC = 1.5;
    TaskParameters.GUIPanels.General = {'Ports_ABC','Wires_ABC','ITI','VI','ChoiceDeadline','Cued','rewardAmount','valueA','valueB','valueC'};
    TaskParameters.GUI = orderfields(TaskParameters.GUI);
end
BpodParameterGUI('init', TaskParameters);
Latent.State1='setup000';
Latent.State1(5+randi(3))='1';

%% Custom data fields
BpodSystem.Data.Custom.Rig = getenv('computername');
[~,BpodSystem.Data.Custom.Subject] = fileparts(fileparts(fileparts(fileparts(BpodSystem.DataPath))));

BpodSystem.Data.Custom.Visits = [];
BpodSystem.Data.Custom.Latency = [];
BpodSystem.Data.Custom.Missed = [];

BpodSystem.Data.Custom = orderfields(BpodSystem.Data.Custom);

%% Initialize plots
temp = SessionSummary();
for i = fieldnames(temp)'
    BpodSystem.GUIHandles.(i{1}) = temp.(i{1});
end
clear temp
BpodNotebook('init');

%% Main loop
RunSession = true;
iTrial = 1;

while RunSession
    TaskParameters = BpodParameterGUI('sync', TaskParameters);
    
    sma = stateMatrix();
    SendStateMatrix(sma);
    RawEvents = RunStateMatrix;
    if ~isempty(fieldnames(RawEvents))
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents);
        SaveBpodSessionData;
    end
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    if BpodSystem.BeingUsed == 0
        return
    end
    
    updateControlVars(iTrial)
    iTrial = iTrial + 1;
    BpodSystem.GUIHandles = SessionSummary(BpodSystem.Data, BpodSystem.GUIHandles);
end
end