function Plot_Budyko_CCVLUCCAADR_ColorPs
load BudykoResult
delta_obs = BudykoResult(8,:)'; pt_obs = BudykoResult(9,:)';
Edges = [-200:10:200];
Attribution = [-195:10:195];

figure;
% Agreement and Correlation
subplot(2,8,[1 2]);
R1 = corrcoef(BudykoResult(7,~isnan(BudykoResult(8,:))),BudykoResult(8,~isnan(BudykoResult(8,:))));
bar([sum(sign(BudykoResult(7,:))==sign(BudykoResult(8,:)))/sum(~isnan(BudykoResult(8,:))) ,...
    R1(2)] , 'FaceColor' , [1,102,94]./255);
hold on;
plot([0,3],[0.5 0.5],'k--','LineWidth',3); hold on;
xticks([1:2]); xlim([0 3]);
xticklabels({'Agreement','Correlation'})
title('Budyko Performance','FontSize',15,'FontName','Arial','FontWeight','Bold');
set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

% Anthropogenic Cliamte Change
subplot(2,2,2);
N_Neg = histcounts(CCV(delta_obs<0),Edges);
N_Pos = histcounts(CCV(delta_obs>0),Edges);
N_Neg_Sig = histcounts(CCV(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(CCV(delta_obs>0 & pt_obs<0.1),Edges);

H_ACC = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_ACC(1, 1).FaceColor = [244,109,67]./255; H_ACC(1, 2).FaceColor = [116,173,209]./255;
hold on;

plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[178,24,43]./255,'MarkerFaceColor',[178,24,43]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[33,102,172]./255,'MarkerFaceColor',[33,102,172]./255);
plot([0 0] , [0 80] , 'k-','LineWidth',1.5);
title('Climate Change and Variability','FontSize',15,'FontName','Arial','FontWeight','Bold');
ylabel('Number of stations'); legend('Decrease','Increase','Decrease significantly','Increase significantly','Box','off','FontSize',15,'FontName','Arial','FontWeight','Bold');

text(-180,75,num2str(sum(CCV<0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,75,['(',num2str(sum(CCV<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,65,num2str(sum(CCV<0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,65,['(',num2str(sum(CCV<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

text(130,75,num2str(sum(CCV>=0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,75,['(',num2str(sum(CCV>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,65,num2str(sum(CCV>=0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,65,['(',num2str(sum(CCV>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

% Land Use/Cover change
subplot(2,2,3);
N_Neg = histcounts(LUCC(delta_obs<0),Edges);
N_Pos = histcounts(LUCC(delta_obs>0),Edges);
N_Neg_Sig = histcounts(LUCC(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(LUCC(delta_obs>0 & pt_obs<0.1),Edges);

H_LUCC = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_LUCC(1, 1).FaceColor = [244,109,67]./255; H_LUCC(1, 2).FaceColor = [116,173,209]./255;
hold on; plot([0 0] , [0 80] , 'k-','LineWidth',1.5);

plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[178,24,43]./255,'MarkerFaceColor',[178,24,43]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[33,102,172]./255,'MarkerFaceColor',[33,102,172]./255);
title('Land Use/Cover Change','FontSize',15,'FontName','Arial','FontWeight','Bold');
xlabel('Contribution rate (%)'); ylabel('Number of stations');

% 
text(-180,75,num2str(sum(LUCC<0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,75,['(',num2str(sum(LUCC<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,65,num2str(sum(LUCC<0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,65,['(',num2str(sum(LUCC<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

% 
text(130,75,num2str(sum(LUCC>=0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,75,['(',num2str(sum(LUCC>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,65,num2str(sum(LUCC>=0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,65,['(',num2str(sum(LUCC>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

% Anthropogenic water Abstraction, Diversion and Regulation
subplot(2,2,4);
N_Neg = histcounts(AADR(delta_obs<0),Edges);
N_Pos = histcounts(AADR(delta_obs>0),Edges);
N_Neg_Sig = histcounts(AADR(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(AADR(delta_obs>0 & pt_obs<0.1),Edges);

H_AADR = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_AADR(1, 1).FaceColor = [244,109,67]./255; H_AADR(1, 2).FaceColor = [116,173,209]./255;
hold on; plot([0 0] , [0 400] , 'k-','LineWidth',1.5);
plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[178,24,43]./255,'MarkerFaceColor',[178,24,43]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[33,102,172]./255,'MarkerFaceColor',[33,102,172]./255);
title('Anthropogenic water Abstraction, Diversion and Regulation','FontSize',15,'FontName','Arial','FontWeight','Bold');
xlabel('Contribution rate (%)');

%
text(-180,365,num2str(sum(AADR<0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,365,['(',num2str(sum(AADR<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,325,num2str(sum(AADR<0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,325,['(',num2str(sum(AADR<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

%
text(130,365,num2str(sum(AADR>=0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,365,['(',num2str(sum(AADR>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,325,num2str(sum(AADR>=0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,325,['(',num2str(sum(AADR>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);
end
