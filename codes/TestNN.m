% Use labeled data to train Neural Network

%% clear command windows
clc
clear all
close all
%% read in labeled data
fid = fopen('LabelData.txt', 'r');
DataInputs = [];
DataTargets = [];
flag_read = false;
while 1
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    end
    
    if flag_read
        data_str = strsplit(tline);
        data(1) = str2double(data_str{1});
        data(2) = str2double(data_str{2});
        data(3) = str2double(data_str{3});
        data(4) = str2double(data_str{4});
        DataInputs = [DataInputs, data(1:3)'];
        DataTargets = [DataTargets, data(4)'];
    end
    
    flag_read = ~flag_read;
end
fclose(fid);
%% use trained data to test
load net

% error rate
count = 0;
for i = 1:size(DataInputs, 2)
    output = net(DataInputs(1:3, i));
    if output < 0.5
        output = 0;
    else
        output = 1;
    end
    
    if output == DataTargets(i)
        count = count + 1;
    end
end
error_rate = count / size(DataInputs, 2)