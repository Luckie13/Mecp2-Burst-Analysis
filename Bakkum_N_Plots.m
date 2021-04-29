clear all; close all
scriptsDir      = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
cd(scriptsDir)
spikeDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes';
burstDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';
%%
addpath(genpath(XLSdir));
DIV = 'DIV28';
N_Value = [3 5 8 10 11 12 13 14 15 17 20 25 30 35 40 50]';
Age_Value = DIV;

%%% Options of data to look at
%array_burstRate
%array_inBurstFR
%array_burstDur
%array_fracInBursts
%array_ISI_within
%array_ISI_outside

cd(XLSdir); inc_files = readtable('Burst_Measures_included.xlsx');
list = inc_files.File_Names;
for i = 1:length(list)
    burst_data_files(i,1).name = strcat(list{i});
end

%%% Burst Rate Variables
Mean_BurstRate_WT = [];
Mean_BurstRate_HE = [];
Mean_BurstRate_KO = [];
BurstRateSEM_WT = [];
BurstRateSEM_HE = [];
BurstRateSEM_KO = [];

%%% In Burst Firing Rate Variables
Mean_InBurstFR_WT = [];
Mean_InBurstFR_HE = [];
Mean_InBurstFR_KO = [];
InBurstFRSEM_WT = [];
InBurstFRSEM_HE = [];
InBurstFRSEM_KO = [];

%%% Fraction Spikes in Bursts Variables
Mean_FracInBursts_WT = [];
Mean_FracInBursts_HE = [];
Mean_FracInBursts_KO = [];
FracInBurstsSEM_WT = [];
FracInBurstsSEM_HE = [];
FracInBurstsSEM_KO = [];

%%% ISI within Variables
Mean_ISIwithin_WT = [];
Mean_ISIwithin_HE = [];
Mean_ISIwithin_KO = [];
ISIwithinSEM_WT = [];
ISIwithinSEM_HE = [];
ISIwithinSEM_KO = [];


%%% ISI outside Variables
Mean_ISIoutside_WT = [];
Mean_ISIoutside_HE = [];
Mean_ISIoutside_KO = [];
ISIoutsideSEM_WT = [];
ISIoutsideSEM_HE = [];
ISIoutsideSEM_KO = [];

%%% Burst Duration
Mean_BurstDur_WT = [];
Mean_BurstDur_HE = [];
Mean_BurstDur_KO = [];
BurstDurSEM_WT = [];
BurstDurSEM_HE = [];
BurstDurSEM_KO = [];

No_Cultures = [];

%%% WT Data
for x=1:length(burst_data_files)
    filename=burst_data_files(x).name;
    all_data=table2struct(readtable(filename),'ToScalar',true);
    
    for file = 1 : height(all_data)
        Burst_Rate_All = [all_data(file).array_burstRate];
        InBurstFR_All = [all_data(file).array_inBurstFR];
        FracInBursts_All = [all_data(file).array_fracInBursts];
        ISIwithin_All = [all_data(file).array_ISI_within];
        ISIoutside_All = [all_data(file).array_ISI_outside];
        BurstDur_All = [all_data(file).array_burstDur];
        Genotype_Validation = contains(all_data(file).genotype, 'WT');
        Age_Validation = contains(all_data(file).age, DIV);
    end
    
    Burst_Rate = [];
    InBurstFR = [];
    FracInBursts = [];
    ISIwithin = [];
    ISIoutside = [];
    BurstDur = [];
    
    for y=1 : length (Genotype_Validation)
        if Genotype_Validation(y,1) == 1 && Age_Validation(y,1)==1;
            Burst_Rate = [Burst_Rate; Burst_Rate_All(y)];
            InBurstFR = [InBurstFR; InBurstFR_All(y)];
            FracInBursts = [FracInBursts; FracInBursts_All(y)];
            ISIwithin = [ISIwithin; ISIwithin_All(y)];
            ISIoutside = [ISIoutside; ISIoutside_All(y)];
            BurstDur = [BurstDur; BurstDur_All(y)];
        end
    end
    
    %%% Mean Values for Burst Rate and SEM
    SEM_values = [];
    Burst_Rate(isnan(Burst_Rate))=0;
    Add_Mean = mean(Burst_Rate);
    if isnan(Add_Mean)
        Add_Mean = 0;
    end
    Mean_BurstRate_WT = [Mean_BurstRate_WT; Add_Mean];
    for y=1:length(Burst_Rate);
        if ~isnan(Burst_Rate(y))==1;
            SEM_values = [SEM_values; Burst_Rate(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    if isnan(SEM)
        SEM = 0;
    end
    BurstRateSEM_WT = [BurstRateSEM_WT; SEM];
    
    
    %%% Mean Values for In Burst Firing Rate
    SEM_values = [];
    Add_Mean = mean(InBurstFR,'omitnan');
    Mean_InBurstFR_WT = [Mean_InBurstFR_WT; Add_Mean];
    for y=1:length(InBurstFR);
        if ~isnan(InBurstFR(y))==1;
            SEM_values = [SEM_values; InBurstFR(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    InBurstFRSEM_WT = [InBurstFRSEM_WT; SEM];
    
    %%% Mean Values for Fraction of Spikes in Bursts
    SEM_values = [];
    FracInBursts(isnan(FracInBursts))=0;
    Add_Mean = mean(FracInBursts);
    if isnan(Add_Mean)
        Add_Mean = 0;
    end
    Mean_FracInBursts_WT = [Mean_FracInBursts_WT; Add_Mean];
    for y=1:length(FracInBursts);
        if ~isnan(FracInBursts(y))==1;
            SEM_values = [SEM_values; FracInBursts(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    if isnan(SEM)
        SEM = 0;
    end
    FracInBurstsSEM_WT = [FracInBurstsSEM_WT; SEM];
    
    %%% Mean Values for ISI Inside Bursts
    SEM_values = [];
    Add_Mean = mean(ISIwithin,'omitnan');
    Mean_ISIwithin_WT = [Mean_ISIwithin_WT; Add_Mean];
    for y=1:length(ISIwithin);
        if ~isnan(ISIwithin(y))==1;
            SEM_values = [SEM_values; ISIwithin(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    ISIwithinSEM_WT = [ISIwithinSEM_WT; SEM];
    
    %%% Mean Values for ISI Outside Bursts
    SEM_values = [];
    Add_Mean = mean(ISIoutside,'omitnan');
    Mean_ISIoutside_WT = [Mean_ISIoutside_WT; Add_Mean];
    for y=1:length(ISIoutside);
        if ~isnan(ISIoutside(y))==1;
            SEM_values = [SEM_values; ISIoutside(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    ISIoutsideSEM_WT = [ISIoutsideSEM_WT; SEM];
    
    %%% Mean Values for Burst Duration
    SEM_values = [];
    Add_Mean = mean(BurstDur,'omitnan');
    Mean_BurstDur_WT = [Mean_BurstDur_WT; Add_Mean];
    for y=1:length(BurstDur);
        if ~isnan(BurstDur(y))==1;
            SEM_values = [SEM_values; BurstDur(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    BurstDurSEM_WT = [BurstDurSEM_WT; SEM];
end
No_Cultures = [No_Cultures; length(Burst_Rate)];

%%% HE Data
for x=1:length(burst_data_files)
    filename=burst_data_files(x).name;
    all_data=table2struct(readtable(filename),'ToScalar',true);
    
    for file = 1 : height(all_data)
        Burst_Rate_All = [all_data(file).array_burstRate];
        InBurstFR_All = [all_data(file).array_inBurstFR];
        FracInBursts_All = [all_data(file).array_fracInBursts];
        ISIwithin_All = [all_data(file).array_ISI_within];
        ISIoutside_All = [all_data(file).array_ISI_outside];
        BurstDur_All = [all_data(file).array_burstDur];
        Genotype_Validation = contains(all_data(file).genotype, 'HE');
        Age_Validation = contains(all_data(file).age, DIV);
    end
    
    Burst_Rate = [];
    InBurstFR = [];
    FracInBursts = [];
    ISIwithin = [];
    ISIoutside = [];
    BurstDur = [];
    
    for y=1 : length (Genotype_Validation)
        if Genotype_Validation(y,1) == 1 && Age_Validation(y,1)==1;
            Burst_Rate = [Burst_Rate; Burst_Rate_All(y)];
            InBurstFR = [InBurstFR; InBurstFR_All(y)];
            FracInBursts = [FracInBursts; FracInBursts_All(y)];
            ISIwithin = [ISIwithin; ISIwithin_All(y)];
            ISIoutside = [ISIoutside; ISIoutside_All(y)];
            BurstDur = [BurstDur; BurstDur_All(y)];
        end
    end
    
    %%% Mean Values for Burst Rate and SEM
    SEM_values = [];
    Burst_Rate(isnan(Burst_Rate))=0;
    Add_Mean = mean(Burst_Rate);
    if isnan(Add_Mean)
        Add_Mean = 0;
    end
    Mean_BurstRate_HE = [Mean_BurstRate_HE; Add_Mean];
    for y=1:length(Burst_Rate);
        if ~isnan(Burst_Rate(y))==1;
            SEM_values = [SEM_values; Burst_Rate(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    if isnan(SEM)
        SEM = 0;
    end
    BurstRateSEM_HE = [BurstRateSEM_HE; SEM];
    
    
    %%% Mean Values for In Burst Firing Rate
    SEM_values = [];
    Add_Mean = mean(InBurstFR,'omitnan');
    Mean_InBurstFR_HE = [Mean_InBurstFR_HE; Add_Mean];
    for y=1:length(InBurstFR);
        if ~isnan(InBurstFR(y))==1;
            SEM_values = [SEM_values; InBurstFR(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    InBurstFRSEM_HE = [InBurstFRSEM_HE; SEM];
    
    %%% Mean Values for Fraction of Spikes in Bursts
    SEM_values = [];
    FracInBursts(isnan(FracInBursts))=0;
    Add_Mean = mean(FracInBursts);
    if isnan(Add_Mean)
        Add_Mean = 0;
    end
    Mean_FracInBursts_HE = [Mean_FracInBursts_HE; Add_Mean];
    for y=1:length(FracInBursts);
        if ~isnan(FracInBursts(y))==1;
            SEM_values = [SEM_values; FracInBursts(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    if isnan(SEM)
        SEM = 0;
    end
    FracInBurstsSEM_HE = [FracInBurstsSEM_HE; SEM];
    
    %%% Mean Values for ISI Inside Bursts
    SEM_values = [];
    Add_Mean = mean(ISIwithin,'omitnan');
    Mean_ISIwithin_HE = [Mean_ISIwithin_HE; Add_Mean];
    for y=1:length(ISIwithin);
        if ~isnan(ISIwithin(y))==1;
            SEM_values = [SEM_values; ISIwithin(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    ISIwithinSEM_HE = [ISIwithinSEM_HE; SEM];
    
    %%% Mean Values for ISI Outside Bursts
    SEM_values = [];
    Add_Mean = mean(ISIoutside,'omitnan');
    Mean_ISIoutside_HE = [Mean_ISIoutside_HE; Add_Mean];
    for y=1:length(ISIoutside);
        if ~isnan(ISIoutside(y))==1;
            SEM_values = [SEM_values; ISIoutside(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    ISIoutsideSEM_HE = [ISIoutsideSEM_HE; SEM];
    
    %%% Mean Values for Burst Duration
    SEM_values = [];
    Add_Mean = mean(BurstDur,'omitnan');
    Mean_BurstDur_HE = [Mean_BurstDur_HE; Add_Mean];
    for y=1:length(BurstDur);
        if ~isnan(BurstDur(y))==1;
            SEM_values = [SEM_values; BurstDur(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    BurstDurSEM_HE = [BurstDurSEM_HE; SEM];
end
No_Cultures = [No_Cultures; length(Burst_Rate)];

%%% KO Data
for x=1:length(burst_data_files)
    filename=burst_data_files(x).name;
    all_data=table2struct(readtable(filename),'ToScalar',true);
    
    for file = 1 : height(all_data)
        Burst_Rate_All = [all_data(file).array_burstRate];
        InBurstFR_All = [all_data(file).array_inBurstFR];
        FracInBursts_All = [all_data(file).array_fracInBursts];
        ISIwithin_All = [all_data(file).array_ISI_within];
        ISIoutside_All = [all_data(file).array_ISI_outside];
        BurstDur_All = [all_data(file).array_burstDur];
        Genotype_Validation = contains(all_data(file).genotype, 'KO');
        Age_Validation = contains(all_data(file).age, DIV);
    end
    
    Burst_Rate = [];
    InBurstFR = [];
    FracInBursts = [];
    ISIwithin = [];
    ISIoutside = [];
    BurstDur = [];
    
    for y=1 : length (Genotype_Validation)
        if Genotype_Validation(y,1) == 1 && Age_Validation(y,1)==1;
            Burst_Rate = [Burst_Rate; Burst_Rate_All(y)];
            InBurstFR = [InBurstFR; InBurstFR_All(y)];
            FracInBursts = [FracInBursts; FracInBursts_All(y)];
            ISIwithin = [ISIwithin; ISIwithin_All(y)];
            ISIoutside = [ISIoutside; ISIoutside_All(y)];
            BurstDur = [BurstDur; BurstDur_All(y)];
        end
    end
    
    %%% Mean Values for Burst Rate and SEM
    SEM_values = [];
    Burst_Rate(isnan(Burst_Rate))=0;
    Add_Mean = mean(Burst_Rate);
    if isnan(Add_Mean)
        Add_Mean = 0;
    end
    Mean_BurstRate_KO = [Mean_BurstRate_KO; Add_Mean];
    for y=1:length(Burst_Rate);
        if ~isnan(Burst_Rate(y))==1;
            SEM_values = [SEM_values; Burst_Rate(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    if isnan(SEM)
        SEM = 0;
    end
    BurstRateSEM_KO = [BurstRateSEM_KO; SEM];
    
    
    %%% Mean Values for In Burst Firing Rate
    SEM_values = [];
    Add_Mean = mean(InBurstFR,'omitnan');
    Mean_InBurstFR_KO = [Mean_InBurstFR_KO; Add_Mean];
    for y=1:length(InBurstFR);
        if ~isnan(InBurstFR(y))==1;
            SEM_values = [SEM_values; InBurstFR(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    InBurstFRSEM_KO = [InBurstFRSEM_KO; SEM];
    
    %%% Mean Values for Fraction of Spikes in Bursts
    SEM_values = [];
    FracInBursts(isnan(FracInBursts))=0;
    Add_Mean = mean(FracInBursts);
    if isnan(Add_Mean)
        Add_Mean = 0;
    end
    Mean_FracInBursts_KO = [Mean_FracInBursts_KO; Add_Mean];
    for y=1:length(FracInBursts);
        if ~isnan(FracInBursts(y))==1;
            SEM_values = [SEM_values; FracInBursts(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    if isnan(SEM)
        SEM = 0;
    end
    FracInBurstsSEM_KO = [FracInBurstsSEM_KO; SEM];
    
    %%% Mean Values for ISI Inside Bursts
    SEM_values = [];
    Add_Mean = mean(ISIwithin,'omitnan');
    Mean_ISIwithin_KO = [Mean_ISIwithin_KO; Add_Mean];
    for y=1:length(ISIwithin);
        if ~isnan(ISIwithin(y))==1;
            SEM_values = [SEM_values; ISIwithin(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    ISIwithinSEM_KO = [ISIwithinSEM_KO; SEM];
    
    %%% Mean Values for ISI Outside Bursts
    SEM_values = [];
    Add_Mean = mean(ISIoutside,'omitnan');
    Mean_ISIoutside_KO = [Mean_ISIoutside_KO; Add_Mean];
    for y=1:length(ISIoutside);
        if ~isnan(ISIoutside(y))==1;
            SEM_values = [SEM_values; ISIoutside(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    ISIoutsideSEM_KO = [ISIoutsideSEM_KO; SEM];
    
    %%% Mean Values for Burst Duration
    SEM_values = [];
    Add_Mean = mean(BurstDur,'omitnan');
    Mean_BurstDur_KO = [Mean_BurstDur_KO; Add_Mean];
    for y=1:length(BurstDur);
        if ~isnan(BurstDur(y))==1;
            SEM_values = [SEM_values; BurstDur(y)];
        end
    end
    SEM = std(SEM_values)/sqrt(length(SEM_values));
    BurstDurSEM_KO = [BurstDurSEM_KO; SEM];
end
No_Cultures = [No_Cultures; length(Burst_Rate)];

Genotype = ['WT';'HE';'KO'];
T = table(Genotype, No_Cultures);

cd('C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Scripts')
figure('Position', [0 100 1440 700],'color', 'white')
subplot(2,3,2)
errorbar(N_Value, Mean_BurstRate_WT,BurstRateSEM_WT,'Color','#0072BD')
% hold on
% errorbar(N_Value, Mean_BurstRate_HE,BurstRateSEM_HE,'Color','#EDB120')
% errorbar(N_Value, Mean_BurstRate_KO,BurstRateSEM_KO,'Color','#A2142F')
% hold off
a= [Mean_BurstRate_WT' ; N_Value']
optimCurve(a,1)
ylim([0 12]);
xlim([0 50]);
xlabel ('N Value')
ylabel ('Burst Rate (Bursts per Minute)')
set(gca,'TickDir','Out')
title('Mean Burst Rate', Age_Value)

% subplot (2,3,)
% fig = uifigure;
% uit = uitable(fig,'Data',T);

subplot(2,3,3)
errorbar(N_Value, Mean_InBurstFR_WT, InBurstFRSEM_WT,'Color','#0072BD')
hold on
errorbar(N_Value, Mean_InBurstFR_HE, InBurstFRSEM_HE,'Color','#EDB120')
errorbar(N_Value, Mean_InBurstFR_KO, InBurstFRSEM_KO,'Color','#A2142F')
hold off
xlim([0 50]);
xlabel ('N Value')
ylabel ('Firing Rate (Spikes per Second)')
set(gca,'TickDir','Out')
title('Mean In Burst Firing Rate', Age_Value)

subplot(2,3,1)
errorbar(N_Value, Mean_FracInBursts_WT, FracInBurstsSEM_WT,'Color','#0072BD')
% hold on
% errorbar(N_Value, Mean_FracInBursts_HE, FracInBurstsSEM_HE,'Color','#EDB120')
% errorbar(N_Value, Mean_FracInBursts_KO, FracInBurstsSEM_KO,'Color','#A2142F')
% hold off
a= [Mean_FracInBursts_WT' ; N_Value']
optimCurve(a,1)
ylim([0 0.6]);
xlim([0 50]);
xlabel ('N Value')
ylabel ('Fraction of Spikes In Bursts')

set(gca,'TickDir','Out')
title('Mean Fraction of Spikes In Bursts', Age_Value)

subplot(2,3,4)
errorbar(N_Value, Mean_ISIwithin_WT, ISIwithinSEM_WT,'Color','#0072BD')
hold on
errorbar(N_Value, Mean_ISIwithin_HE, ISIwithinSEM_HE,'Color','#EDB120')
errorbar(N_Value, Mean_ISIwithin_KO, ISIwithinSEM_KO,'Color','#A2142F')
hold off
xlim([0 50]);
xlabel ('N Value')
ylabel ('ISI Within Bursts (ms)')
set(gca,'TickDir','Out')
title('Mean ISI Within Bursts', Age_Value)

subplot(2,3,5)
errorbar(N_Value, Mean_ISIoutside_WT, ISIoutsideSEM_WT,'Color','#0072BD')
hold on
errorbar(N_Value, Mean_ISIoutside_HE, ISIoutsideSEM_HE,'Color','#EDB120')
errorbar(N_Value, Mean_ISIoutside_KO, ISIoutsideSEM_KO,'Color','#A2142F')
hold off
xlim([0 50]);
legend('WT','HET','KO')
xlabel ('N Value')
ylabel ('ISI Outside Bursts (ms)')
set(gca,'TickDir','Out')
title('Mean ISI Outside Bursts', Age_Value)

subplot(2,3,6)
errorbar(N_Value, Mean_BurstDur_WT, BurstDurSEM_WT,'Color','#0072BD')
hold on
errorbar(N_Value, Mean_BurstDur_HE, BurstDurSEM_HE,'Color','#EDB120')
errorbar(N_Value, Mean_BurstDur_KO, BurstDurSEM_KO,'Color','#A2142F')
hold off
xlim([0 50]);
xlabel ('N Value')
ylabel ('Burst Duration (ms)')
set(gca,'TickDir','Out')
title('Mean Burst Duration', Age_Value)
