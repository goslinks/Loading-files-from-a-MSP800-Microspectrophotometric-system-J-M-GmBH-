id = 'MATLAB:table:ModifiedAndSavedVarnames';
warning('off',id)
% Opens a UI file loader and saves the filename and path of file as a char
% array in a cell array
[filename, path] = uigetfile('*.*',  'All Files (*.*)','MultiSelect','on');
% Gets the size of the filename cell array (basically the number of files)
num_files = size(filename);
% Opens the first file to get data structure
opts = detectImportOptions(fullfile(path,filename{1}));
opts = setvartype(opts, 'double');
temp = readtable(fullfile(path,filename{1}), opts);
% Gets size of data
datasz = size(temp);
% Need to count the number of headers in the file (which are imported as NaN
% values) so that we can exclude them in the final data
header_count = zeros(datasz(1),1);
for i = 1:datasz(1)
    if isnan(temp{i,1}) == 1
        header_count(i) = 1;
    end
end
header_count = sum(header_count);
% Creates a few arrays with the dimensions of the final data (data), the
% x-axis scale (lambda) and the sample names (sample_names)
temp = table2array(temp);
lambda = temp((header_count+1):end,1)';
data = zeros(num_files(2),(datasz(1)-header_count));
sample_names = cell(num_files(2),1);
% A loop which opens each file per iteration and appends the data in the
% file to the "data" array and the sample name to the "sample_name" array
for j = 1:num_files(2)
    temp = readtable(fullfile(path,filename{j}), opts);
    temp = table2array(temp)';
    data(j,:) = temp(2,(header_count+1):end);
    samplename = filename{j};
    sample_names{j,1} = samplename(1:end-4);
end
% Final touches on the dataset, inserting the sample names and x-axis scale
data = dataset(data);
data.label{1} = sample_names;
data.axisscale{2} = lambda;

clearvars -except data
