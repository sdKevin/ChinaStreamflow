%% Annual Streanflow Climatological Change Attribution
clc; clear all; close all;

%% (1) Load Observation-based Streamflow (Unit: 10^4 m3 per year)
% Streamflow observations provided by Ministry of Water Resources
load('E:\ChinaStreamflow\2_Streamflow_Obs\1113Basins_Runoff_1956-2016_year.mat');
data_nat_year = data_nat_year'; % Each row represent a station, each column represent a year
data_obs_year = data_obs_year'; % Each row represent a station, each column represent a year
data_sti_nat_year = data_sti_nat_year'; % Each row represent a station, each column represent a year
% Discern the start and end year of longest continuous data
for iStation = 1 : length(station_list)
    if sum(isnan(data_nat_year(iStation,:))) == 0
        data_nat_start_year(iStation) = 1956;
        data_nat_end_year(iStation) = 2016;
    elseif sum(isnan(data_nat_year(iStation,:))) == 61
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
for iStation = 1 : length(station_list)
    if sum(isnan(data_sti_nat_year(iStation,:))) == 0
        data_sti_nat_start_year(iStation) = 1956;
        data_sti_nat_end_year(iStation) = 2016;
    elseif sum(isnan(data_sti_nat_year(iStation,:))) == 61
        data_sti_nat_start_year(iStation) = nan;
        data_sti_nat_end_year(iStation) = nan;
    else
        index_nan = [0 , find(isnan(data_sti_nat_year(iStation,:))) , length(date_year)+1]; % nan position, adding first and end data
        interval_length = diff(index_nan) - 1; % interval length between each nan
        data_sti_nat_start_year(iStation) = date_year(index_nan(interval_length == max(interval_length))+1);
        data_sti_nat_end_year(iStation) = date_year(index_nan([logical(0) interval_length == max(interval_length)])-1);
        clear index_nan interval_length
    end
end
for iStation = 1 : length(station_list)
    if sum(isnan(data_obs_year(iStation,:))) == 0
        data_obs_start_year(iStation) = 1956;
        data_obs_end_year(iStation) = 2016;
    elseif sum(isnan(data_obs_year(iStation,:))) == 61
        data_obs_start_year(iStation) = nan;
        data_obs_end_year(iStation) = nan;
    else
        index_nan = [0 , find(isnan(data_obs_year(iStation,:))) , length(date_year)+1]; % nan position, adding first and end data
        interval_length = diff(index_nan) - 1; % interval length between each nan
        data_obs_start_year(iStation) = date_year(index_nan(interval_length == max(interval_length))+1);
        data_obs_end_year(iStation) = date_year(index_nan([logical(0) interval_length == max(interval_length)])-1);
        clear index_nan interval_length
    end
end
clear iStation date_year

% ISIMIP Streamflow simulations 1901-2019
load('E:\ChinaStreamflow\2_Streamflow_Sim\1113Station_NatRunoff_Yearly_ISIMIP3a.mat');
load('E:\ChinaStreamflow\2_Streamflow_Sim\1113Station_Counterclim_NatRunoff_Yearly_ISIMIP3a.mat');
load('E:\ChinaStreamflow\2_Streamflow_Sim\1113Station_ObsRunoff_Yearly_ISIMIP3a.mat');
load('E:\ChinaStreamflow\2_Streamflow_Sim\1113Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a.mat');
clear Year
% Start and End Year
StartYear = data_obs_start_year;
EndYear = data_obs_end_year;
clear data_nat_start_year data_nat_end_year data_sti_nat_start_year data_sti_nat_end_year data_obs_start_year data_obs_end_year

% Smooth and Scale ISIMIP outputs by assuming all ISIMIP simulations = observation-based values during 1956-1960
for iBasin = 1 : length(station_list)
    % Scale ISIMIP
    if ~isnan(StartYear(iBasin))
        for iGHM = 1 : size(Station_ObsRunoff_Yearly_ISIMIP3a,3)
            Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = smoothdata(Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM),'rlowess',10)';
            Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = nanmean(data_obs_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+4)) ./ ...
                mean(Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+4 , iGHM)') .* Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM);
            
            Station_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = smoothdata(Station_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM),'rlowess',10)';
            Station_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = nanmean(data_obs_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+4)) ./ ...
                mean(Station_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+4 , iGHM)') .* Station_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM);
            
            Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = smoothdata(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM),'rlowess',10)';
            Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = nanmean(data_obs_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+4)) ./ ...
                mean(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+4 , iGHM)') .* Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM);
            
            Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = smoothdata(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM),'rlowess',10)';
            Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM) = nanmean(data_obs_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+4)) ./ ...
                mean(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+4 , iGHM)') .* Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , : , iGHM);
        end
    end
end
clear iBasin iGHM GHM_Ensemble

%% (2) Climatological Change of Annual Streamflow
% observation-based streamflow data
delta_nat = nan(length(station_list),1); pt_nat = nan(length(station_list),1);
delta_sti_nat = nan(length(station_list),1); pt_sti_nat = nan(length(station_list),1);
delta_obs = nan(length(station_list),1); pt_obs = nan(length(station_list),1);

% ISIMIP models
delta_ISIMIP_nat1 = nan(length(station_list),3); pt_ISIMIP_nat1 = nan(length(station_list),3);
delta_ISIMIP_counter_nat1 = nan(length(station_list),3); pt_ISIMIP_counter_nat1 = nan(length(station_list),3);
delta_ISIMIP_obs = nan(length(station_list),3); pt_ISIMIP_obs = nan(length(station_list),3);
delta_ISIMIP_counter_obs = nan(length(station_list),3); pt_ISIMIP_counter_obs = nan(length(station_list),3);

% Calculate correlation between Station_ObsRunoff_Yearly_ISIMIP3a and data_obs_year
R_obs = nan(length(station_list),1);

% Calculate Annual Streanflow Climatological Change
for iBasin = 1 : length(station_list)
    % data_nat_year Streamflow
    if isnan(StartYear(iBasin))
        delta_nat(iBasin,1) = nan; pt_nat(iBasin,1) = nan;
    else
        try
            delta_nat(iBasin,1) = nanmean(data_nat_year(iBasin , StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1955)') - ...
                nanmean(data_nat_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_nat(iBasin,1)] = ttest2(data_nat_year(iBasin , StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1955)',...
                data_nat_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
        end
    end
    
    % data_sti_nat_year Streamflow
    if isnan(StartYear(iBasin))
        delta_sti_nat(iBasin,1) = nan; pt_sti_nat(iBasin,1) = nan;
    else
        try
            delta_sti_nat(iBasin,1) = nanmean(data_sti_nat_year(iBasin , StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1955)') - ...
                nanmean(data_sti_nat_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_sti_nat(iBasin,1)] = ttest2(data_sti_nat_year(iBasin , StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1955)',...
                data_sti_nat_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
        end
    end
    
    % data_obs_year Streamflow
    if isnan(StartYear(iBasin))
        delta_obs(iBasin,1) = nan; pt_obs(iBasin,1) = nan;
    else
        try
            delta_obs(iBasin,1) = nanmean(data_obs_year(iBasin , StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1955)') - ...
                nanmean(data_obs_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_obs(iBasin,1)] = ttest2(data_obs_year(iBasin , StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1955)',...
                data_obs_year(iBasin , StartYear(iBasin)-1955:StartYear(iBasin)-1955+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
        end
    end
    
    % ISIMIP Observed Streamflow simulations
    if isnan(StartYear(iBasin))
        delta_ISIMIP_obs(iBasin,1) = nan; pt_ISIMIP_obs(iBasin,1) = nan;
    else
        try
            for iGHM = 1 : size(Station_ObsRunoff_Yearly_ISIMIP3a,3)
                delta_ISIMIP_obs(iBasin,iGHM) = nanmean(Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)') - ...
                    nanmean(Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
                [~,pt_ISIMIP_obs(iBasin,iGHM)] = ttest2(Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)',...
                    Station_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
            end
            
            % Chose the GHM result which is closest to delta_obs and denote as delta_ISIMIP_Close_obs
            if sum(sign(delta_obs(iBasin,1))==sign(delta_ISIMIP_obs(iBasin,:)))==0 || sum(sign(delta_obs(iBasin,1))==sign(delta_ISIMIP_obs(iBasin,:)))==3
                [~ , Index_obs(iBasin,1)] = min(abs(delta_obs(iBasin,1) - delta_ISIMIP_obs(iBasin,:)));
                delta_ISIMIP_Close_obs(iBasin,1) = delta_ISIMIP_obs(iBasin,Index_obs(iBasin,1));
            elseif sum(sign(delta_obs(iBasin,1))==sign(delta_ISIMIP_obs(iBasin,:)))==1
                Index_obs(iBasin,1) = find((sign(delta_obs(iBasin,1))==sign(delta_ISIMIP_obs(iBasin,:)))==1);
                delta_ISIMIP_Close_obs(iBasin,1) = delta_ISIMIP_obs(iBasin,Index_obs(iBasin,1));
            elseif sum(sign(delta_obs(iBasin,1))==sign(delta_ISIMIP_obs(iBasin,:)))==2
                AA = find((sign(delta_obs(iBasin,1))==sign(delta_ISIMIP_obs(iBasin,:)))==1);
                [~ , AAA] = min(abs(delta_obs(iBasin,1) - delta_ISIMIP_obs(iBasin,AA)));
                Index_obs(iBasin,1) = AA(AAA);
                delta_ISIMIP_Close_obs(iBasin,1) = delta_ISIMIP_obs(iBasin,Index_obs(iBasin,1)); clear AA AAA;
            end
            
            % GHM Ensemble mean
            AA = mean(Station_ObsRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMean_obs(iBasin,1) = nanmean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                nanmean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMean_obs(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
            
            % GHM Ensemble median
            AA = median(Station_ObsRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMedian_obs(iBasin,1) = nanmean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                nanmean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMedian_obs(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
        end
    end
    
    % Calculate correlation between Station_ObsRunoff_Yearly_ISIMIP3a and data_obs_year
    try
        R = corrcoef(Station_ObsRunoff_Yearly_ISIMIP3a(iBasin,StartYear(iBasin)-1900:EndYear(iBasin)-1900,Index_obs(iBasin,1)),data_obs_year(iBasin,StartYear(iBasin)-1955:EndYear(iBasin)-1955));
        R_obs(iBasin,1) = R(2); clear R;
    end
    
    % ISIMIP Counterclimate_Observed Streamflow simulations
    if isnan(StartYear(iBasin))
        delta_ISIMIP_counter_obs(iBasin,1) = nan; pt_ISIMIP_counter_obs(iBasin,1) = nan;
    else
        try
            for iGHM = 1 : size(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a,3)
                delta_ISIMIP_counter_obs(iBasin,iGHM) = mean(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)') - ...
                    mean(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
                [~,pt_ISIMIP_counter_obs(iBasin,iGHM)] = ttest2(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)',...
                    Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
            end
            
            % Chose the GHM result which is closet to delta_obs and denote as delta_ISIMIP_Close_obs
            delta_ISIMIP_Close_counter_obs(iBasin,1) = delta_ISIMIP_counter_obs(iBasin,Index_obs(iBasin,1));
            
            % GHM Ensemble mean
            AA = mean(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMean_counter_obs(iBasin,1) = mean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                mean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMean_counter_obs(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
            
            % GHM Ensemble median
            AA = median(Station_Counterclim_ObsRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMedian_counter_obs(iBasin,1) = mean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                mean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMedian_counter_obs(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
        end
    end
    
    
    % ISIMIP Naturalized Streamflow simulations
    if isnan(StartYear(iBasin))
        delta_ISIMIP_nat1(iBasin,1) = nan; pt_ISIMIP_nat1(iBasin,1) = nan;
    else
        try
            for iGHM = 1 : size(Station_NatRunoff_Yearly_ISIMIP3a,3)
                delta_ISIMIP_nat1(iBasin,iGHM) = mean(Station_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)') - ...
                    mean(Station_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
                [~,pt_ISIMIP_nat1(iBasin,iGHM)] = ttest2(Station_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)',...
                    Station_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
            end
            
            %             if sum(sign(delta_nat(iBasin,1))==sign(delta_ISIMIP_nat1(iBasin,:)))==0 || sum(sign(delta_nat(iBasin,1))==sign(delta_ISIMIP_nat1(iBasin,:)))==3
            %                 [~ , Index_nat(iBasin,1)] = min(abs(delta_nat(iBasin,1) - delta_ISIMIP_nat1(iBasin,:)));
            %                 delta_ISIMIP_Close_nat1(iBasin,1) = delta_ISIMIP_nat1(iBasin,Index_nat(iBasin,1));
            %             elseif sum(sign(delta_nat(iBasin,1))==sign(delta_ISIMIP_nat1(iBasin,:)))==1
            %                 Index_nat(iBasin,1) = find((sign(delta_nat(iBasin,1))==sign(delta_ISIMIP_nat1(iBasin,:)))==1);
            %                 delta_ISIMIP_Close_nat1(iBasin,1) = delta_ISIMIP_nat1(iBasin,Index_nat(iBasin,1));
            %             elseif sum(sign(delta_nat(iBasin,1))==sign(delta_ISIMIP_nat1(iBasin,:)))==2
            %                 AA = find((sign(delta_nat(iBasin,1))==sign(delta_ISIMIP_nat1(iBasin,:)))==1);
            %                 [~ , AAA] = min(abs(delta_nat(iBasin,1) - delta_ISIMIP_nat1(iBasin,AA)));
            %                 Index_nat(iBasin,1) = AA(AAA);
            %                 delta_ISIMIP_Close_nat1(iBasin,1) = delta_ISIMIP_nat1(iBasin,Index_nat(iBasin,1)); clear AA AAA;
            %             end
            
            % Chose the GHM result which is closet to delta_obs and denote as delta_ISIMIP_Close_obs
            delta_ISIMIP_Close_nat1(iBasin,1) = delta_ISIMIP_obs(iBasin,Index_obs(iBasin,1));
            
            % GHM Ensemble mean
            AA = mean(Station_NatRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMean_nat1(iBasin,1) = mean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                mean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMean_nat1(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
            
            % GHM Ensemble median
            AA = median(Station_NatRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMedian_nat1(iBasin,1) = mean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                mean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMedian_nat1(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
        end
    end
    
    % ISIMIP Counterclimate_Naturalized Streamflow simulations
    if isnan(StartYear(iBasin))
        delta_ISIMIP_counter_nat1(iBasin,1) = nan; pt_ISIMIP_counter_nat1(iBasin,1) = nan;
    else
        try
            for iGHM = 1 : size(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a,3)
                delta_ISIMIP_counter_nat1(iBasin,iGHM) = mean(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)') - ...
                    mean(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
                [~,pt_ISIMIP_counter_nat1(iBasin,iGHM)] = ttest2(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900 , iGHM)',...
                    Station_Counterclim_NatRunoff_Yearly_ISIMIP3a(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2) , iGHM)');
            end
            
            % Chose the GHM result which is closet to delta_obs and denote as delta_ISIMIP_Close_obs
            delta_ISIMIP_Close_counter_nat1(iBasin,1) = delta_ISIMIP_counter_nat1(iBasin,Index_obs(iBasin,1));
            
            % GHM Ensemble mean
            AA = mean(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMean_counter_nat1(iBasin,1) = mean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                mean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMean_counter_nat1(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
            
            % GHM Ensemble median
            AA = median(Station_Counterclim_NatRunoff_Yearly_ISIMIP3a,3);
            delta_ISIMIP_EnsembleMedian_counter_nat1(iBasin,1) = mean(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)') - ...
                mean(AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))');
            [~,pt_ISIMIP_EnsembleMedian_counter_nat1(iBasin,1)] = ttest2(AA(iBasin , StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin)+1)/2):EndYear(iBasin)-1900)',...
                AA(iBasin , StartYear(iBasin)-1900:StartYear(iBasin)-1900+ceil((EndYear(iBasin)-StartYear(iBasin))/2))'); clear AA;
        end
    end
end

%% (3) ISIMIP Attribution Analysis
% choose all stations
ChosenStation = logical(ones(1113,1));
% ChosenStation = (sign(delta_ISIMIP_Close_nat1)==sign(delta_nat)); % choose stations whose estimated trends are the same with observed
% ChosenStation = (sign(delta_ISIMIP_EnsembleMean_obs)==sign(delta_obs))&(pt_obs<0.1); % choose stations whose estimated trends are the same with observed
% Anthropogenic Cliamte Change
ACC = (delta_ISIMIP_Close_nat1(ChosenStation) - delta_ISIMIP_Close_counter_nat1(ChosenStation)) ./ delta_obs(ChosenStation) .* 100;
% Natural Climate Variability
NCV = (delta_ISIMIP_Close_counter_nat1(ChosenStation)) ./ delta_obs(ChosenStation) .* 100;
% Climate Change and Variability
CCV = ACC + NCV;
% LUCC
LUCC = (delta_nat(ChosenStation) - delta_ISIMIP_Close_nat1(ChosenStation)) ./ delta_obs(ChosenStation) .* 100;
% Anthropogenic abstraction, diversion, regulation AADR
AADR = (delta_obs(ChosenStation) - delta_nat(ChosenStation)) ./ delta_obs(ChosenStation) .* 100;

% Select stations whose estimated trends are the same with observed
delta_obs = delta_obs(ChosenStation); pt_obs = pt_obs(ChosenStation);

save('ISIMIPResult.mat','CCV','LUCC','AADR','delta_obs');

%% (4) Plotting ISIMIP Performance (a), CCV (b), LUCC (c), AADR (d)
Plot_CCVLUCCAADR(delta_ISIMIP_Close_obs,delta_ISIMIP_Close_nat1,delta_obs,delta_nat,pt_obs,CCV,LUCC,AADR)

% Change Color for PS
Plot_CCVLUCCAADR_ColorPs(delta_obs,delta_nat,delta_ISIMIP_Close_obs,delta_ISIMIP_Close_nat1,pt_obs,CCV,LUCC,AADR)

%% (5) Plotting ISIMIP ACC (a), NCV (b)
Plot_ACCNCV(delta_obs,pt_obs,ACC,NCV);

%% (6) Export outputs
% (6.1) Dominant Factor,1:CCV,2:LUCC,3:AADR,4:CCV+LUCC,5:CCV+AADR,6:LUCC+AADR,
Dom_F = nan(length(station_list),1);
for iBasin = 1 : length(station_list)
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

% (6.2) Station Statistics
Sig = [sum(delta_obs<0),sum(delta_obs<0 & pt_obs<0.1),sum(delta_obs<0 & pt_obs<0.05);
    nan,sum(delta_obs<0 & pt_obs>0.1),sum(delta_obs<0 & pt_obs>0.05);
    sum(delta_obs>0),sum(delta_obs>0 & pt_obs<0.1),sum(delta_obs>0 & pt_obs<0.05);
    nan,sum(delta_obs>0 & pt_obs>0.1),sum(delta_obs>0 & pt_obs>0.05);];
writematrix(Sig,'Fig1_Statistics.xlsx','Sheet',1,'Range','J3:L6');

% (6.3) The number of observed stations
figure;
subplot(4,6,[1:4,7:10]);
H1 = cdfplot(StartYear); hold on;
H1.LineWidth = 3; H1.Marker = '>'; H1.XData(end)=2016;
H2 = cdfplot(EndYear);
H2.LineWidth = 3; H2.Marker = '<'; H2.XData(1)=1956;
H3 = cdfplot(EndYear - StartYear + 1956); hold on;
H3.Color = [0.5 0.5 0.5]; H3.LineWidth = 3; H3.Marker = '^'; H3.XData(1)=1956; H3.XData(end)=2016;
xlim([1956,2016]);
legend('Start Year','End Year','Data Length','Box','off');
text(1960,0.5,['Number of stations with complete records from 1956 to 2016: ', num2str(nansum((EndYear - StartYear + 1)==61))],...
    'Color',[0.5 0.5 0.5],'FontSize',15,'FontName','Arial','FontWeight','Bold');
set(gca,'xTick',[1956,1960:10:2010,2016],...
    'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);
subplot(4,6,[18,24])
AA = (EndYear - StartYear + 1); AA(AA==61)=[];
hist(AA); xlim([30,50]);
set(gca,'FontSize',15,'FontName','Arial','FontWeight','Bold','TickDir','out','LineWidth',2.5);

