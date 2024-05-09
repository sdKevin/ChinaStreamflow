function Plot_ACCNCV(delta_obs,pt_obs,ACC,NCV)
figure;
Edges = [-200:10:200];
Attribution = [-195:10:195];
% Anthropogenic Cliamte Change
subplot(2,2,1);
N_Neg = histcounts(ACC(delta_obs<0),Edges);
N_Pos = histcounts(ACC(delta_obs>0),Edges);
N_Neg_Sig = histcounts(ACC(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(ACC(delta_obs>0 & pt_obs<0.1),Edges);

H_ACC = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_ACC(1, 1).FaceColor = [178,24,43]./255; H_ACC(1, 2).FaceColor = [33,102,172]./255;
hold on;
plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[244,109,67]./255,'MarkerFaceColor',[244,109,67]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[116,173,209]./255,'MarkerFaceColor',[116,173,209]./255);
title('Anthropogenic Cliamte Change','FontSize',15,'FontName','Arial','FontWeight','Bold');
ylabel('Number of stations'); legend('Decrease','Increase','Decrease significantly','Increase significantly','Box','off','FontSize',15,'FontName','Arial','FontWeight','Bold');

text(-180,110,num2str(sum(ACC<0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,110,['(',num2str(sum(ACC<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,100,num2str(sum(ACC<0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,100,['(',num2str(sum(ACC<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

text(130,110,num2str(sum(ACC>=0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,110,['(',num2str(sum(ACC>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,100,num2str(sum(ACC>=0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,100,['(',num2str(sum(ACC>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

axes('position',get(gca,'position'))
plot([0 0] , [0 150] , 'k-','LineWidth',1.5);
set(gca,'xlim',[-208 208],'ylim',[0 140],'visible','off');

% Natural Climate Variability
subplot(2,2,2);
N_Neg = histcounts(NCV(delta_obs<0),Edges);
N_Pos = histcounts(NCV(delta_obs>0),Edges);
N_Neg_Sig = histcounts(NCV(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(NCV(delta_obs>0 & pt_obs<0.1),Edges);

H_NCV = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_NCV(1, 1).FaceColor = [178,24,43]./255; H_NCV(1, 2).FaceColor = [33,102,172]./255;
hold on; plot([0 0] , [0 80] , 'k-','LineWidth',1.5);
plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[244,109,67]./255,'MarkerFaceColor',[244,109,67]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[116,173,209]./255,'MarkerFaceColor',[116,173,209]./255);
title('Natural Climate Variability','FontSize',15,'FontName','Arial','FontWeight','Bold');

text(-180,75,num2str(sum(NCV<0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,75,['(',num2str(sum(NCV<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,68,num2str(sum(NCV<0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,68,['(',num2str(sum(NCV<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

text(130,75,num2str(sum(NCV>=0 & delta_obs<0)),'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,75,['(',num2str(sum(NCV>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,68,num2str(sum(NCV>=0 & delta_obs>0)),'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,68,['(',num2str(sum(NCV>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

% Anthropogenic Cliamte Change Color PS
subplot(2,2,3);
N_Neg = histcounts(ACC(delta_obs<0),Edges);
N_Pos = histcounts(ACC(delta_obs>0),Edges);
N_Neg_Sig = histcounts(ACC(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(ACC(delta_obs>0 & pt_obs<0.1),Edges);

H_ACC = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_ACC(1, 1).FaceColor = [244,109,67]./255; H_ACC(1, 2).FaceColor = [116,173,209]./255;
hold on;
plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[178,24,43]./255,'MarkerFaceColor',[178,24,43]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[33,102,172]./255,'MarkerFaceColor',[33,102,172]./255);
title('Anthropogenic Cliamte Change','FontSize',15,'FontName','Arial','FontWeight','Bold');
ylabel('Number of stations'); legend('Decrease','Increase','Decrease significantly','Increase significantly','Box','off','FontSize',15,'FontName','Arial','FontWeight','Bold');

text(-180,110,num2str(sum(ACC<0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,110,['(',num2str(sum(ACC<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,100,num2str(sum(ACC<0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,100,['(',num2str(sum(ACC<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

text(130,110,num2str(sum(ACC>=0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,110,['(',num2str(sum(ACC>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,100,num2str(sum(ACC>=0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,100,['(',num2str(sum(ACC>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

axes('position',get(gca,'position'))
plot([0 0] , [0 150] , 'k-','LineWidth',1.5);
set(gca,'xlim',[-208 208],'ylim',[0 140],'visible','off');

% Natural Climate Variability Color PS
subplot(2,2,4);
N_Neg = histcounts(NCV(delta_obs<0),Edges);
N_Pos = histcounts(NCV(delta_obs>0),Edges);
N_Neg_Sig = histcounts(NCV(delta_obs<0 & pt_obs<0.1),Edges);
N_Pos_Sig = histcounts(NCV(delta_obs>0 & pt_obs<0.1),Edges);

H_NCV = bar(Attribution,[N_Neg',N_Pos'],'stacked','BarWidth',1,'EdgeColor','w');
H_NCV(1, 1).FaceColor = [244,109,67]./255; H_NCV(1, 2).FaceColor = [116,173,209]./255;
hold on; plot([0 0] , [0 80] , 'k-','LineWidth',1.5);
plot(Attribution,N_Neg_Sig,'s','MarkerSize',4,'MarkerEdgeColor',[178,24,43]./255,'MarkerFaceColor',[178,24,43]./255);
plot(Attribution,N_Pos_Sig+N_Neg_Sig,'o','MarkerSize',4,'MarkerEdgeColor',[33,102,172]./255,'MarkerFaceColor',[33,102,172]./255);
title('Natural Climate Variability','FontSize',15,'FontName','Arial','FontWeight','Bold');

text(-180,75,num2str(sum(NCV<0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,75,['(',num2str(sum(NCV<0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-180,68,num2str(sum(NCV<0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(-150,68,['(',num2str(sum(NCV<0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

text(130,75,num2str(sum(NCV>=0 & delta_obs<0)),'Color',[244,109,67]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,75,['(',num2str(sum(NCV>=0 & delta_obs<0 & pt_obs<0.1)),')'],'Color',[178,24,43]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(130,68,num2str(sum(NCV>=0 & delta_obs>0)),'Color',[116,173,209]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');
text(160,68,['(',num2str(sum(NCV>=0 & delta_obs>0 & pt_obs<0.1)),')'],'Color',[33,102,172]./255,'FontSize',15,'FontName','Arial','FontWeight','Bold');

set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);
end

