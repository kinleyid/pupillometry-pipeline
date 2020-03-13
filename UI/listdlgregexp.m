function [idx, names] = listdlgregexp(varargin)

p = inputParser;
addParameter(p, 'ListString', []);
addParameter(p, 'PromptString', []);
addParameter(p, 'ListSize', []);
addParameter(p, 'SelectionMode', 'multiple');
addParameter(p, 'regexp', true);
addParameter(p, 'AllowRegexp', false);
parse(p, varargin{:});

if isempty(p.Results.ListString)
    return
else
    listString = p.Results.ListString;
end
if isempty(p.Results.PromptString)
    [prompt, figTitle] = deal('');
else
    [prompt, figTitle] = deal(p.Results.PromptString);
end

f = figure(...
    'Name', figTitle,...
    'UserData', false,... % Whether or not to return the regular expression
    'NumberTitle', 'off',...
    'MenuBar', 'none');

uicontrol(f,...
    'Style', 'text',...
    'String', prompt,...
    'Units', 'normalized',...
    'Position', [0.01 0.91 0.98 0.08]);

panel = uipanel(f,...
    'Units', 'normalized',...
    'Position', [0.01 0.11 0.98 0.78]);
listboxregexp(panel, listString, 'SelectionMode', p.Results.SelectionMode, 'regexp', p.Results.regexp);
set(findobj(f, 'Style', 'listbox'), 'KeyPressFcn', @(h, e) enterdo(e, @() uiresume(f)));
if p.Results.AllowRegexp
    uicontrol(f,...
        'Style', 'pushbutton',...
        'String', 'Use regexp',...
        'Units', 'normalized',...
        'Position', [0.26 0.01 0.23 0.08],...
        'KeyPressFcn', @(h, e) enterdo(e, {
            @() set(f, 'UserData', true)
            @() uiresume(f)
        }),...
        'Callback', @(h, e) fevalcell({
            @() set(f, 'UserData', true)
            @() uiresume(f)
        }));
    uicontrol(f,...
        'Style', 'pushbutton',...
        'String', 'Use highlighted values',...
        'Units', 'normalized',...
        'Position', [0.51 0.01 0.23 0.08],...
        'KeyPressFcn', @(h, e) enterdo(e, {
            @() set(f, 'UserData', false)
            @() uiresume(f)
        }),...
        'Callback', @(h, e) fevalcell({
            @() set(f, 'UserData', false)
            @() uiresume(f)
        }));
else
    uicontrol(f,...
        'Style', 'pushbutton',...
        'String', 'Done',...
        'Units', 'normalized',...
        'Position', [0.51 0.01 0.23 0.08],...
        'KeyPressFcn', @(h, e) enterdo(e, {
            @() set(f, 'UserData', false)
            @() uiresume(f)
        }),...
        'Callback', @(h, e) fevalcell({
            @() set(f, 'UserData', false)
            @() uiresume(f)
        }));
end
uicontrol(f,...
    'Style', 'pushbutton',...
    'String', 'Cancel',...
    'Units', 'normalized',...
    'Position', [0.76 0.01 0.23 0.08],...
    'KeyPressFcn', @(h, e) enterdo(e, @() delete(f)),...
    'Callback', @(h, e) delete(f));

uicontrol(findobj(f, 'Style', 'listbox'))

uiwait(f);
if isgraphics(f)
    listBox = findobj(panel, 'Style', 'listbox');
    idx = get(listBox, 'Value');
    if get(f, 'UserData')
        names = {1 get(findobj(panel, 'Tag', 'regexp'), 'String')};
    else
        names = listString(idx);
    end
    close(f);
else
    [idx, names] = deal([]);
end

end