% Preprocessing Data

%% clear command windows
clc
clear all
close all
%% extract features of every patient
% get the list of patients
list_path = 'database';
patient_list = dir(list_path);

fid = fopen('RawData.txt', 'w');

for i = 4:length(patient_list)
    % get the list of CTs of every patient
    patient_path = [list_path, '/', patient_list(i).name];
    patient = dir(patient_path);
    
    disp(patient_list(i).name);

    try
        % for one patient, analyze 10 CT images to extract features
        Fs_combined = [];
        for j = 3:length(patient)
            % read CT image
            img_orig = imread([patient_path, '/', patient(j).name]);

            % Lung Regions Extraction
            [lung_dilated, lung_extracted] = Extraction(img_orig);

            % Lung Regions Segmentation
            [C, idx, K] = Segmentation(lung_dilated, lung_extracted);

            % Feature Extraction
            Fs = FeatureExtraction(C, idx, K);
            Fs_combined = [Fs_combined, Fs'];
        end
        Fs_combined = mean(Fs_combined, 2);
        disp(Fs_combined);
        
        fprintf(fid, '%s\n', patient_list(i).name);
        fprintf(fid, '%f %f %f\n', Fs_combined(:));
    catch ME
        disp(ME.identifier)
    end
end

fclose(fid);