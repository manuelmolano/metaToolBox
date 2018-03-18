
function put_pngs_together(folder)
if nargin==0
    folder = '/home/manuel/Desktop/data for SNR Chen/2018 02 28/figures_folder/';
end
current_folder = cd;
cd(folder)
cd('C:\Program Files\ImageMagick-7.0.5-Q16')
command =  ['magick ' data_main_folder file_name '*_*.png +adjoin ' data_main_folder file_name 'DEL%d.pdf'];
system(command)
disp('png files converted to pdf')
command = ['pdftk ' data_main_folder file_name '*DEL*.pdf cat output ' data_main_folder file_name '_res' num2str(resolution) '.pdf'];
system(command);
disp('pdf files concatenated')
cd(data_main_folder)
delete('*DEL*')
cd(current_folder)

