function ImageProcessingGUI_R2013a_Final_Updated()
clc; close all;

%% ================= PATH (SAFE) =================
baseDir    = fileparts(mfilename('fullpath'));
filtersDir = fullfile(baseDir,'filters');
addpath(genpath(filtersDir));

%% ================= AUTO-DETECT FILTERS =================
files = dir(fullfile(filtersDir,'*.m'));
filters = {};
for i = 1:numel(files)
    name = strrep(files(i).name,'.m','');
    filters{end+1} = name; %#ok<SAGROW>
end
filters = sort(filters);

%% ================= STATE =================
origImg = [];
procImg = [];
showHist = false;

%% ================= FIGURE =================
f = figure('Name','Image Processing GUI (R2013a Final - Updated)', ...
           'Position',[200 200 1200 620], ...
           'Resize','off');

%% ================= UI =================
btnLoad = uicontrol('Style','pushbutton','String','Load Image', ...
    'Position',[20 560 230 32],'Callback',@loadImage);

btnApply = uicontrol('Style','pushbutton','String','Apply Filter', ...
    'Position',[20 520 230 32],'Callback',@applyFilter);

btnReset = uicontrol('Style','pushbutton','String','Reset Filter', ...
    'Position',[20 480 230 32],'Callback',@resetImage);

btnHist = uicontrol('Style','togglebutton','String','Show Histogram', ...
    'Position',[20 440 230 32],'Callback',@toggleHistogram);

btnSave = uicontrol('Style','pushbutton','String','Save Processed Image', ...
    'Position',[20 400 230 32],'Callback',@saveImage);

hStatus = uicontrol('Style','text','String','Ready', ...
    'Position',[20 360 230 26], ...
    'ForegroundColor',[0 0.6 0], ...
    'HorizontalAlignment','left');

hList = uicontrol('Style','listbox','String',filters, ...
    'Position',[20 20 230 330],'Max',2,'Min',0);

%% ================= AXES =================
ax1  = axes('Position',[0.30 0.35 0.30 0.55]);
ax2  = axes('Position',[0.65 0.35 0.30 0.55]);

ax1h = axes('Position',[0.30 0.12 0.30 0.15]);
ax2h = axes('Position',[0.65 0.12 0.30 0.15]);

title(ax1,'Original');
title(ax2,'Processed');

axis(ax1,'off'); axis(ax2,'off');
axis(ax1h,'off'); axis(ax2h,'off');

%% ================= CALLBACKS =================
    function loadImage(~,~)
        [fName,p] = uigetfile({'*.jpg;*.png;*.bmp;*.tif;*.jpeg'});
        if fName==0, return; end
        try
            origImg = imread(fullfile(p,fName));
            procImg = [];
            axes(ax1); imshow(origImg);
            cla(ax2); cla(ax2h);
            updateHistogram();
            setStatus('Image loaded',false);
        catch ME
            errordlg(['Error loading image: ' ME.message]);
            setStatus('Load failed',true);
        end
    end

    function applyFilter(~,~)
        if isempty(origImg)
            errordlg('Load image first'); return;
        end

        idx = get(hList,'Value');
        if isempty(idx)
            errordlg('Select a filter'); return;
        end

        filterName = filters{idx(1)};

        set([btnLoad btnApply btnReset btnHist btnSave],'Enable','off');
        set(f,'Pointer','watch');
        setStatus('Processing...',false);
        drawnow;

        wb = waitbar(0,'Applying filter...');
        pause(0.05);

        try
            % Get number of parameters
            nArgs = getFilterParams(filterName);
            params = {};
            
            if nArgs > 0
                params = askForParams(filterName, nArgs);
                if numel(params) ~= nArgs
                    close(wb); unlockUI();
                    setStatus('Canceled',true); return;
                end
            end

            waitbar(0.6,wb);
            
            % Apply filter
            if nArgs == 0
                procImg = feval(filterName, origImg);
            else
                procImg = feval(filterName, origImg, params{:});
            end
            
            waitbar(1,wb);

            if ~isempty(procImg)
                if ~isa(procImg,'uint8')
                    procImg = im2uint8(mat2gray(procImg));
                end
                axes(ax2); imshow(procImg);
            end

            updateHistogram();
            setStatus(['Done: ' filterName],false);

        catch ME
            errordlg(['Error: ' ME.message]);
            setStatus('Error',true);
        end

        close(wb);
        unlockUI();
    end

    function resetImage(~,~)
        if isempty(origImg), return; end
        procImg = [];
        cla(ax2); cla(ax2h);
        updateHistogram();
        setStatus('Reset to original',false);
    end

    function toggleHistogram(src,~)
        showHist = get(src,'Value');
        updateHistogram();
    end

    function saveImage(~,~)
        if isempty(procImg)
            errordlg('No processed image to save');
            return;
        end
        
        [fName,p] = uiputfile({'*.png','PNG Image';'*.jpg','JPEG Image';...
                               '*.bmp','Bitmap Image'},'Save Processed Image');
        if fName==0, return; end
        
        try
            imwrite(procImg, fullfile(p,fName));
            setStatus('Image saved',false);
        catch ME
            errordlg(['Error saving: ' ME.message]);
            setStatus('Save failed',true);
        end
    end

    function updateHistogram()
        cla(ax1h); cla(ax2h);
        if ~showHist, return; end

        if ~isempty(origImg)
            axes(ax1h);
            imhist(toGray(origImg));
            title('Histogram');
        end

        if ~isempty(procImg)
            axes(ax2h);
            imhist(toGray(procImg));
            title('Histogram');
        end
    end

    function g = toGray(img)
        if ndims(img) == 3
            g = rgb2gray(img);
        else
            g = img;
        end
    end

    function unlockUI()
        set([btnLoad btnApply btnReset btnHist btnSave],'Enable','on');
        set(f,'Pointer','arrow');
    end

    function setStatus(msg,isErr)
        set(hStatus,'String',msg);
        if isErr
            set(hStatus,'ForegroundColor',[0.8 0 0]);
        else
            set(hStatus,'ForegroundColor',[0 0.6 0]);
        end
        drawnow;
    end

    function nArgs = getFilterParams(filterName)
        % Determine number of parameters for specific filters
        % This handles cases where nargin might not work properly
        try
            nArgs = nargin(filterName) - 1;
        catch
            % Default parameter counts for known filters
            switch lower(filterName)
                case {'erosion','opening','closing','boundary_extraction',...
                      'weightedfilter','dilation'}
                    nArgs = 1;
                otherwise
                    nArgs = 0;
            end
        end
        
        % Ensure non-negative
        if nArgs < 0
            nArgs = 0;
        end
    end
end

%% ================= PARAMETER POPUP =================
function params = askForParams(filterName, nArgs)
prompt   = cell(nArgs,1);
defaults = cell(nArgs,1);

% Custom prompts for specific filters
switch lower(filterName)
    case {'erosion','opening','closing','dilation'}
        for i = 1:nArgs
            if i == 1
                prompt{i} = 'Structuring element size:';
                defaults{i} = '3';
            else
                prompt{i} = sprintf('Parameter %d:', i);
                defaults{i} = '1';
            end
        end
    case 'boundary_extraction'
        for i = 1:nArgs
            if i == 1
                prompt{i} = 'Boundary thickness (1-5):';
                defaults{i} = '1';
            else
                prompt{i} = sprintf('Parameter %d:', i);
                defaults{i} = '1';
            end
        end
    case 'weightedfilter'
        for i = 1:nArgs
            if i == 1
                prompt{i} = 'Filter mask size (odd number):';
                defaults{i} = '3';
            else
                prompt{i} = sprintf('Parameter %d:', i);
                defaults{i} = '1';
            end
        end
    otherwise
        for i = 1:nArgs
            prompt{i} = sprintf('Enter parameter %d:', i);
            defaults{i} = '1';
        end
end

answer = inputdlg(prompt, filterName, 1, defaults);
if isempty(answer)
    params = {}; return;
end

params = cell(1,nArgs);
for i = 1:nArgs
    val = str2num(answer{i}); %#ok
    if isempty(val)
        val = 1;
    end
    params{i} = val;
end
end