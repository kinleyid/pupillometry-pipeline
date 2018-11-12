function writetospreadsheet(EYE, varargin)

%  Inputs
% EYE--struct array
% bins--cell array of bin names to write to csv
% saveTo--directory to save csvs to
%  Description
% writes spreadsheets with columns:
%   Participant ID
%   Bin name
%   Trials

p = inputParser;
addParameter(p, 'bins', []);
addParameter(p, 'saveTo', []);
parse(p, varargin{:})

if isempty(p.Results.bins)
    uniqueBinNames = {};
    for dataIdx = 1:numel(EYE)
        uniqueBinNames = cat(2, uniqueBinNames,...
            unique({EYE(dataIdx).bin.name}));
    end
    bins = uniqueBinNames(listdlg(...
        'PromptString', 'Which bins should be written to csv?',...
        'ListString', uniqueBinNames));
else
    bins = p.Results.bins;
end

for dataIdx = 1:numel(EYE)
    binsToWrite = find(ismember({EYE(dataIdx).bin.name}, bins));
    for binIdx = binsToWrite
        data = EYE(dataIdx).bin(binIdx).data.both';
        dataName = repmat(EYE(dataIdx).name, size(data, 1), 1);
        binName = repmat(EYE(dataIdx).bin(binIdx).name, size(data, 1), 1);
        currTable = table(dataName, binName,...
            'VariableNames', 'Data file', 'Bin');
        currTable = join(currTable,...
            array2table(data,...
            'VariableNames', arrayfun(@(x) sprintf('trial%d',x), 1:size(data,2), 'un', 0)))/    ;
        writetable(currTable,...
            [EYE(dataIdx).name '-' EYE(dataIdx).bin(binIdx).name '.csv']);
    end
end

end