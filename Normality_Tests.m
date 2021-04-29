clear all; close all
scriptsDir      = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
cd(scriptsDir)
spikeDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes';
burstDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';

%%
addpath(genpath(XLSdir));
DIV=14
Genotype = 'WT'

cd(XLSdir); inc_files = readtable('Burst_Measures_included.xlsx');
list = inc_files.File_Names;
for i = 1:length(list)
    burst_data_files(i,1).name = strcat(list{i});
end

N=15;
filename='N=15_Bakkum_L-0.0627_BakkumParamters.xlsx';
all_data=table2struct(readtable(filename),'ToScalar',true);
Burst_Rate_Data = [all_data.array_burstRate];
Burst_Rate_test = [] ;
InBurstFR_Data = [all_data.array_inBurstFR];
InBurstFR_test = [];
FracInBursts_Data = [all_data.array_fracInBursts];
FracInBursts_test = [];
ISIwithin_Data = [all_data.array_ISI_within];
ISIwithin_test = [];
ISIoutside_Data = [all_data.array_ISI_outside];
ISIoutside_test = [];
BurstDur_Data = [all_data.array_burstDur];
BurstDur_test = [];
for file = 1 : height(all_data)
    Genotype_Validation = contains(all_data(file).genotype, Genotype);
    for y=1:length(DIV)
        Age = num2str(DIV);
        DIV_Validation = contains(all_data(file).age, Age);
        for z=1 : length (Genotype_Validation)
            if Genotype_Validation(z,1) == 1 && DIV_Validation(z,1) == 1
                if isnan(Burst_Rate_Data(z))
                    Burst_Rate_test = [Burst_Rate_test; 0];
                else
                    Burst_Rate_test = [Burst_Rate_test; Burst_Rate_Data(z)];
                end
                InBurstFR_test = [InBurstFR_test; InBurstFR_Data(z)];
                if isnan(FracInBursts_Data(z))
                    FracInBursts_test = 0;
                else
                    FracInBursts_test = [FracInBursts_test; FracInBursts_Data(z)];
                end
                ISIwithin_test = [ISIwithin_test; ISIwithin_Data(z)];
                ISIoutside_test = [ISIoutside_test; ISIoutside_Data(z)];
                BurstDur_test = [BurstDur_test; BurstDur_Data(z)];
            end
        end
    end
end

%%% Anderson-Darling test
% BR_Normality = adtest(Burst_Rate_test)
% FR_Normality = adtest(InBurstFR_test)
% Frac_Normality = adtest(FracInBursts_test)
% ISIin_Normality = adtest(ISIwithin_test)
% ISIout_Normality = adtest(ISIoutside_test)
% BurstDur_Normality = adtest(BurstDur_test)

%%% lillietest
% BR_Normality = lillietest(Burst_Rate_test)
% FR_Normality = lillietest(InBurstFR_test)
% Frac_Normality = lillietest(FracInBursts_test)
% ISIin_Normality = lillietest(ISIwithin_test)
% ISIout_Normality = lillietest(ISIoutside_test)
% BurstDur_Normality = lillietest(BurstDur_test)

% %%% kstest
% BR_Normality = kstest(Burst_Rate_test)
% FR_Normality = kstest(InBurstFR_test)
% Frac_Normality = kstest(FracInBursts_test)
% ISIin_Normality = kstest(ISIwithin_test)
% ISIout_Normality = kstest(ISIoutside_test)
% BurstDur_Normality = kstest(BurstDur_test)
%
% %%% jbtest
% BR_Normality = jbtest(Burst_Rate_test)
% FR_Normality = jbtest(InBurstFR_test)
% Frac_Normality = jbtest(FracInBursts_test)
% ISIin_Normality = jbtest(ISIwithin_test)
% ISIout_Normality = jbtest(ISIoutside_test)
% BurstDur_Normality = jbtest(BurstDur_test)

t = tiledlayout('flow','TileSpacing','compact');
nexttile
qqplot(Burst_Rate_test)
titletext = strcat('Burst Rate at DIV',num2str(DIV),',',Genotype)
title(titletext)
ylabel('Burst Rate')
nexttile
qqplot(InBurstFR_test)
title('FR')
ylabel('Firing Rate')
nexttile
qqplot(FracInBursts_test)
title('Frac')
ylabel('Fraction')
nexttile
qqplot(ISIwithin_test)
title('ISI in')
ylabel('ISI')
nexttile
qqplot(ISIoutside_test)
title('ISI out')
ylabel('ISI')
nexttile
qqplot(BurstDur_test)
title('B Dur')
ylabel('Burst Duration')
set(gcf,'Position',[100 100 600 600])

