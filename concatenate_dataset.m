function [result] = concatenate_dataset(dataset,sensorid)

result.CombinedData = [];
result.StdDev = [];

for dataset_num=1:size(dataset,2)
    if ~isempty(dataset(dataset_num).SensorID)
        result.CombinedData = cat(3,result.CombinedData,dataset(dataset_num).CombinedData);
        result.Temperature = dataset(dataset_num).Temperature;
        result.IsVacuum    = dataset(dataset_num).IsVacuum;
        result.IsPreBaked  = dataset(dataset_num).IsPreBaked;
    end
end

result.AvgData     = mean(result.CombinedData,3);
result.StdDev      = std(result.CombinedData,[],3);
result.StdDev(:,1) = result.CombinedData(:,1,1);
result.SensorID    = sensorid;


