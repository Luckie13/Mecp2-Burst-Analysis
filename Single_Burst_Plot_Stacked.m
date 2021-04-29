%%
clear all; close all
scriptsDir      = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
cd(scriptsDir)
spikes_fileName = 'MPT200209_1C_DIV21_cSpikes_L-0.0627_RF1.mat';
spikeDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes';
burstDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';
sampling_rate = 25000;

%%
%%% To set section of recording
Electrode_of_interest=17;
Start   = 12950000;
Finish  = 13350000;

No_Ticks = ((Finish-Start)/sampling_rate);%sampling_rate)*2;%for 0.5 seconds %/2500 for ms
Tick_Values = [0];
Tick_Labels = 0:1:No_Ticks;
for z=1:No_Ticks
    Tick_Values=[Tick_Values (sampling_rate)*z];%[Tick_Values 2500*z];%(sampling_rate/2)*z];%For 0.5 seconds
end

cmap = ['#D95319';'#EDB120';'#77AC30';'#4DBEEE';'#0072BD';'#7E2F8E';'#A2142F';'#D95319'];
cd(XLSdir); inc_files = readtable('Burst_Data_included.xlsx');
cd(spikeDir); spikedata = load(spikes_fileName);
N_Value = [3 5 10 15 17 20 25 30];

list = inc_files.File_Names;
for i = 1:length(list)
    bursts_filename(i,1).File_Names = strcat(list{i});
end

%%% plotting Spikes
SpikeTrace=spikedata.cSpikes(:,Electrode_of_interest)';
Range = Finish - Start;
total_height = 1.5+(length(N_Value)*0.5);
plot(SpikeTrace(Start:Finish),'Color', [0 0.4470 0.7410], 'LineWidth',1)
ylim([0 total_height]);
xlim([0 Range]);
set(gca,'XAxisLocation','bottom','ycolor','none','TickDir','Out')
xticks(Tick_Values);
xticklabels(Tick_Labels);
% xticks([0 2500 5000 7500 10000 12500])
% xticklabels({'0','100','200','300','400','500'})
xlabel('Time (s)')
Height=[1.5 1.5];


for burst_index = 1 : length(bursts_filename)
    filename=bursts_filename(burst_index).File_Names;
    cd(burstDir); load(filename);
    for file = 1 : length(burstData)
        if burstData(file).filename == spikes_fileName
            burstdataindex = file;
        end
    end
    burstData   = burstData(burstdataindex);
    burst_times = burstData.burst_times;
    num_plots = length(bursts_filename);
    Burst_Start= 0;
    Burst_End= 0;
    elecBurstTimes=burst_times{1,Electrode_of_interest};
    
    Ntwo = num2str(N_Value(burst_index));
    label = strcat('N = ', Ntwo);
    text_level = Height(1,1);
    text(100,text_level,label)
    hold on
    %%% Setting up variables for plotting Bursts
    if length(elecBurstTimes)>0
        for BurstNum=1 : size(elecBurstTimes,1)
            if (elecBurstTimes(BurstNum) >= Start) && (elecBurstTimes(BurstNum) <= Finish)
                Burst_Start= [Burst_Start; elecBurstTimes(BurstNum,1)];
                Burst_End= [Burst_End; elecBurstTimes(BurstNum,2)];
            end
        end
    end
    %%% Plotting Bursts
    if size(Burst_Start,1)>0
        for Q=2 : size(Burst_Start,1)
            StartBurst=Burst_Start(Q,1)-Start;
            LengthBurst = Burst_End(Q,1)-Burst_Start(Q,1);
            EndBurst=StartBurst+LengthBurst;
            BurstLength=[StartBurst EndBurst];
            plot(BurstLength, Height,'Color',cmap(burst_index,:),'LineWidth',7)%cmap(burst_index,:)%for rainbow
        end
    end
    hold off
    Height = Height + [0.5 0.5];
end
set(gcf,'Position',[0 0 1000 200+length(bursts_filename)*50], 'color', 'white')