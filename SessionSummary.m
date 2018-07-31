function GUIHandles = SessionSummary(Data, GUIHandles)

%global nTrialsToShow %this is for convenience
global BpodSystem
global TaskParameters
artist = lines(3);
ABC = 'ABC';

if nargin < 2 % plot initialized (either beginning of session or post-hoc analysis)
    if nargin > 0 % post-hoc analysis
        TaskParameters.GUI = Data.Settings.GUI;
    end
    %%
    GUIHandles = struct();
    
    GUIHandles.Figs.MainFig = figure('Position', [1500, 400, 400, 200],'name','Outcome plot','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
    
    GUIHandles.Axes.Pizza.MainHandle = axes('Position', [.1 .15 .35 .7]); hold on
    GUIHandles.Axes.Pizza.Pie = pie([1 1 1]);
    axis off
        
    GUIHandles.Axes.Late.MainHandle = axes('Position', [.6 .2 .35 .7]); hold on
    GUIHandles.Axes.Late.MainHandle.XLabel.String = 'Latency (s)';
    GUIHandles.Axes.Late.MainHandle.YLabel.String = 'Counts';
    
    for iPatch = 1:3
        GUIHandles.Axes.Pizza.Pie(iPatch*2-1).FaceColor=artist(iPatch,:);
        GUIHandles.Axes.Late.Hist(iPatch) = histogram(GUIHandles.Axes.Late.MainHandle,zeros(2,1));%,'Color',artist(iPatch,:));
        GUIHandles.Axes.Late.Hist(iPatch).FaceColor=artist(iPatch,:);
        GUIHandles.Axes.Late.Hist(iPatch).EdgeColor='none';
    end
    %%
else
    global TaskParameters
end
%%
if nargin > 0
    try
        cla(GUIHandles.Axes.Pizza.MainHandle)
        GUIHandles.Axes.Pizza.Pie = pie(GUIHandles.Axes.Pizza.MainHandle,categorical(BpodSystem.Data.Custom.Visits));
        for iPatch = 1:3
            GUIHandles.Axes.Pizza.Pie(iPatch*2-1).FaceColor=artist(iPatch,:);
        end
    end
    
    
    for iPatch = 1:3
        try
%             GUIHandles.Axes.Late.Hist(iPatch).Data=BpodSystem.Data.Custom.Latency(BpodSystem.Data.Custom.Visits==iPatch)*1000;
            GUIHandles.Axes.Late.Hist(iPatch) = histogram(GUIHandles.Axes.Late.MainHandle,BpodSystem.Data.Custom.Latency(BpodSystem.Data.Custom.Visits==iPatch));
    
%             [N, edges] = histcounts(BpodSystem.Data.Custom.Latency(BpodSystem.Data.Custom.Visits==iPatch)*1000);
%             GUIHandles.Axes.Late.Hist(iPatch) = histogram(GUIHandles.Axes.Late.MainHandle,,'Color',artist(iPatch,:));
            GUIHandles.Axes.Late.Hist(iPatch).FaceColor = artist(iPatch,:);
            GUIHandles.Axes.Late.Hist(iPatch).EdgeColor = 'none';
        end
    end
    
%     set(GUIHandles.Axes.SessionLong.CumRwd,'string', ...
%         [num2str(Data.nTrials*TaskParameters.GUI.rewardAmount/1000) ' mL']);
end
