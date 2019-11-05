%% sz_sourceCode
% Load data
load('ALLEEG.mat');
load('sz1chan15peaklocations.mat')

%% Select sz1 filtered data (2nd row of ALLEEG.data). 
% Select only the first 20 electrodes
szdata = 2; % Select 2nd row of ALLEEG.data (sz1_filtered)
inc = 1;

sz(inc).data = ALLEEG(szdata).data(1:20,:); % Select the first 20 electrodes
sz(inc).fs = ALLEEG(szdata).srate;

%% Cut data
% Select data from start up to 320 seconds, save in sz.cutdata
seconds_finish = 320;
sz(inc).cutdata = sz(inc).data(:,1:(seconds_finish*sz(inc).fs));
clear seconds_finish

% Calculate mean of cutdata
sz(inc).cutdata_mean = ...
    repmat(mean(sz(inc).cutdata,2),1,length(sz(inc).cutdata));

% Calculate standard deviation of cutdata
sz(inc).cutdata_std = ...
    repmat(std(sz(inc).cutdata,[],2),1,length(sz(inc).cutdata));

% Calculate slope of cutdata
sz(inc).cutdata_slope = ...
    [diff(sz(inc).cutdata,1,2) zeros(size(sz(inc).cutdata,1),1)];

%% Plot channel 'chan'
% seconds_finish = length(sz(inc).cutdata)/sz(inc).fs; % for xaxis linspace
% for chan = 15
%     xaxis = linspace(0,seconds_finish,length(sz(inc).cutdata));
%     figure,plot(xaxis,sz(inc).cutdata(chan,:));
%     grid on
%     title(sprintf('sz%d electrode %d',inc,chan));
%     xlabel('seconds');
%     hold on
%     plot(xaxis,sz(inc).cutdata_slope(chan,:),'k')
% end
% clear seconds_finish chan

%% Upsample spikes in training data

% Spike matrix
spikes = cell(1,length(sz1chan15peaks)/2);
col = 1;
for i = length(sz1chan15peaks):-2:2
    spikes{1,col} = ...
        sz(inc).cutdata(15,sz1chan15peaks(i).DataIndex:...
        sz1chan15peaks(i-1).DataIndex);
    col = col + 1;
end
clear col i

spikes = [spikes{:}];
spikes = repmat(spikes,size(sz(inc).cutdata,1),1);

% Non-spike matrix
nonspikes = cell(1,(length(sz1chan15peaks)/2)+1);
col = 2;
for i = (length(sz1chan15peaks)-1):-2:3
    nonspikes{1,col} = ...
        sz(inc).cutdata(:,(sz1chan15peaks(i).DataIndex+1):...
        (sz1chan15peaks(i-1).DataIndex-1));
    col = col + 1;
end
clear col i

nonspikes{1,1} = ...
    sz(inc).cutdata(:,1:(sz1chan15peaks(length(sz1chan15peaks)).DataIndex)-1);
nonspikes{1,end} = ...
    sz(inc).cutdata(:,(sz1chan15peaks(1).DataIndex+1):end);

nonspikes = [nonspikes{:}];

%% Create Training and Target Data matrices for neural network training
percentage = 0.1;
percentage = round(percentage,2);
nonspikescol = floor(percentage*length(nonspikes))/percentage;
nonspikescol = round(nonspikescol);
nonspikes = nonspikes(:,1:nonspikescol);
clear nonspikescol

nnTrainingData = cell(1,100*percentage);
window = percentage*length(nonspikes);
col = 1;
for i = 1:10
    nnTrainingData{1,i} = ...
        horzcat(nonspikes(:,col:(i*window)),spikes);
    col = col + window;
end
clear col i 

nnTrainingData = [nnTrainingData{:}];

nnTargetData = zeros(1,length(nnTrainingData));
col = 1;
for i = 1:10
    nnTargetData(1,(i*window):(i*window)+length(spikes)) = 1;
    col = col + window;
end
clear col i window percentage

%% Train Neural Network

% NNsimpleScript; %the network is already trained, the results are stored 
% in variable nnResults
load('nnResults.mat');
network = nnResults.net;

%% Test NN on sz2 filtered data
row = 4;
outputs = network(ALLEEG(row).data(1:20,:));
test = outputs > 0.9; %samples with a 90% probability of being a spike
outputs(test) = 1;
test = outputs ~= 1;
outputs(test) = 0;
clear test

%% Plot NN classification results against original data
% plotNNclassification(data_structure,field,class_result,fs)
% plotAllChannels(data_structure,szdata)
plotNNclassification(ALLEEG,row,outputs,ALLEEG(row).srate)
plotAllChannels(ALLEEG,row)
clear row