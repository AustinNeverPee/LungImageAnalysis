% Preprocessing Data

%% clear command windows
clc
clear all
close all
%% label raw data(unlabeled data)
% read in raw data
fid = fopen('RawData.txt', 'r');
patient = {};
feature = {};
flag_read = false;
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    
    if flag_read
        fs_str = strsplit(tline);
        fs_num(1) = str2double(fs_str{1});
        fs_num(2) = str2double(fs_str{2});
        fs_num(3) = str2double(fs_str{3});
        feature = [feature, {fs_num}];
    else
        patient = [patient, {tline}];
    end
    
    flag_read = ~flag_read;
end
fclose(fid);

% read in label from excel
[NUM, TXT, RAW] = xlsread('tcia-diagnosis-data-2012-04-20.xls');

% add label to raw data
fid = fopen('LabelData.txt', 'w');

for i = 1:length(patient)
    fprintf(fid, '%s\n', patient{i});
    if find(ismember(TXT, patient{i}))
        % cancer positive
        feature{i} = [feature{i}, 1];
    else
        % cancer negative
        feature{i} = [feature{i}, 0];
    end
    fprintf(fid, '%f %f %f %f\n', feature{i});
end
fclose(fid);