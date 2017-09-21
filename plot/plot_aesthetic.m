function [] = plot_aesthetic(Title, Label_x, Label_y, varargin)
% PLOT_AESTHETIC add Title, label and legends in a plot
%   PLOT_AESTHETIC(Title, Label_x, Legend_1, ..., Legend_n) add Title, 
%   label and legends in a plot. LaTex syntax is allowed in legends
%   strings.

title(Title)
xlabel(Label_x)
ylabel(Label_y)

h = legend(varargin{:});
set(h,'Interpreter','latex')
set(h,'FontSize',12);
h = findobj(gcf,'type','line');
set(h,'linewidth',1.2);
grid on;
end

