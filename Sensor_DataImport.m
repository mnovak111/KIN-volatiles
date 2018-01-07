function [DATASET] = Sensor_DataImport()

FolderListing = dir();
NumOfFolders = size(FolderListing,1); % Number of folders

FolderNum2 = 1; % Index used to number the imported folders consecutively

for FolderNum = 1:NumOfFolders % Going through all folders in a directory where the script is located
    if(FolderListing(FolderNum).isdir==1 && strncmpi(FolderListing(FolderNum).name,'HAL',3)) % If the folder name begins with HAL, proceed
        FolderName = FolderListing(FolderNum).name;
        
        regexp_temp = regexp(FolderName,'((?<=HAL)(.*)(?=_))','tokens');
        DATASET(FolderNum2).SensorID = regexp_temp{1}; % Extracting the sensor ID
        
        regexp_temp = regexp(FolderName,'((?<=T)(.*)(?=))','tokens');
        DATASET(FolderNum2).Temperature = regexp_temp{1}; % Extracting the temperature
        
        DATASET(FolderNum2).IsVacuum = false;
        DATASET(FolderNum2).IsPreBaked = false;
        DATASET(FolderNum2).VaporPresent = false;
        DATASET(FolderNum2).After = false;
        
        FolderContents=dir(FolderListing(FolderNum).name);
        if ~isempty(strfind(lower(FolderName),'vacuum'))
            DATASET(FolderNum2).IsVacuum = true; % If the folder name contains string "vacuum", change the according flag in the struct
        end
        if ~isempty(strfind(lower(FolderName),'down')) || ~isempty(strfind(lower(FolderName),'baked'))
            DATASET(FolderNum2).IsPreBaked = true;  % If the folder name contains string "down", change the according flag in the struct
        end
        if ~isempty(strfind(lower(FolderName),'wt'))
            DATASET(FolderNum2).VaporPresent = true;  % If the folder name contains string "down", change the according flag in the struct
        end
        if ~isempty(strfind(lower(FolderName),'after'))
            DATASET(FolderNum2).After = true;  % If the folder name contains string "down", change the according flag in the struct
        end
        
        FileNum2 = 1;
        for FileNum = 1:size(FolderContents)
            if(strncmpi(FolderContents(FileNum).name,'HAL',3)) % Filter out all files which do not contain string "HAL"
                FileName = FolderContents(FileNum).name;
                FilePath = fullfile(FolderName,FileName);
                DATASET(FolderNum2).Data(FileNum2).name=FileName;
                DATASET(FolderNum2).Data(FileNum2).data=dlmread(FilePath,';',1,0); % Reading the file, omitting the first line
                DATASET(FolderNum2).CombinedData(:,:,FileNum2) = DATASET(FolderNum2).Data(FileNum2).data; % Insert the data into the struct
                FileNum2 = FileNum2 + 1; % Increment the file index
            end
        end
        
        % Calculate average of all datasets
        AvgData = zeros(length(DATASET(FolderNum2).Data(1).data),6);
        for file_num = 1:length(DATASET(FolderNum2).Data)
            AvgData = AvgData + DATASET(FolderNum2).Data(file_num).data./(length(DATASET(FolderNum2).Data));
        end
        
        DATASET(FolderNum2).FolderName = FolderName;
        
        DATASET(FolderNum2).AvgData = AvgData;
        
        DATASET(FolderNum2).StdDev = std(DATASET(1).CombinedData,[],3);
        DATASET(FolderNum2).StdDev(:,1) = DATASET(FolderNum2).AvgData(:,1);
        
        FolderNum2 = FolderNum2 + 1; %% Move to the next folder
        
    end
end
end