function init

global userInterface

if isgraphics(userInterface)
    uimenu(findobj(userInterface, 'Tag', 'importEventLogsMenu'),...
        'Label', 'From &Noldus Excel file',...
        'Interruptible', 'off',...
        'Callback', @(h, e)...
            updateglobals('eyeData',...
                userInterface.UserData.activeEyeDataIdx,...
                @() pupl_importraw(...
                    'eyedata', getactive('eye data'),...
                    'loadfunc', @loadnoldusexcel,...
                    'type', 'event'),...
                1));
end

end