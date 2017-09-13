
function pdf_resolution(resolution)
if nargin==0
    %the larger the resolution parameter the better the resolution of the output
    resolution = 150;
end
current_folder = cd;
cd('C:\Program Files\gs\gs9.20\bin')
[file_name, data_main_folder] = uigetfile('C:\Users\molano\Dropbox\project_trento\VISUALISE\papers\*.pdf');
file_name = file_name(1:end-4);
command = ['gswin64c -sDEVICE=pngalpha -dQUIET -dBATCH -dNOPAUSE -sOutputFile=' data_main_folder...
    file_name 'DEL%02d.png -r' num2str(resolution) ' ' data_main_folder file_name '.pdf'];
system(command);
disp('png files created')
cd('C:\Program Files\ImageMagick-7.0.5-Q16')
command =  ['magick ' data_main_folder file_name '*DEL*.png +adjoin ' data_main_folder file_name 'DEL%02d.pdf'];
system(command)
disp('png files converted to pdf')
command = ['pdftk ' data_main_folder file_name '*DEL*.pdf cat output ' data_main_folder file_name '_res' num2str(resolution) '.pdf'];
system(command);
disp('pdf files concatenated')
cd(data_main_folder)
delete('*DEL*')
cd(current_folder)

