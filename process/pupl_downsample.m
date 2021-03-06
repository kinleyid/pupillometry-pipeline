
function out = pupl_downsample(EYE, varargin)
% Downsample data
%
% Inputs:
%   fac: integer
%       the factor by which to downsample
% Example:
%   pupl_downsample(eye_data,...
%       'fac', 50);
if nargin == 0
    out = @getargs;
else
    out = sub_downsample(EYE, varargin{:});
end

end

function args = parseargs(varargin)

args = pupl_args2struct(varargin, {
    'fac' []
});

end

function outargs = getargs(EYE, varargin)

outargs = [];
args = parseargs(varargin{:});

if isempty(args.fac)
    args.fac = inputdlg(sprintf('Downsample by what factor? (Integers only)\n\nThis is the factor by which the sample rate is divided.\nE.g. if your data was recorded at 1000 Hz, downsampling by a factor of 4 produces a new sample rate of 250 Hz.'));
    if isempty(args.fac)
        return
    else
        args.fac = round(str2double(args.fac));
    end
end

fprintf('Downsampling by a factor of %d\n', args.fac);
outargs = args;

end

function EYE = sub_downsample(EYE, varargin)

fprintf('Previous sample rate: %f Hz\n', EYE.srate);

args = parseargs(varargin{:});

% get functions that will perform baseline correction and the new string
% that will describe the correction

keepidx = 1:args.fac:EYE.ndata;

ds = @(x) x(keepidx);

EYE = pupl_proc(EYE, ds, 'all');
EYE.times = ds(EYE.times);
EYE.datalabel = ds(EYE.datalabel);
EYE.srate = EYE.srate / args.fac;
EYE.ndata = numel(EYE.datalabel);

% Adjust interstitial labels--if a saccade happened between two points,
% make sure that's reflected in the new interstitial labels

new_interstices = repmat(' ', 1, EYE.ndata - 1);
old_interstices = reshape(EYE.interstices(1:keepidx(end)-1), args.fac, []);
sacc_idx = any(old_interstices == 's', 1);
new_interstices(sacc_idx) = 's';
new_interstices(~sacc_idx) = old_interstices(1, ~sacc_idx);
EYE.interstices = new_interstices;

fprintf('New sample rate: %f Hz\n', EYE.srate);

end