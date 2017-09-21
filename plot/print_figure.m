function print_figure(filename)

    % if a subplot figure want to be save use png extension instead of pdf
    export_fig(strcat('figures/',filename,'.pdf'), '-transparent');
end