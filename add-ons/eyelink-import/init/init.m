function init

pupl_UI_addimporter(...
    'loadfunc', @readeyelinkEDF,...
    'label', 'From Eyelink &EDF (mex method)',...
    'filefilt', '*.edf')
pupl_UI_addimporter(...
    'loadfunc', @readeyelinkEDF,...
    'label', 'From Eyelink &EDF (base method)',...
    'filefilt', '*.edf')
pupl_UI_addimporter(...
    'loadfunc', @readeyelinkASC,...
    'label', 'From Eyelink &ASCII (.asc; output of edf2asc)',...
    'filefilt', '*.asc')

end