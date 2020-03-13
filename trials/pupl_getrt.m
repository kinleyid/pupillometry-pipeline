
function out = pupl_getrt(EYE, varargin)

if nargin == 0
    out = @getargs;
else
    out = sub_getrt(EYE, varargin{:});
end

end

function args = parseargs(varargin)

args = pupl_args2struct(varargin, {
	'onsets' []
    'responses' []
});

end

function outargs = getargs(EYE, varargin)

outargs = [];
args = parseargs(varargin{:});

if isempty(args.onsets)
    [~, args.onsets] = listdlgregexp(...
        'PromptString', 'Which events mark the onset of a trial?',...
        'ListString', unique(mergefields(EYE, 'event', 'type')),...
        'AllowRegexp', true);
    if isempty(args.onsets)
        return
    end
end

if isempty(args.responses)
    [~, args.responses] = listdlgregexp(...
        'PromptString', 'Which events mark a response?',...
        'ListString', unique(mergefields(EYE, 'event', 'type')));
    if isempty(args.responses)
        return
    end
end

outargs = args;
fprintf('Trial onsets marked by:\n');
fprintf('\t%s\n', args.onsets{:});
fprintf('Responses marked by:\n');
fprintf('\t%s\n', args.responses{:});

end

function EYE = sub_getrt(EYE, varargin)

args = parseargs(varargin{:});

allevents = {EYE.event.type};
onset_idxs = find(regexpsel(allevents, args.onsets));
onset_times = [EYE.event(onset_idxs).time];
response_idxs = find(regexpsel(allevents, args.responses));
response_times = [EYE.event(response_idxs).time];
all_rts = cell(size(onset_times));
n_rts = 0;
for trialidx = 1:numel(onset_times)
    is_resp = response_times > onset_times(trialidx);
    if trialidx < numel(onset_times)
        is_resp = is_resp & response_times < onset_times(trialidx + 1);
    end
    if any(is_resp)
        is_resp = find(is_resp);
        is_resp = is_resp(1);
        rt = response_times(is_resp) - onset_times(trialidx);
        EYE.event(onset_idxs(trialidx)).rt = rt;
        EYE.event(response_idxs(is_resp)).rt = rt;
        n_rts = n_rts + 1;
        all_rts{trialidx} = rt;
    end
end

fprintf('%d/%d trials have responses. Mean rt: %f s\n', n_rts, numel(onset_times), mean([all_rts{:}]));

end