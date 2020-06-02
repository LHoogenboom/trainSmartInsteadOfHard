clc;
clear;
%% Fill in 
multidata   = 1;
Hz          = 100; % fill in the freqency of the data output
rangeoftime = timerange('15-May-2020 16:37:00.0','15-May-2020 16:49:00.0'); % format'dd-MMM-YYYY hh:mm:ss'
file.user   = 'thami';
file.run    = 'Confirmation run 2 15-5-2020'; % Example Confirmation run 5 25-5-2020
%Fill in files data set 1 here
file.matlab = 'sensorlog_20200515_162526_testrun2';
file.ACC1   = 'Polar_H10_62814726_20200515_161649_ACC';
file.ECG1   = 'Polar_H10_62814726_20200515_161636_ECG';
file.HR1    = 'Polar_H10_62814726_20200515_161635_HR';
if multidata == 2 || multidata == 3
%Fill in files data set 2 here (if needed, place multidata on 2)
file.ACC2   = 'Polar_H10_62814726_20200524_105036_ACC';     %Acc polar file name 2
file.ECG2   = 'Polar_H10_62814726_20200524_105033_ECG';     %ECG polar file name 2
file.HR2    = 'Polar_H10_62814726_20200524_105032_HR';      %HR polar file name 2
end
if multidata == 3
%Fill in files data set 3 here (if needed, place multidata on 3)
file.ACC3   = 'Polar_H10_62814726_20200525_083337_ACC';     %Acc polar file name 3
file.ECG3   = 'Polar_H10_62814726_20200525_083335_ECG';     %ECG polar file name 3
file.HR3    = 'Polar_H10_62814726_20200525_083333_HR';      %HR polar file name 3
end
%% manually fill into comm window after running
%clearvars MatlabPo polarAccd PolarHRd 
%save('C:\Users\thami\MATLAB Drive\Train Smart\Sensor Logs\COM_testrun_100HZ_start_till_stop')

%% Import data from text file.
% Script for importing data from text file:
% partial Auto-generated by MATLAB
%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 2);
opts2 = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = " ";
opts2.DataLines = [4, Inf];
opts2.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["timestamp", "ecg"];
opts.VariableTypes = ["int64", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";
opts2.VariableNames = ["timestamp", "hr", "VarName3", "VarName4", "VarName5"];
opts2.VariableTypes = ["int64", "double", "double", "double", "double"];
opts2.ExtraColumnsRule = "ignore";
opts2.EmptyLineRule = "read";
opts2.ConsecutiveDelimitersRule = "join";
opts2.LeadingDelimitersRule = "ignore";
% Setup rules for import
opts2.ImportErrorRule = "error";
opts2 = setvaropts(opts2, [1, 2, 3, 4, 5], "FillValue", 0);

%% Initialize variables. (Fill these in with the first or only data set)
%state multiple data (1, 2, 3)
filename    = strcat('C:\Users\',file.user,'\MATLAB Drive\Train Smart\Sensor Logs\',file.run,'\',file.ACC1,'.txt'); %Acc
filepath   = strcat("C:\Users\",file.user,"\MATLAB Drive\Train Smart\Sensor Logs\",file.run,"\",file.ECG1,".txt");
PolarECG    = readtable(filepath, opts); %ECG
filepath   = strcat("C:\Users\",file.user,"\MATLAB Drive\Train Smart\Sensor Logs\",file.run,"\",file.HR1,".txt");
PolarHR     = readtable(filepath,  opts2);%HR
filepath   = strcat('C:\Users\',file.user,'\MATLAB Drive\Train Smart\Sensor Logs\',file.run,'\',file.matlab,'.mat');
Matlab      = load(filepath); %Matlab info

%% If data was fractioned upload extra data (put the second data set here)
% uploading data sets 2 (should be later then data set 1)
if multidata == 2 || multidata == 3
filename2    = strcat('C:\Users\',file.user,'\MATLAB Drive\Train Smart\Sensor Logs\',file.run,'\',file.ACC2,'.txt'); %Acc
filepath   = strcat("C:\Users\",file.user,"\MATLAB Drive\Train Smart\Sensor Logs\",file.run,"\",file.ECG2,".txt");
PolarECG2    = readtable(filepath, opts); %ECG
filepath   = strcat("C:\Users\",file.user,"\MATLAB Drive\Train Smart\Sensor Logs\",file.run,"\",file.HR2,".txt");
PolarHR2     = readtable(filepath,  opts2);%HR
end
%% If data was fractioned upload extra data (put the third data set here)
% uploading data set 3 (should be later then data set 2)
if multidata == 3
filename3   = strcat('C:\Users\',file.user,'\MATLAB Drive\Train Smart\Sensor Logs\',file.run,'\',file.ACC3,'.txt'); %Acc
filepath   = strcat("C:\Users\",file.user,"\MATLAB Drive\Train Smart\Sensor Logs\",file.run,"\",file.ECG3,".txt");
PolarECG3    = readtable(filepath, opts); %ECG
filepath   = strcat("C:\Users\",file.user,"\MATLAB Drive\Train Smart\Sensor Logs\",file.run,"\",file.HR3,".txt");
PolarHR3     = readtable(filepath,  opts2);%HR
end
%% 
startRow    = 2;

%% Format for each line of text:
%   column1: text (%u64)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%u64%5f%3f%f%[^\n\r]';

%% Open the text file.
if multidata == 2 
    fileID      = fopen(filename,'r');
    fileID2      = fopen(filename2,'r');
elseif multidata == 3
    fileID      = fopen(filename,'r');
    fileID2      = fopen(filename2,'r');
    fileID3      = fopen(filename3,'r');
else
    fileID      = fopen(filename,'r');
end
    
%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
if multidata == 2 
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray2 = textscan(fileID2, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
elseif multidata == 3
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray2 = textscan(fileID2, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray3 = textscan(fileID3, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
else
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
end

%% Close the text file.
if multidata == 2 
    fclose(fileID);
    fclose(fileID2);
elseif multidata == 3
    fclose(fileID);
    fclose(fileID2);
    fclose(fileID3);
else
    fclose(fileID);
end

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% combining diferent data sets Polar Acc data combined later
if multidata == 2 
    PolarECG    = [PolarECG; PolarECG2];
    PolarHR     = [PolarHR; PolarHR2];
elseif multidata == 3
    PolarECG    = [PolarECG; PolarECG2; PolarECG3];
    PolarHR     = [PolarHR; PolarHR2; PolarHR3];
else 
 
end    

%% Create output variable
%polar Acceleration data
PolarAcc        = table(dataArray{1:end-1}, 'VariableNames', {'timestamp','X','Y','Z'});
if multidata == 2
    PolarAcc2       = table(dataArray2{1:end-1}, 'VariableNames', {'timestamp','X','Y','Z'});
    PolarAcc        = [PolarAcc;PolarAcc2]; %delayed combining data
elseif multidata == 3
    PolarAcc2       = table(dataArray2{1:end-1}, 'VariableNames', {'timestamp','X','Y','Z'});
    PolarAcc3       = table(dataArray3{1:end-1}, 'VariableNames', {'timestamp','X','Y','Z'});
    PolarAcc        = [PolarAcc;PolarAcc2;PolarAcc3]; %delayed combining data
else

end
PolarAcctime    = PolarAcc(:,1).Variables+(946684800*1e9);
PolarAcctime    = datetime(PolarAcctime,'ConvertFrom','epochtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');
PolarAcc        = PolarAcc(:,[2 3 4]).Variables;
polarAccd       = array2timetable(PolarAcc,'RowTimes',PolarAcctime);
%Polar ECG data
PolarEcgtime    = PolarECG(:,1).Variables+(946684800*1e9);
PolarEcgtime    = datetime(PolarEcgtime,'ConvertFrom','epochtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');
PolarEcg        = PolarECG(:,2).Variables;
PolarEcgd       = array2timetable(PolarEcg,'RowTimes',PolarEcgtime);
%Polar HR data
PolarHRtime    = PolarHR(:,1).Variables+(946684800*1e9);
PolarHRtime    = datetime(PolarHRtime,'ConvertFrom','epochtime','TicksPerSecond',1e9,'Format','dd-MMM-yyyy HH:mm:ss.SSSSSSSSS');
PolarHR        = PolarHR(:,[2 3 4]).Variables;
PolarHRd       = array2timetable(PolarHR,'RowTimes',PolarHRtime);
%Matlab data
MatlabAcc       = Matlab.Acceleration(:,:);     % Get accelerator data from matlab          change range if needed
MatlabMF        = Matlab.MagneticField(:,:);    % Get Magnetic field data from matlab       change range if needed
MatlabOr        = Matlab.Orientation(:,:);        % Get Orientation data from matlab          change range if needed
MatlabAV        = Matlab.AngularVelocity(:,:);% Get AngularVelocity data from matlab      change range if needed
MatlabPo        = Matlab.Position(:,:);             % Get Position data from matlab             change range if needed
%% Synchronize data
MatlabPo        = unique(MatlabPo);                                         % pre procces position data                   
AllVariables    = synchronize(MatlabAcc,polarAccd,MatlabMF,MatlabOr,MatlabAV,PolarEcgd,PolarHRd,MatlabPo,'regular','linear','SampleRate',Hz);
% Original in case of change
% AllVariables    = synchronize(MatlabAcc,polarAccd,MatlabMF,MatlabOr,MatlabAV,PolarEcgd,PolarHRd,MatlabPo,'regular','linear','SampleRate',Hz);
AllVariables    = AllVariables(rangeoftime, :);
AllVariables.Properties.VariableNames = {'Mat_Acc_X' 'Mat_Acc_Y' 'Mat_Acc_Z' 'Pol_Acc_X' 'Pol_Acc_Y' 'Pol_Acc_Z' 'Mat_Mag_X' 'Mat_Mag_Y' 'Mat_Mag_Z' 'Mat_Azimuth' 'Mat_Pitch' 'Mat_Roll' 'Mat_AV_X' 'Mat_AV_Y' 'Mat_AV_Z' 'Pol_ECG' 'Pol_HR' 'Pol_var1' 'Polvar2' 'Mat_latitude' 'Mat_longitude' 'Mat_altitude' 'Mat_speed' 'Mat_course' 'Mat_hacc'}; %Renaming variables
% original in case of change
% AllVariables.Properties.VariableNames = {'Mat_Acc_X' 'Mat_Acc_Y' 'Mat_Acc_Z' 'Pol_Acc_X' 'Pol_Acc_Y' 'Pol_Acc_Z' 'Mat_Mag_X' 'Mat_Mag_Y' 'Mat_Mag_Z' 'Mat_Azimuth' 'Mat_Pitch' 'Mat_Roll' 'Mat_AV_X' 'Mat_AV_Y' 'Mat_AV_Z' 'Pol_ECG' 'Pol_HR' 'Pol_var1' 'Polvar2' 'Mat_latitude' 'Mat_longitude' 'Mat_altitude' 'Mat_speed' 'Mat_course' 'Mat_hacc'}; %Renaming variables
%% Clear temporary variables
clearvars Fs ans dataArray fileID filename formatSpec Matlab MatlabAV MatlabMF MatlabOr opts opts2 PolarAcc PolarAcctime PolarEcg PolarEcgd PolarECG PolarEcgtime MatlabAcc PolarHR PolarHRtime startRow rangeoftime dataArray2 fileID2 filename2 Hz Matlab2 PolarAcc2 PolarECG2 PolarHR2 multidata filename3 PolarECG3 PolarHR3 PolarAcc3 fileID3 dataArray3 file filepath;
