for sub=1 : length(sbj)
    subname = sbj{sub};
    ts = importdata([fc_path,'ROISignals_ROISignal_',subname,'.mat']);
    timeSeriesData = ts'; 
    mkdir([path,subname]);
    cd([path,subname]);
    save([path,subname,'/',subname,'_TS'],'timeSeriesData','labels','keywords');
    
    TS_Init([path,subname,'/',subname,'_TS.mat']);
    TS_Compute(true);
    TS_Normalize('mixedSigmoid',[0,1]);
end
   
