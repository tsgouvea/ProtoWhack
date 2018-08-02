function GUIHandles = SessionSummary(Data, GUIHandles)

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
    axis off

    GUIHandles.Axes.Late.MainHandle = axes('Position', [.6 .2 .35 .7]); hold on
    GUIHandles.Axes.Late.MainHandle.XLabel.String = 'Latency (s)';
    GUIHandles.Axes.Late.MainHandle.YLabel.String = 'Counts';
    GUIHandles.Axes.Late.MainHandle.XLim = [-.1, 1.1]*60;

    %%
else
    global TaskParameters
end
%%
if nargin > 0
    try
        cla(GUIHandles.Axes.Pizza.MainHandle)
        
        GUIHandles.Axes.Pizza.Pie = pie(GUIHandles.Axes.Pizza.MainHandle,ones(1,3)*.001+histcounts(Data.Custom.Visits,[1:4]));
        for iPatch = 1:3
            GUIHandles.Axes.Pizza.Pie(iPatch*2-1).FaceColor=artist(iPatch,:);
        end
    end
    
    try
        cla(GUIHandles.Axes.Late.MainHandle)
        for iPatch = 1:3                  
            edges=[linspace(0,60,12),+Inf];
            GUIHandles.Axes.Late.Hist(iPatch) = histogram(GUIHandles.Axes.Late.MainHandle,Data.Custom.Latency(Data.Custom.Visits==iPatch),edges);
            GUIHandles.Axes.Late.Hist(iPatch).FaceColor = artist(iPatch,:);
            GUIHandles.Axes.Late.Hist(iPatch).EdgeColor = 'none';
        end
    end
end
