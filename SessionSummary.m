function GUIHandles = SessionSummary(Data, GUIHandles)
global TaskParameters
artist = lines(3);
ABC = 'ABC';

if nargin < 2 % plot initialized (either beginning of session or post-hoc analysis)
    if nargin > 0 % post-hoc analysis
        TaskParameters.GUI = Data.Settings.GUI;
    end
    %%
    GUIHandles = struct();

    GUIHandles.Figs.MainFig = figure('Position', [1500, 400, 600, 200],'name','Outcome plot','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');

    GUIHandles.Axes.Pizza.MainHandle = axes('Position', [.05 .15 .23 .7]); hold on
    GUIHandles.Axes.Pizza.MainHandle.Title.String = 'Hit'; 
    axis off
    
    GUIHandles.Axes.Minipizza.MainHandle = axes('Position', [.25 .75 50/600 50/200]); hold on
    axis off
    Z = [TaskParameters.GUI.valueA, TaskParameters.GUI.valueB, TaskParameters.GUI.valueC];
    GUIHandles.Axes.Minipizza.Pie = pie(GUIHandles.Axes.Minipizza.MainHandle,exp(Z)/sum(exp(Z)),{'','',''});
    for iPatch = 1:3
        GUIHandles.Axes.Minipizza.Pie(iPatch*2-1).FaceColor=artist(iPatch,:);
    end
    
    GUIHandles.Axes.Late.MainHandle = axes('Position', [.42 .2 .25 .7]); hold on
    GUIHandles.Axes.Late.MainHandle.XLabel.String = 'Latency (s)';
    GUIHandles.Axes.Late.MainHandle.YLabel.String = 'Counts';
    GUIHandles.Axes.Late.MainHandle.XLim = [-.1, 1.1]*60;
    
    GUIHandles.Axes.Stale.MainHandle = axes('Position', [.72 .15 .23 .7]); hold on
    GUIHandles.Axes.Stale.MainHandle.Title.String = 'Miss'; 
    axis off

    %%
else
    global TaskParameters
end
%%
if nargin > 0
    %% Main Pizza
    try
        cla(GUIHandles.Axes.Pizza.MainHandle)
        
        GUIHandles.Axes.Pizza.Pie = pie(GUIHandles.Axes.Pizza.MainHandle,ones(1,3)*.001+histcounts(Data.Custom.Visits(~Data.Custom.Missed),[1:4]));
        for iPatch = 1:3
            GUIHandles.Axes.Pizza.Pie(iPatch*2-1).FaceColor=artist(iPatch,:);
        end
    end
    
    %% Latency histogram
    try
        cla(GUIHandles.Axes.Late.MainHandle)
        for iPatch = 1:3                  
            edges=[linspace(0,60,12),+Inf];
            GUIHandles.Axes.Late.Hist(iPatch) = histogram(GUIHandles.Axes.Late.MainHandle,Data.Custom.Latency(Data.Custom.Visits==iPatch & ~Data.Custom.Missed),edges);
            GUIHandles.Axes.Late.Hist(iPatch).FaceColor = artist(iPatch,:);
            GUIHandles.Axes.Late.Hist(iPatch).EdgeColor = 'none';
        end
        text(GUIHandles.Axes.Late.MainHandle,GUIHandles.Axes.Late.MainHandle.XLim(2)*.97,GUIHandles.Axes.Late.MainHandle.YLim(2)*.91,{'Reward so far:',[sprintf('%2.2f',sum(not(Data.Custom.Missed))*TaskParameters.GUI.rewardAmount/1000) 'mL']},'HorizontalAlignment','right')
    end
    
    %% Stale Pizza
    try
        cla(GUIHandles.Axes.Stale.MainHandle)
        
        GUIHandles.Axes.Stale.Pie = pie(GUIHandles.Axes.Stale.MainHandle,ones(1,3)*.001+histcounts(Data.Custom.Visits(logical(Data.Custom.Missed)),[1:4]));
        for iPatch = 1:3
            GUIHandles.Axes.Stale.Pie(iPatch*2-1).FaceColor=artist(iPatch,:);
        end
    end
end
