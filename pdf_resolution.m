
function pdf_resolution(resolution)
if nargin==0
    resolution = 200;
end
current_folder = cd;
cd('C:\Program Files\gs\gs9.19\bin')
[file_name, data_main_folder] = uigetfile('*.pdf');
file_name = file_name(1:end-4);
command = ['gswin64c -sDEVICE=pngalpha -dQUIET -dBATCH -dNOPAUSE -sOutputFile=' data_main_folder file_name 'DEL%02d.png -r' num2str(resolution) ' ' data_main_folder file_name '.pdf'];
system(command);
command = ['convert ' data_main_folder file_name '*DEL*.png '  data_main_folder file_name 'DEL%02d.pdf'];
system(command)
command = ['pdftk ' data_main_folder file_name '*DEL*.pdf cat output ' data_main_folder file_name '_res' num2str(resolution) '.pdf'];
system(command);
cd(data_main_folder)
delete('*DEL*')
cd(current_folder)

