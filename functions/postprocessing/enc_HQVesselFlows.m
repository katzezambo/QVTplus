function [time,Flow,FlowErr]=enc_HQVesselFlows(data_struct,Labels,params)
    BranchList=data_struct.branchList;
    BranchList=[BranchList [1:length(BranchList)]'];
    Quality=data_struct.StdvFromMean;
    BranchList=[BranchList Quality];
    Flows=data_struct.flowPulsatile_val;
    [~,frames]=size(Flows);
    time=(data_struct.timeres:data_struct.timeres:(data_struct.timeres*(frames)))./1000;
    Flow=zeros([frames,9]);
    FlowErr=zeros([frames,9]);
    for ves=1:9
        Vessel=Labels{ves,2};Vessel=str2num(Vessel);
        Data=[];
        for vessnum=1:length(Vessel)
            [idx1,~]=find(BranchList(:,4)==Vessel(vessnum));
            Temp=BranchList(idx1,:);
            [idx2,~]=find(Temp(:,7)>=params.thresh);
            Data=[Data;Temp(idx2,:)];
        end
        HQFlows=Flows(Data(:,6),:);
        Flow(:,ves)=mean(HQFlows)';
        FlowErr(:,ves)=std(HQFlows)';
    end
end