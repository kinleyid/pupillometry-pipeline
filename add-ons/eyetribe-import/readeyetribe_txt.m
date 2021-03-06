function out = readeyetribe_txt(fullpath)

printprog('setmax', 17)

fid = fopen(fullpath);
currline = fgetl(fid);
fseek(fid, 0, 'bof');
currline_long = fgets(fid);
eol = currline_long(length(currline)+1:end);
% Read raw
fseek(fid, 0, 'bof');
txt = fread(fid, 'uint8=>char')';
fclose(fid);
printprog(1)

json = regexp(txt, eol, 'split');
printprog(2)
issample = ~cellfun(@isempty, regexp(json, '"category":"tracker"', 'once'));
printprog(3)
samples = json(issample);
timestamps = regexp2num(regexp(samples, '"time":(\d+)', 'tokens'));
srate = estimatesrate(timestamps);
while srate == 0
    timestamps = timestamps / 1000;
    srate = estimatesrate(timestamps);
end
printprog(4)
timestamps = regexp(samples, '"timestamp":"....-..-.. (\d+):(\d+):(\d+)\.(\d+)"', 'tokens');
printprog(5)
timestamps = cat(1, timestamps{:});
printprog(6)
timestamps = cat(1, timestamps{:});
printprog(7)
h = cellstr2num(timestamps(:, 1)) * 60*60;
printprog(8)
m = cellstr2num(timestamps(:, 2)) * 60;
printprog(9)
s = cellstr2num(timestamps(:, 3));
printprog(10)
ms = cellstr2num(timestamps(:, 4)) / 1000;
printprog(11)
times = h + m + s + ms;

pupil = [];
gaze = [];
n = 11;
for side = {'left' 'right'}
    diam_expr = [side{:} 'eye.*?"psize":(\d+\.*\d*)'];
    pupil.(side{:}) = regexp2num(regexp(samples, diam_expr, 'tokens'));
    n = n + 1;
    printprog(n);
    for ax = {'x' 'y'}
        gaze_expr = [side{:} 'eye.*?"raw":.*?"' ax{:} '":(\d+\.*\d*)'];
        gaze.(ax{:}).(side{:}) = regexp2num(regexp(samples, gaze_expr, 'tokens'));
        n = n + 1;
        printprog(n);
    end
end

out = struct(...
    'pupil', pupil,...
    'srate', srate,...
    'gaze', gaze,...
    'times', times);

end

function out = regexp2num(in)

tmp = cell(size(in));
ie = cellfun(@isempty, in); 
tmp(~ie) = [in{:}];
tmp(ie) = {'nan'};
out = cellstr2num([tmp{:}]);

end