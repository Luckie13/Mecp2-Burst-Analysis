clear all; close all
scriptsDir      = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
cd(scriptsDir)
spikeDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes';
burstDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';
spikes_fileName = 'MPT200115_2B_DIV35_cSpikes_L-0.0627_RF1.mat';
bursts_fileName = 'BurstTimes_N=15_Bakkum_L-0.0627_bursts.mat';

%%
Start = 0;
Finish = 18000000;
Width = 2500;
sampling_rate = 25000;

No_Ticks = ((Finish-Start)/(sampling_rate*60));
Tick_Values = [Start];
Tick_Labels = 0:1:No_Ticks;
for z=1:No_Ticks
    Tick_Values=[Tick_Values Start+sampling_rate*z*60];
end

cd(burstDir); load(bursts_fileName);
cd(spikeDir); spikedata = load(spikes_fileName);
for file = 1 : length(burstData)
    if burstData(file).filename == spikes_fileName
        burstdataindex = file;
    end
end
burstData  = burstData(burstdataindex);
bursting_electrodes = burstData.bursting_electrodes;
burst_times = burstData.burst_times;

BurstHistogramPoints = [];
for x=1 : length(bursting_electrodes)
    ElecBurstTimes=burst_times{1,bursting_electrodes(x)};
    for y=1:size(ElecBurstTimes,1)
        BurstLength = ElecBurstTimes(y,2)-ElecBurstTimes(y,1);
        Divide = BurstLength/Width;
        if Divide>1
            NoPoints = round(Divide, 0);
        elseif Divide<1 && Divide>0;
           NoPoints = 1; 
        end
        point=ElecBurstTimes(y,1)-Start;
        for m=1:NoPoints
            BurstHistogramPoints = [BurstHistogramPoints; point];
            point=point+Width;
        end
    end
end

% subplot(3,1,1)
histogram(BurstHistogramPoints,'BinWidth', Width)
xlim([Start Finish])
ylabel('Number of Channels Active')
xticks(Tick_Values);
xticklabels(Tick_Labels);
set(gca,'TickDir','Out')
title('Cumulative Bursting Across Electrodes in KO at DIV35')

% subplot(3,1,2:3)
% for x=1 : length(bursting_electrodes)
%     ElecBurstTimes=burst_times{1,bursting_electrodes(x)};
%     elec=bursting_electrodes(x);
%     Burst_Start= [];
%     Burst_End= [];
%     if length(ElecBurstTimes)>0
%         for BurstNum=1 : size(ElecBurstTimes,1)
%             %if (ElecBurstTimes(BurstNum) >= Start) && (ElecBurstTimes(BurstNum) <= Finish)
%             Burst_Start= [Burst_Start; ElecBurstTimes(BurstNum,1)];
%             Burst_End= [Burst_End; ElecBurstTimes(BurstNum,2)];
%         end
%     end
%     
%     %%%Plotting Bursts
%     Height=[elec elec];
%     BurstLength=[];
%     if size(Burst_Start,1)>0
%         for z=1 : size(Burst_Start,1)
%             StartBurst=Burst_Start(z,1)-Start;
%             LengthBurst = Burst_End(z,1)-Burst_Start(z,1);
%             EndBurst=StartBurst+LengthBurst;
%             BurstLength=[StartBurst EndBurst];
%             plot(BurstLength, Height,'LineWidth',7,'Color','#EDB120')
%             hold on
%         end
%     end
%     
% end
% hold off
% xlim([Start Finish])
% ylim([1 60])
% xticks(Tick_Values);
% xticklabels(Tick_Labels);
% ylabel('Electrode Number')
xlabel('Time (minutes)')
% set(gca,'TickDir','Out')
set(gcf,'Position',[0 0 1300 300],'color', 'white')