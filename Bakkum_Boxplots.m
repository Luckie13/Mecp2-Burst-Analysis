clear all; close all
scriptsDir      = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
cd(scriptsDir)
spikeDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes';
burstDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';
pth = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Scripts\Boxplot';
addpath(fullfile(pth, 'boxplot2'));
addpath(fullfile(pth, 'minmax'));
%%
addpath(genpath(XLSdir));
DIV = [14 21 28 35];

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

N=15;
filename='N=15_Bakkum_L-0.0627_BakkumParamters.xlsx';%burst_data_files(x).name;
all_data=table2struct(readtable(filename),'ToScalar',true);
Burst_Rate_Data = [all_data.array_burstRate];
FracInBursts_Data = [all_data.array_fracInBursts];
FracInBursts_Data(FracInBursts_Data==0) = nan

for file = 1 : height(all_data)
    Genotype_Validation = contains(all_data(file).genotype, 'WT');
    for y=1:length(DIV)
        Age = num2str(DIV(y));
        DIV_Validation = contains(all_data(file).age, Age);
        for z=1 : length (Genotype_Validation)
            if Genotype_Validation(z,1) == 1 && DIV_Validation(z,1) == 1
                if isnan(Burst_Rate_Data(z))
                    Burst_Rate_ALL(y,1,z) = 0.00001;
                else
                    Burst_Rate_ALL(y,1,z) = Burst_Rate_Data(z);
                end
                InBurstFR_ALL(y,1,z) = all_data(file).array_inBurstFR(z);
                if isnan(FracInBursts_Data(z))
                    FracInBursts_ALL(y,1,z) = 0.00001;
                else
                    FracInBursts_ALL(y,1,z) = all_data(file).array_fracInBursts(z);
                end
                ISIwithin_ALL(y,1,z) = all_data(file).array_ISI_within(z);
                ISIoutside_ALL(y,1,z) = all_data(file).array_ISI_outside(z);
                BurstDur_ALL(y,1,z) = all_data(file).array_burstDur(z);
                
            end
        end
    end
end
for file = 1 : height(all_data)
    Genotype_Validation = contains(all_data(file).genotype, 'HE');
    for y=1:length(DIV)
        Age = num2str(DIV(y));
        DIV_Validation = contains(all_data(file).age, Age);
        for z=1 : length (Genotype_Validation)
            if Genotype_Validation(z,1) == 1 && DIV_Validation(z,1) == 1
                if isnan(Burst_Rate_Data(z))
                    Burst_Rate_ALL(y,2,z) = 0.00001;
                else
                    Burst_Rate_ALL(y,2,z) = Burst_Rate_Data(z);
                end
                InBurstFR_ALL(y,2,z) = all_data(file).array_inBurstFR(z);
                if isnan(FracInBursts_Data(z))
                    FracInBursts_ALL(y,2,z) = 0.00001;
                else
                    FracInBursts_ALL(y,2,z) = all_data(file).array_fracInBursts(z);
                end
                ISIwithin_ALL(y,2,z) = all_data(file).array_ISI_within(z);
                ISIoutside_ALL(y,2,z) = all_data(file).array_ISI_outside(z);
                
                BurstDur_ALL(y,2,z) = all_data(file).array_burstDur(z);
                
            end
        end
    end
end

for file = 1 : height(all_data)
    Genotype_Validation = contains(all_data(file).genotype, 'KO');
    for y=1:length(DIV)
        Age = num2str(DIV(y));
        DIV_Validation = contains(all_data(file).age, Age);
        for z=1 : length (Genotype_Validation)
            if Genotype_Validation(z,1) == 1 && DIV_Validation(z,1) == 1
                if isnan(Burst_Rate_Data(z));
                    Burst_Rate_ALL(y,3,z) = 0.00001;
                else
                    Burst_Rate_ALL(y,3,z) = Burst_Rate_Data(z);
                end
                InBurstFR_ALL(y,3,z) = all_data(file).array_inBurstFR(z);
                if isnan(FracInBursts_Data(z))
                    FracInBursts_ALL(y,3,z) = 0.00001;
                else
                    FracInBursts_ALL(y,3,z) = all_data(file).array_fracInBursts(z);
                end
                ISIwithin_ALL(y,3,z) = all_data(file).array_ISI_within(z);
                ISIoutside_ALL(y,3,z) = all_data(file).array_ISI_outside(z);
                BurstDur_ALL(y,3,z) = all_data(file).array_burstDur(z);
            end
        end
    end
end

cd (scriptsDir)

%%% Setting Up Figure
figure('Position', [0 0 1500 800],'color', 'white')
cmap = ['#0072BD';'#EDB120';'#A2142F'];
label = strcat('Burst Data at N = ', num2str(N));
t = tiledlayout('flow','TileSpacing','compact');
addpath(genpath('C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Scripts\Sigstar'))


%%% Plotting Burst Rate Boxplots
nexttile
Burst_Rate_ALL(Burst_Rate_ALL==0)=nan;
a=boxplot2(Burst_Rate_ALL, DIV);
for q = 1:3
    structfun(@(DIV) set(DIV(q,:), 'color', cmap(q,:), ...
        'markeredgecolor', cmap(q,:)), a);
end
set([a.lwhis a.uwhis], 'linestyle', '-');
set(a.out, 'marker', '.');
set(gca,'TickDir','Out')
xticks(DIV)
ylim ([0 25])
xlabel('DIV')
ylabel('Burst Rate (Bursts per Minute)')
title('Burst Rate')

%%% Plotting In Burst Fraction Boxplots
nexttile
FracInBursts_ALL(FracInBursts_ALL==0)=nan;
a=boxplot2(FracInBursts_ALL, DIV);
for q = 1:3
    structfun(@(DIV) set(DIV(q,:), 'color', cmap(q,:), ...
        'markeredgecolor', cmap(q,:)), a);
end
set([a.lwhis a.uwhis], 'linestyle', '-');
set(a.out, 'marker', '.');
set(gca,'TickDir','Out')
ylim([0 0.8])
xticks(DIV)
xlabel('DIV')
ylabel('Fraction of Spikes In Bursts')
title('Fraction of Spikes In Bursts')

%%% Plotting Burst Duration Boxplots
nexttile
BurstDur_ALL(BurstDur_ALL==0)=nan;
a=boxplot2(BurstDur_ALL, DIV);
for q = 1:3
    structfun(@(DIV) set(DIV(q,:), 'color', cmap(q,:), ...
        'markeredgecolor', cmap(q,:)), a);
end
set([a.lwhis a.uwhis], 'linestyle', '-');
set(a.out, 'marker', '.');
set(gca,'TickDir','Out')
xticks(DIV)
ylim ([100 160])
xlabel('DIV')
ylabel('Burst Duration (ms)')
title('Burst Duration')
text(100,100,label);

%%% Plotting Firing Rate Boxplots
nexttile
InBurstFR_ALL(InBurstFR_ALL==0)=nan;
a=boxplot2(InBurstFR_ALL, DIV);
for q = 1:3
    structfun(@(DIV) set(DIV(q,:), 'color', cmap(q,:), ...
        'markeredgecolor', cmap(q,:)), a);
end
set([a.lwhis a.uwhis], 'linestyle', '-');
set(a.out, 'marker', '.');
set(gca,'TickDir','Out')
xticks(DIV)
ylim([140 155])
xlabel('DIV')
ylabel('Firing Rate (Spikes per Second)')
title('In Burst Firing Rate')

%%% Plotting ISI Within Boxplots
nexttile
ISIwithin_ALL(ISIwithin_ALL==0)=nan;
a=boxplot2(ISIwithin_ALL, DIV);
for q = 1:3
    structfun(@(DIV) set(DIV(q,:), 'color', cmap(q,:), ...
        'markeredgecolor', cmap(q,:)), a);
end
set([a.lwhis a.uwhis], 'linestyle', '-');
set(a.out, 'marker', '.');
set(gca,'TickDir','Out')
xticks(DIV)
ylim([2 9])
xlabel('DIV')
ylabel('ISI Within Bursts (ms)')
title('ISI Within Bursts')

%%% Plotting ISI Outside Boxplots
nexttile
ISIoutside_ALL(ISIoutside_ALL==0)=nan;
a=boxplot2(ISIoutside_ALL, DIV);
for q = 1:3
    structfun(@(DIV) set(DIV(q,:), 'color', cmap(q,:), ...
        'markeredgecolor', cmap(q,:)), a);
end
set([a.lwhis a.uwhis], 'linestyle', '-');
set(a.out, 'marker', '.');
set(gca,'TickDir','Out')
xticks(DIV)
xlabel('DIV')
ylim([0 7000])
ylabel('ISI Outside Bursts (ms)')
title('ISI Outside Bursts')


lgd=legend('WT','HET','KO');
lgd.Layout.Tile = 'east';
title(lgd,label);
lgd.Title.NodeChildren.Position;
lgd.Title.Visible = 'on';


