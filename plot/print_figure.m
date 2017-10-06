function print_figure(filename)
% PRINT_FIGURE save a figure in a pdf file
%   PRINT_FIGURE(filename) save the current figure in a pdf file

% if a subplot figure want to be save use png extension instead of pdf
export_fig(strcat('figures/',filename,'.pdf'), '-transparent');
end