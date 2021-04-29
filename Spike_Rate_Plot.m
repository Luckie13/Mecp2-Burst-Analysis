clear all; close all
scriptsDir      = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
spikeDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Spikes';
burstDir        = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method';
XLSdir = 'C:\Users\lucyx\Documents\University\Year 3\Project\Project Code\Bakkum_Method\Excel Files';
samplingRate = 25000;
%%

cd(XLSdir); SpikeData = table2struct(readtable('SpikeRateData.xlsx'));
BurstData = table2struct(readtable('N=15_Bakkum_L-0.0627_BakkumParamters.xlsx'));

DIV = [14 21 28 35];
Genotype = ['WT'; 'HE'; 'KO'];

BurstRates = [SpikeData.BurstRate];
BurstRates(isnan(BurstRates))=0;

Genotype_Data = struct(Genotype(1,:),[,],Genotype(2,:),[,],Genotype(3,:),[,]);
DIV_Data = struct('DIV14',[,],'DIV21',[,],'DIV28',[,],'DIV35',[,]);
DIV35HE = struct('MPT190403_2B',[,],'MPT190515_4B',[,],'MPT190515_4C',[,],...
    'MPT200108_1A',[,],'MPT200108_2B',[,],'MPT200115_1A',[,],'MPT200115_1B',[,],...
    'MPT200115_1C',[,],'MPT200115_1D',[,],'MPT200205_2A',[,],'MPT200205_2C',[,],...
    'MPT200209_1A',[,],'MPT200209_1B',[,],'MPT200209_1C',[,]);

cmap = ['#0072BD';'#EDB120';'#A2142F';'#7E2F8E'];


for m=1:length(Genotype);
    GT = Genotype(m,:);
    for x=1:length(BurstRates);
        Genotype_Validation = contains(SpikeData(x).genotype, GT);
        %     Age = num2str(DIV);
        %     DIV_Validation = contains(all_data(file).age, Age);
        if Genotype_Validation == 1 && GT(1) == 'W'
            Genotype_Data.WT = [Genotype_Data.WT; SpikeData(x).SpikeRate, BurstRates(x)];
        elseif Genotype_Validation == 1 && GT(1) == 'H'
            Genotype_Data.HE = [Genotype_Data.HE; SpikeData(x).SpikeRate, BurstRates(x)];
        elseif Genotype_Validation == 1 && GT(1) == 'K'
            Genotype_Data.KO = [Genotype_Data.KO; SpikeData(x).SpikeRate, BurstRates(x)];
        end
    end
end



for m=1:length(DIV)
    for x=1:length(BurstRates);
        Genotype_Validation = contains(SpikeData(x).genotype, 'HE');
        if Genotype_Validation == 1
            Age = num2str(DIV(m));
            DIV_Validation = contains(SpikeData(x).age, Age);
            if DIV_Validation == 1 && Age(2) == '4'
                DIV_Data.DIV14 = [DIV_Data.DIV14; SpikeData(x).SpikeRate, BurstRates(x)];
            elseif DIV_Validation == 1 && Age(2) == '1'
                DIV_Data.DIV21 = [DIV_Data.DIV21; SpikeData(x).SpikeRate, BurstRates(x)];
            elseif DIV_Validation == 1 && Age(2) == '8'
                DIV_Data.DIV28 = [DIV_Data.DIV28; SpikeData(x).SpikeRate, BurstRates(x)];
            elseif DIV_Validation == 1 && Age(2) == '5'
                DIV_Data.DIV35 = [DIV_Data.DIV35; SpikeData(x).SpikeRate, BurstRates(x)];
            end
        end
    end
end

% for m=1:length(DIV)
%     for x=1:length(BurstRates);
%         Genotype_Validation = contains(SpikeData(x).genotype, 'HE');
%         DIV_Validation = contains(SpikeData(x).age, '35');
%         if Genotype_Validation == 1 && DIV_Validation == 1
%             if contains(SpikeData(x).filename,'MPT190403_2B');
%                 DIV35HE.MPT190403_2B = [DIV35HE.MPT190403_2B; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT190515_4B');
%                 DIV35HE.MPT190515_4B = [DIV35HE.MPT190515_4B; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT190515_4C');
%                 DIV35HE.MPT190515_4C = [DIV35HE.MPT190515_4C; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200108_1A');
%                 DIV35HE.MPT200108_1A = [DIV35HE.MPT200108_1A; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200108_2B');
%                 DIV35HE.MPT200108_2B = [DIV35HE.MPT200108_2B; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200115_1A');
%                 DIV35HE.MPT200115_1A = [DIV35HE.MPT200115_1A; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200115_1B');
%                 DIV35HE.MPT200115_1B = [DIV35HE.MPT200115_1B; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200115_1C');
%                 DIV35HE.MPT200115_1C = [DIV35HE.MPT200115_1C; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200115_1D');
%                 DIV35HE.MPT200115_1D = [DIV35HE.MPT200115_1D; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200205_2A');
%                 DIV35HE.MPT200205_2A = [DIV35HE.MPT200205_2A; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200205_2C');
%                 DIV35HE.MPT200205_2C = [DIV35HE.MPT200205_2C; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200209_1A');
%                 DIV35HE.MPT200209_1A = [DIV35HE.MPT200209_1A; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200209_1B');
%                 DIV35HE.MPT200209_1B = [DIV35HE.MPT200209_1B; SpikeData(x).SpikeRate, BurstRates(x)];
%             elseif contains(SpikeData(x).filename,'MPT200209_1C');
%                 DIV35HE.MPT200209_1C = [DIV35HE.MPT200209_1C; SpikeData(x).SpikeRate, BurstRates(x)];
%             end
%         end
%     end
% end


scatter(Genotype_Data.WT(:,1), Genotype_Data.WT(:,2),15,'MarkerEdgeColor',cmap(1,:))
hold on
scatter(Genotype_Data.HE(:,1), Genotype_Data.HE(:,2),15,'^','MarkerEdgeColor',cmap(2,:))
scatter(Genotype_Data.KO(:,1), Genotype_Data.KO(:,2),15,'s','MarkerEdgeColor',cmap(3,:))
hold off
% scatter(DIV_Data.DIV14(:,1), DIV_Data.DIV14(:,2),15,'MarkerEdgeColor',cmap(1,:))
% hold on
% scatter(DIV_Data.DIV21(:,1), DIV_Data.DIV21(:,2),15,'+','MarkerEdgeColor',cmap(2,:))
% scatter(DIV_Data.DIV28(:,1), DIV_Data.DIV28(:,2),15,'s','MarkerEdgeColor',cmap(3,:))
% scatter(DIV_Data.DIV35(:,1), DIV_Data.DIV35(:,2),15,'^','MarkerEdgeColor',cmap(4,:))
% hold off
% scatter(DIV35HE.MPT190403_2B(:,1),DIV35HE.MPT190403_2B(:,2),15,'MarkerEdgeColor','#ba274a')
% hold on
% scatter(DIV35HE.MPT190515_4B(:,1),DIV35HE.MPT190515_4B(:,2),15,'+','MarkerEdgeColor','#d84a05')
% scatter(DIV35HE.MPT190515_4C(:,1),DIV35HE.MPT190515_4C(:,2),15,'^','MarkerEdgeColor','#e89005')
% scatter(DIV35HE.MPT200108_1A(:,1),DIV35HE.MPT200108_1A(:,2),15,'MarkerEdgeColor','#deb841')
% scatter(DIV35HE.MPT200108_2B(:,1),DIV35HE.MPT200108_2B(:,2),15,'+','MarkerEdgeColor','#ffe74c')
% scatter(DIV35HE.MPT200115_1A(:,1),DIV35HE.MPT200115_1A(:,2),15,'^','MarkerEdgeColor','#BBD686')
% scatter(DIV35HE.MPT200115_1B(:,1),DIV35HE.MPT200115_1B(:,2),15,'MarkerEdgeColor','#d6ff79')
% scatter(DIV35HE.MPT200115_1C(:,1),DIV35HE.MPT200115_1C(:,2),15,'+','MarkerEdgeColor','#b0ff92')
% scatter(DIV35HE.MPT200115_1D(:,1),DIV35HE.MPT200115_1D(:,2),15,'^','MarkerEdgeColor','#0d00a4')
% scatter(DIV35HE.MPT200205_2A(:,1),DIV35HE.MPT200205_2A(:,2),15,'MarkerEdgeColor','#094d92')
% scatter(DIV35HE.MPT200205_2C(:,1),DIV35HE.MPT200205_2C(:,2),15,'+','MarkerEdgeColor','#540d6e')
% scatter(DIV35HE.MPT200209_1A(:,1),DIV35HE.MPT200209_1A(:,2),15,'^','MarkerEdgeColor','#2c2c54')
% scatter(DIV35HE.MPT200209_1B(:,1),DIV35HE.MPT200209_1B(:,2),15,'MarkerEdgeColor','#505168')
% scatter(DIV35HE.MPT200209_1C(:,1),DIV35HE.MPT200209_1C(:,2),15,'+','MarkerEdgeColor','#ff88dc')
% hold off
xlim([0 1.6])
ylim([0 25])
% set(gca,'xscale','log')
xlabel('Spike Rate (Spikes per Second)')
ylabel('Burst Rate (Bursts per Minute)')
set(gca,'TickDir','Out')
legend
lgd = legend ('WT', 'HET', 'KO')
% lgd = legend ('14', '21', '28','35')
lgd.Location = 'northwest';
title(lgd, 'Genotype')
title('Burst Rates against Spike Rates in HET Cultures')
set(gcf,'Position',[0 0 700 500])