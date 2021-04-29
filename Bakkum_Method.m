clear all; close all
% cd 'D:\MECP2_2019_AD\Scripts_and_Output\S1.2.File_Conversion_Output'
% XLSdir contains excel files; needs to contain the list of recordings to
% include and this will be where the excel results files will be spat out
% .mat results files will be put in MATdir; MAT files containing spike
% matrices need to be in MATdir
sampling_fr = 25000;
code_dir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';
MATdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
spike_suffix = '_cSpikes_L-0.0627_RF1.mat';
method = 'cwt';
threshold = 'L-0.0627';

cd(XLSdir); inc_files = readtable('recs_included.xlsx');

% files = sortrows(files,'rec','ascend');

list = inc_files.file;
list1 = inc_files.Age;
list2 = inc_files.Genotype;
for i = 1:length(list)
    files(i,1).name = strcat(list{i} , spike_suffix);
    files(i,1).age = strcat(list1{i});
    files(i,1).genotype = strcat(list2{i});
end

% find files with a certain phrase in the directory (redundant with above)
% files = dir('*MPT*cSpikes_L-0.0627_RF1.mat');

% Removes specific files
% files = files(~contains({files.name}, 'TTX','IgnoreCase',true));

samplingRate = sampling_fr; fs = sampling_fr;
% sync_win_s = 0.05;
%
% spikes_only = 0;
% burst_stats = 0;
% cor_ctrl = 0; % 1 means correlate randomly shuffled trains; be sure to change the sync window for the ctrl
% fc_figures = 0;%change to 1 to add plots
% g_figures = 0;%graph theory
% g_measures = 1;

%% within channel bursts
cd(MATdir)
addpath(genpath('C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes'));

warning('off','MATLAB:nearlySingularMatrix');
% bakkum method for individual channels
% N = 30; minChan = 3;
fprintf(strcat('\n','\n','getting ISIn bursts within channels...','\n','\n'))
for i = 1:length(files)
    filename = files(i).name
    load(filename);
    spikeMat = cSpikes(1:900000,:);
    method = 'Bakkum';
    minChan = 1;
    N = 15;
    active_chans = find(sum(cSpikes(1:900000,:)) > N);
    for elec = 1 : size(spikeMat,2)
        %     spikeTrain = spikeMat(:,active_chans(elec));
        spikeTrain = spikeMat(:,elec);
        if sum(spikeTrain) >= N
            try
                [burstMatrix, burstTimes, burstChannels] = burstDetect(spikeTrain, method, samplingRate,N,minChan);
            catch
                burstMatrix     = 0;
                burstTimes      = 0;
                burstChannels   = 0;
            end
        else
            burstMatrix     = 0;
            burstTimes      = 0;
            burstChannels   = 0;
        end
        burstMatrices{elec} = burstMatrix;
        burstTimes_all{elec} = burstTimes;
        burstChannels_all{elec} = burstChannels;
        clear burstMatrix burstTimes burstChannels
    end
    
    
    % analyse bursts
    for elec = 1:length(burstMatrices)
        %     numBursts(i,1) = length(burstMatrices{i});
        burstMatrix = burstMatrices{elec};
        burstTimes  = burstTimes_all{elec};
        if length(burstMatrix) > 0 & iscell(burstMatrix)
            for Bst=1:length(burstMatrix)
                sp_in_bst(Bst)=sum(sum(burstMatrix{Bst,1}));
                sp_times = find(burstMatrix{Bst,1}==1);
                sp_times2= sp_times(2:end);
                ISI_within = sp_times2 - sp_times(1:end-1);
                mean_ISI_w(Bst) = round(nanmean(ISI_within)/sampling_fr*1000,3); %in ms with 3 d.p.
                BLength(Bst) = size(burstMatrix{Bst,1},1)/sampling_fr*1000; %in ms
                within_bst_FR(Bst) = sp_in_bst(Bst) / BLength(Bst) *1000;
                clear ISI_within sp_times sp_times2 train
            end
            mean_num_sp_in_bst(elec)        = sum(sp_in_bst) / length(burstMatrix);
            total_num_sp_in_bst(elec)       = sum(sp_in_bst);
            burst_rate_elecs(elec)          = length(burstMatrix) / ((length(spikeMat)/fs)/60); %bursts/min
            mean_inBurst_FR(elec)           = nanmean(within_bst_FR);
            mean_ISI_w(elec)                = nanmean(mean_ISI_w);
            mean_BLength(elec)              = nanmean(BLength);
        else
            fprintf('No bursts detected in electrode');
            disp(elec)
            mean_num_sp_in_bst(elec)    = NaN;
            total_num_sp_in_bst(elec)   = NaN;
            burst_rate_elecs(elec)      = NaN;
            mean_inBurst_FR(elec)       = NaN;
            mean_ISI_w(elec)            = NaN;
            mean_BLength(elec)          = NaN;
        end
        
        sp_times = find(spikeMat(:,elec)==1);
        sp_times2= sp_times(2:end);
        ISI_outside = sp_times2 - sp_times(1:end-1);
        
        mean_ISI_o(elec)        = round(nanmean(ISI_outside)/sampling_fr*1000,3); % in ms
        frac_spikes_inB(elec)   = total_num_sp_in_bst(elec) / sum(spikeMat(:,elec));
        clear burstMatrix sp_in_bst
    end
    
    for elec = 1:length(burstMatrices)
        check_elec(1,elec) = ~isempty(burstMatrices{elec});
        check_elec(2,elec) = iscell(burstMatrices{elec});
    end
    bursting_electrodes = find(sum(check_elec) == 2);
    
    
    burstData(i).filename                = files(i).name;
    burstData(i).age                     = files(i).age;
    burstData(i).genotype                = files(i).genotype;
    burstData(i).array_burstRate         = nanmedian(burst_rate_elecs(bursting_electrodes)); %bursts/min
    burstData(i).array_inBurstFR         = nanmedian(mean_inBurst_FR(bursting_electrodes)); %in Hz
    burstData(i).array_burstDur          = nanmedian(mean_BLength(bursting_electrodes)); %in ms
    burstData(i).array_fracInBursts      = nanmedian(frac_spikes_inB(bursting_electrodes));
    burstData(i).array_ISI_within        = nanmedian(mean_ISI_w(bursting_electrodes)); %in ms
    burstData(i).array_ISI_outside       = nanmedian(mean_ISI_o(bursting_electrodes)); %in ms
    burstData(i).array_fracInBursts      = (sum(total_num_sp_in_bst(~isnan(total_num_sp_in_bst)))  )  /  sum(sum(spikeMat));
    burstData(i).spike_matrices          = burstMatrices;
    burstData(i).burst_times             = burstTimes_all;
    burstData(i).bursting_electrodes     = bursting_electrodes;
end

%% save
disp('saving...')
Ntwo=num2str(N)
cd(MATdir)
fileName = strcat('BurstTimes_N=',Ntwo,'_', method,'_' ,threshold, '_bursts','.mat');
save(fileName, 'burstData');

for i = 1:length(files)
    burstData(i).spike_matrices=0;
    burstData(i).burst_times =0;
    burstData(i).bursting_electrodes=0;
end

% NOTE: saving xls file in xls directory specified at the top
cd(XLSdir)
xldata1 = struct2table(burstData);
writetable(xldata1(:,1:end), strcat(fileName(1:end-4),'BakkumBurstWithin','','.xlsx'))