clc; clear; close all;
%% Budyko streamflow attribution
% Pragram provided by Guan Wang(wangguan@nsbddx.com)
% Precipitation 1960-2016 Unit:10^4 m3/Year
load('E:\ChinaStreamflow\2_Streamflow_Sim\1113Station_Rainfall_Yearly_Baipeng.mat');
% Potential Evapotranspiration 1960-2016 Unit:10^4 m3/Year
load('E:\ChinaStreamflow\2_Streamflow_Sim\1113Station_ETrc_Yearly_Baipeng.mat');
% Streamflow 10^4 m3/year 1956-2016
load('E:\ChinaStreamflow\2_Streamflow_Obs\1113Basins_Runoff_1956-2016_year.mat');

clear data_sti_nat_year

% from 1956-2016 to 1960-2016
data_nat_year(1:4,:) = []; data_nat_year = data_nat_year';
data_obs_year(1:4,:) = []; data_obs_year = data_obs_year';
date_year(1:4,:) = []; % from 1956-2016 to 1960-2016
clear Year

% Discern the start and end year of longest continuous data
for iStation = 1 : length(station_list)
    if sum(isnan(data_nat_year(iStation,:))) == 0
        data_nat_start_year(iStation) = 1960;
        data_nat_end_year(iStation) = 2016;
    elseif sum(isnan(data_nat_year(iStation,:))) == 57
        data_nat_start_year(iStation) = nan;
        data_nat_end_year(iStation) = nan;
    else
        index_nan = [0 , find(isnan(data_nat_year(iStation,:))) , length(date_year)+1]; % nan position, adding first and end data
        interval_length = diff(index_nan) - 1; % interval length between each nan
        data_nat_start_year(iStation) = date_year(index_nan(interval_length == max(interval_length))+1);
        data_nat_end_year(iStation) = date_year(index_nan([logical(0) interval_length == max(interval_length)])-1);
        clear index_nan interval_length
    end
end
clear iStation

data_nat_year = data_nat_year';
data_obs_year = data_obs_year';
Station_Rainfall_Yearly_Baipeng = Station_Rainfall_Yearly_Baipeng';
Station_ETrc_Yearly_Baipeng = Station_ETrc_Yearly_Baipeng';

for i_basin = 1 : size(data_nat_year, 2)
    i_basin
    if isnan(data_nat_start_year(i_basin))==0
        data_R = data_nat_year(data_nat_start_year(i_basin)-1959:data_nat_end_year(i_basin)-1959, i_basin);
        data_P = Station_Rainfall_Yearly_Baipeng(data_nat_start_year(i_basin)-1959:data_nat_end_year(i_basin)-1959, i_basin);
        data_E = Station_ETrc_Yearly_Baipeng(data_nat_start_year(i_basin)-1959:data_nat_end_year(i_basin)-1959, i_basin);
        
        % Choudhury-Yang equation
        syms P E n;
        R = P - (P*E/((P^n+E^n)^(1/n)));
        dP = diff(R,P,1);
        dE = diff(R,E,1);
        dn = diff(R,n,1);
        
        P = mean(data_P);
        E = mean(data_E);
        R = mean(data_R);
        if P < R
            P = R .* 1.1;
        end
        if P > R + E
            P = R + E - 0.001;
        end
        syms n; n = solve(P - R == P*E/(P^n+E^n)^(1/n)); n = double(n); % calculate parameter n
        
        epsilon_P = eval(dP*P/R);
        epsilon_E = eval(dE*E/R);
        epsilon_n = eval(dn*n/R);
        
        %% (2) calculate changes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        P1 = mean(Station_Rainfall_Yearly_Baipeng(data_nat_start_year(i_basin)-1959 : data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin))/2), i_basin));
        E1 = mean(Station_ETrc_Yearly_Baipeng(data_nat_start_year(i_basin)-1959 : data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin))/2), i_basin));
        R1 = mean(data_nat_year(data_nat_start_year(i_basin)-1959 : data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin))/2), i_basin));
        R1_obs = nanmean(data_obs_year(data_nat_start_year(i_basin)-1959 : data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin))/2), i_basin));
        
        if P1 < R1
            P1 = R1 .* 1.1;
        end
        if P1 > R1 + E1
            P1 = R1 + E1 - 0.001;
        end
        syms n1; n1 = solve(P1 - R1 == P1*E1/(P1^n1+E1^n1)^(1/n1)); n1 = double(n1); % calculate parameter n1
        
        P2 = mean(Station_Rainfall_Yearly_Baipeng(data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin)+1)/2) : data_nat_end_year(i_basin)-1959, i_basin));
        E2 = mean(Station_ETrc_Yearly_Baipeng(data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin)+1)/2) : data_nat_end_year(i_basin)-1959, i_basin));
        R2 = mean(data_nat_year(data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin)+1)/2) : data_nat_end_year(i_basin)-1959, i_basin));
        R2_obs = nanmean(data_obs_year(data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin)+1)/2) : data_nat_end_year(i_basin)-1959, i_basin));
        
        if P2 < R2
            P2 = R2 .* 1.1;
        end
        if P2 > R2 + E2
            P2 = R2 + E2 - 0.001;
        end
        syms n2; n2 = solve(P2 - R2 == P2*E2/(P2^n2+E2^n2)^(1/n2)); n2 = double(n2); % calculate parameter n2
        
        % calculate contribution rate
        delta2_R = R2 - R1;
        delta2_R_obs = R2_obs - R1_obs;
        delta2_R_P = epsilon_P*R*(P2-P1)/P;
        delta2_R_E = epsilon_E*R*(E2-E1)/E;
        delta2_R_n = epsilon_n*R*(n2-n1)/n;
        delta2_R_e = delta2_R - (delta2_R_P+delta2_R_E+delta2_R_n);
        [~,pt_obs] = ttest2(data_obs_year(data_nat_start_year(i_basin)-1959 : data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin))/2), i_basin)',...
            data_obs_year(data_nat_start_year(i_basin)-1959+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin)+1)/2) : data_nat_end_year(i_basin)-1959, i_basin)');
        
        RC2_P = delta2_R_P/delta2_R*100;  % calculate rate
        RC2_E = delta2_R_E/delta2_R*100;
        RC2_n = delta2_R_n/delta2_R*100;
        RC2_e = delta2_R_e/delta2_R*100;
        
        %% save %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        i_StartYear = data_nat_start_year(i_basin);
        i_ChangeYear = data_nat_start_year(i_basin)+ceil((data_nat_end_year(i_basin)-data_nat_start_year(i_basin))/2);
        i_EndYear = data_nat_end_year(i_basin);
        
        a = [i_StartYear, i_ChangeYear, i_EndYear, epsilon_P, epsilon_E, epsilon_n, ...
            delta2_R, delta2_R_obs, pt_obs, delta2_R_P, delta2_R_E, delta2_R_n, delta2_R_e, ...
            RC2_P, RC2_E, RC2_n, RC2_e, R1, R2, P1, P2, E1, E2, n1, n2];
        
        BudykoResult([1:length(a)], i_basin) = a; clear a;
        
    else
        BudykoResult(1:25, i_basin) = nan;
    end
    clear data_R data_P data_E
    clear n P R E n1 P1 R1 E1 n2 P2 R2 E2 R1_obs R2_obs
    clear i_StartYear i_ChangeYear i_EndYear
    clear epsilon_P epsilon_E epsilon_n
    clear delta2_R delta2_R_obs pt_obs delta2_R_P delta2_R_E delta2_R_n delta2_R_e
    clear RC2_P RC2_E RC2_n RC2_e
end

%% Calculate Attribution Rate
% Climate Change and Variability
CCV = (BudykoResult(10,:) + BudykoResult(11,:)) ./ BudykoResult(8,:) .* 100;
CCV = CCV';
% Land Use Change
LUCC = BudykoResult(12,:) ./ BudykoResult(8,:) .* 100;
LUCC = LUCC';
% Anthropogenic abstraction, diversion, regulation AADR
AADR = (BudykoResult(8,:) - BudykoResult(7,:)) ./ BudykoResult(8,:) .* 100;
AADR = AADR';
% Error
Error = BudykoResult(13,:) ./ BudykoResult(8,:) .* 100;
Error = Error';

save('BudykoResult.mat','BudykoResult','CCV','LUCC','AADR','Error');

%% Plotting
Plot_Budyko_CCVLUCCAADR;
Plot_Budyko_CCVLUCCAADR_ColorPs;

%% Export outputs
% (6.1) Dominant Factor,1:CCV,2:LUCC,3:AADR,4:CCV+LUCC,5:CCV+AADR,6:LUCC+AADR,
Dom_F = nan(length(CCV),1);
for iBasin = 1 : length(CCV)
    if CCV(iBasin)>60 && LUCC(iBasin)<60 && AADR(iBasin)<60
        Dom_F(iBasin) = 1;
    elseif LUCC(iBasin)>60 && CCV(iBasin)<60 && AADR(iBasin)<60
        Dom_F(iBasin) = 2;
    elseif AADR(iBasin)>60 && CCV(iBasin)<60 && LUCC(iBasin)<60
        Dom_F(iBasin) = 3;
    elseif CCV(iBasin)>40 && LUCC(iBasin)>40 && CCV(iBasin)+LUCC(iBasin)>60 && AADR(iBasin)<60
        Dom_F(iBasin) = 4;
    elseif CCV(iBasin)>40 && AADR(iBasin)>40 && CCV(iBasin)+AADR(iBasin)>60 && LUCC(iBasin)<60
        Dom_F(iBasin) = 5;
    elseif LUCC(iBasin)>40 && AADR(iBasin)>40 && LUCC(iBasin)+AADR(iBasin)>60 && CCV(iBasin)<60
        Dom_F(iBasin) = 6;
    else
        Dom_F(iBasin) = 7;
    end
end





