%% Plot all channels
function plotAllChannels(data_structure,szdata)
plotdata = data_structure(szdata).data(1:20,:);
xaxis = linspace(0,data_structure(szdata).xmax,length(plotdata));
move = repmat((0:-5:-95)',1,length(plotdata));
plotdata = plotdata + move;
figure, plot(xaxis,plotdata);
end