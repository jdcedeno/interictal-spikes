%% Plot NN classification results against original data
function plotNNclassification(data_structure,field,class_result,fs)
xaxis = linspace(0,length(class_result)/fs,length(class_result));
move = (0:-5:-95)';
move = repmat(move,1,length(class_result));

allplot_data = move + data_structure(field).data(1:20,:);
figure, plot(xaxis,allplot_data);
grid on
hold on
plot(xaxis,-100*class_result,'r');
end