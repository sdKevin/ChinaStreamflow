function Plot_CCVLUCCAADR(delta_ISIMIP_Close_obs,delta_ISIMIP_Close_nat1,delta_obs,delta_nat,pt_obs,CCV,LUCC,HHI)
% Start plotting
Edges = [-200:10:200];
Attribution = [-195:10:195];
figure;
% Agreement and Correlation
subplot(2,2,1);
R1 = corrcoef(delta_ISIMIP_Close_obs(~isnan(delta_obs)),delta_obs(~isnan(delta_obs)));
R2 = corrcoef(delta_ISIMIP_Close_nat1(~isnan(delta_nat)),delta_nat(~isnan(delta_nat)));
bar([sum(sign(delta_ISIMIP_Close_obs)==sign(delta_obs))/sum(~isnan(delta_obs)) ,...
    sum(sign(delta_ISIMIP_Close_nat1)==sign(delta_nat))/sum(~isnan(delta_obs)) ,...
    R1(2) , R2(2)] , 'FaceColor' , [1,102,94]./255);
hold on;
plot([0,5],[0.5 0.5],'k--','LineWidth',3); hold on;
xticks([1:4]); xlim([0 5]);
xticklabels({'Agreement-obs','nat','Correlation-obs','nat'})
title('ISIMIP Performance','FontSize',15,'FontName','Arial','FontWeight','Bold');
set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

% Anthropogenic Cliamte Change
subplot(2,2,2);
N_Neg = histcounts(CCV(delta_obs<0),Edges);
N_Pos = histcounts(CCV(delta_obs>0),Edges);
N_Neg_Sig = histcounts(CCV(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(CCV(delta_obs>0 & pt_obs<0.1),Edges);

H_ACC = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_ACC(1, 1).FaceColor = [178,24,43]./255; H_ACC(1, 2).FaceColor = [33,102,172]./255;
hold on;

plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[244,109,67]./255,'MarkerFaceColor',[244,109,67]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[116,173,209]./255,'MarkerFaceColor',[116,173,209]./255);
plot([0 0] , [0 80] , 'k-','LineWidth',1.5);
title('Climate Change and Variability','FontSize',15,'FontName','Arial','FontWeight','Bold');
ylabel('Number of stations'); legend('Decrease','Increase','Decrease significantly','Increase significantly','Box','off','FontSize',15,'FontName','Arial','FontWeight','Bold');

text(-180,75,num2str(sum(CCV<0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,75,['(',num2str(sum(CCV<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,65,num2str(sum(CCV<0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,65,['(',num2str(sum(CCV<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

text(130,75,num2str(sum(CCV>=0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,75,['(',num2str(sum(CCV>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,65,num2str(sum(CCV>=0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,65,['(',num2str(sum(CCV>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

% Land Use/Cover change
subplot(2,2,3);
N_Neg = histcounts(LUCC(delta_obs<0),Edges);
N_Pos = histcounts(LUCC(delta_obs>0),Edges);
N_Neg_Sig = histcounts(LUCC(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(LUCC(delta_obs>0 & pt_obs<0.1),Edges);

H_LUCC = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_LUCC(1, 1).FaceColor = [178,24,43]./255; H_LUCC(1, 2).FaceColor = [33,102,172]./255;
hold on; plot([0 0] , [0 80] , 'k-','LineWidth',1.5);

plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[244,109,67]./255,'MarkerFaceColor',[244,109,67]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[116,173,209]./255,'MarkerFaceColor',[116,173,209]./255);
title('Land Use/Cover Change','FontSize',15,'FontName','Arial','FontWeight','Bold');
xlabel('Contribution rate (%)'); ylabel('Number of stations');

%
text(-180,75,num2str(sum(LUCC<0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,75,['(',num2str(sum(LUCC<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,65,num2str(sum(LUCC<0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,65,['(',num2str(sum(LUCC<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

%
text(130,75,num2str(sum(LUCC>=0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,75,['(',num2str(sum(LUCC>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,65,num2str(sum(LUCC>=0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,65,['(',num2str(sum(LUCC>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

% Anthropogenic water Abstraction, Diversion and Regulation
subplot(2,2,4);
N_Neg = histcounts(HHI(delta_obs<0),Edges);
N_Pos = histcounts(HHI(delta_obs>0),Edges);
N_Neg_Sig = histcounts(HHI(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(HHI(delta_obs>0 & pt_obs<0.1),Edges);

H_HHI = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_HHI(1, 1).FaceColor = [178,24,43]./255; H_HHI(1, 2).FaceColor = [33,102,172]./255;
hold on; plot([0 0] , [0 400] , 'k-','LineWidth',1.5);
plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[244,109,67]./255,'MarkerFaceColor',[244,109,67]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[116,173,209]./255,'MarkerFaceColor',[116,173,209]./255);
title('Anthropogenic water Abstraction, Diversion and Regulation','FontSize',15,'FontName','Arial','FontWeight','Bold');
xlabel('Contribution rate (%)');

%
text(-180,365,num2str(sum(HHI<0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,365,['(',num2str(sum(HHI<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,325,num2str(sum(HHI<0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,325,['(',num2str(sum(HHI<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

%
text(130,365,num2str(sum(HHI>=0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,365,['(',num2str(sum(HHI>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,325,num2str(sum(HHI>=0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,325,['(',num2str(sum(HHI>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

end

