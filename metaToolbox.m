function varargout = metaToolbox(varargin)
% METATOOLBOX MATLAB code for metaToolbox.fig
%      METATOOLBOX, by itself, creates a new METATOOLBOX or raises the existing
%      singleton*.
%
%      H = METATOOLBOX returns the handle to a new METATOOLBOX or the handle to
%      the existing singleton*.
%
%      METATOOLBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in METATOOLBOX.M with the given input arguments.
%
%      METATOOLBOX('Property','Value',...) creates a new METATOOLBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before metaToolbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to metaToolbox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help metaToolbox

% Last Modified by GUIDE v2.5 13-Feb-2016 16:56:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @metaToolbox_OpeningFcn, ...
    'gui_OutputFcn',  @metaToolbox_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function metaToolbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to metaToolbox (see VARARGIN)

% Choose default command line output for metaToolbox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



function varargout = metaToolbox_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function select_folder_Callback(hObject, eventdata, handles)
%list all files in the selected folder and their interactions.
global data
display('----------------------------------------------------------------------')
if isfield(data,'main_folder')
    data.main_folder = [uigetdir(data.main_folder) '/'];
else
    data.main_folder = [uigetdir(cd) '/'];
end
a = dir([data.main_folder '/*.m']);
data.mat_calls = zeros(numel(a));
data.files = cell(1,numel(a));
for ind1=1:numel(a)
    funcion = a(ind1).name;
    data.files{ind1} = funcion(1:end-2);
    display('oooooooooooooooooooooooooooooooooo')
    display(['function: ' funcion ' is called in:'])
    for ind2=1:numel(a)
        candidato = a(ind2).name;
        [fileID,~] = fopen([data.main_folder candidato]);
        d = textscan(fileID,'%s','Delimiter','\n');
        
        %look for the function in the candidate script
        aux = strfind(d{1},funcion(1:end-2));
        aux = cellfun(@isempty,aux);
        
        
        if nnz(~aux)>0 && ~isequal(candidato,funcion)
            %find all lines with the % symbol
            lineas = d{1}(~aux);
            aux1 = strfind(lineas,'%');
            aux1 = cellfun(@takeFirst,aux1);
            aux2 = strfind(lineas,funcion(1:end-2));
            aux2 = cellfun(@takeFirst,aux2);
            if all(aux1<aux2)
                continue
            else
                lineas(aux1<aux2) = [];
                aux2(aux1<aux2) = [];
            end
            
            check_point = 0;
            check_point1 = 0;
            check_point2 = 0;
            right_after = aux2+numel(funcion(1:end-2));
            right_before = aux2-1;
            for ind_linea=1:numel(right_after)
                %for each line I control what is after the 'called'...
                if numel(lineas{ind_linea})>=right_after(ind_linea)
                    if ~isempty(strfind(' (@~-=+/*[{;},',lineas{ind_linea}(right_after(ind_linea))))
                        check_point1 = 1;
                    end
                else
                    check_point1 = 1;
                end
                %...and before
                if right_before(ind_linea)>0
                    if ~isempty(strfind(' (@~-=+/*[{},',lineas{ind_linea}(right_before(ind_linea))))
                        check_point2 = 1;
                    end
                else
                    check_point2 = 1;
                end
                if check_point1 && check_point2
                    check_point = 1;
                    break
                end
            end
            if check_point
                display(['-------' candidato])
                data.mat_calls(ind2,ind1) = 1;
            end
        end
        fclose(fileID);
    end
end
data.number_of_calls = sum(data.mat_calls,2);
data.number_of_times_called = sum(data.mat_calls,1);

set(handles.listbox1,'string',data.files)
% keyboard


function first = takeFirst(c)
if ~isempty(c)
    first = c(1);
else
    first = nan;
end


function listbox1_Callback(hObject, eventdata, handles)



function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
