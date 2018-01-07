function [DATASET] = CellSelect_Temperature(DATASET,temperature)
for dataset_num = 1:length(DATASET)
    if str2num(DATASET(dataset_num).Temperature{1}) ~= temperature
        DATASET(dataset_num).SensorID = [];
        DATASET(dataset_num).IsVacuum = [];
        DATASET(dataset_num).IsPreBaked = [];
        DATASET(dataset_num).Temperature = [];
        DATASET(dataset_num).Data = [];
        DATASET(dataset_num).CombinedData = [];
        DATASET(dataset_num).AvgData = [];
    end
end

end