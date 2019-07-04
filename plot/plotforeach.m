
function plotforeach(EYE, plotfunc, varargin)

f = figure('UserData', true);
p1 = uipanel(f,...
    'Tag', 'plotpanel',...
    'Units', 'normalized',...
    'Position', [0.01 0.11 0.98 0.88]);
a = axes(p1, 'Tag', 'scatter');
p = uipanel(f,...
    'Units', 'normalized',...
    'Position', [0.01 0.01 0.98 0.08]);
uicontrol(p,...
    'String', 'Quit',...
    'Units', 'normalized',...
    'Callback', @(h,e) delete(f),...
    'KeyPressFcn', @(h,e) enterdo(e, @() delete(f)),...
    'Position', [0.01 0.01 0.18 0.98]);
uicontrol(p,...
    'String', '<< Previous <<',...
    'Units', 'normalized',...
    'Callback', @(h,e) pm1(f, 0),...
    'KeyPressFcn', @(h,e) enterdo(e, @() pm1(f, 0)),...
    'Position', [0.21 0.01 0.38 0.98]);
uicontrol(p,...
    'String', '>> Next >>',...
    'Units', 'normalized',...
    'Callback', @(h,e) pm1(f, 1),...
    'KeyPressFcn', @(h,e) enterdo(e, @() pm1(f, 1)),...
    'Position', [0.61 0.01 0.38 0.98]);
dataidx = 1;
while true
    cla(a);
    plotfunc(a, EYE(dataidx), varargin{:});
    title(EYE(dataidx).name, 'Interpreter', 'none');
    uiwait(f);
    if isgraphics(f)
        if get(f, 'UserData')
            dataidx = dataidx + 1;
            if dataidx > numel(EYE)
                dataidx = 1;
            end
        else
            dataidx = dataidx - 1;
            if dataidx < 1
                dataidx = numel(EYE);
            end
        end
    else
        return
    end
end

end

function pm1(f, v)

set(f, 'UserData', logical(v));

uiresume(f);

end