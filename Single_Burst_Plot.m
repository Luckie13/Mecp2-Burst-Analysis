%%
clear all; close all
scriptsDir      = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
cd(scriptsDir)
spikes_fileName = 'MPT190403_6C_DIV28_cSpikes_L-0.0627_RF1.mat';
spikeDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes';
burstDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';

%%
%%% To set section of recording
Electrode_of_interest=9;
Start= 614500;
Finish= 619500;

cd(XLSdir); inc_files = readtable('Burst_Data_included.xlsx');
spikedata       = load(spikes_fileName);
N_Value = [3 5 10 15 20 30];

list = inc_files.File_Names;
for i = 1:length(list)
    bursts_filename(i,1).name = strcat(list{i});
end

for plot_index = 1 : length(bursts_filename)
    filename=bursts_filename(plot_index).name;
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
    SpikeTrace=spikedata.cSpikes(1:900000,Electrode_of_interest)';
    Range = Finish - Start;
    
    %%% plotting Spikes
    subplot(num_plots,1,plot_index)
    plot(SpikeTrace(Start:Finish), 'Color', [0 0.4470 0.7410], 'LineWidth',1)
    ylim([0 2]);
    xlim([0 Range]);
    %title('N =', N_Value(plot_index))
    title(['N = ' N_Value(plot_index)])
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
            Height=[1.5 1.5];
            plot(BurstLength, Height,'Color', [0.9290 0.6940 0.1250], 'LineWidth',7)
            set(gcf,'Position',[0 0 1000 length(bursts_filename)*100])
        end
    end
    hold off
end