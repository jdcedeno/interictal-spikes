![FIU Logo](https://raw.githubusercontent.com/jdcedeno/interictal-spikes/master/fiu-logo-small.png)

# Interictal Spikes Detection

Final project for Florida International University's course EEL 6836 - Computer Visualization of Brain Electrical Activity

### INTRODUCTION

Epilepsy is an illness of the human brain in which the patient suffers recurrent, unprovoked seizures, and although this disorder is not lethal or contagious it can be dangerous to the individual because of its unpredictable nature, since seizures can happen at any moment without warning and could put the patient’s and other people’s lives at risk. 

The study of this illness is important because it affects approximately 50 million people worldwide, and there is a need to improve the processes involved in the detection of the area of the brain that is responsible for the seizures. To achieve this several examinations are performed, some of which are the Electroencephalogram (EEG), Magnetic Resonance Imaging (MRI), Functional Magnetic Resonance Imaging (FMRI), and Positron Emission Tomography (PET). The EEG is preferred due to its lower cost and higher time resolution to detect events happening in the brain.

The analysis of EEG data is done manually by neurologists, who perform a visual examination of the data and decide where and when Interictal spikes occur relying only on their expertise. This process can take up a lot of a neurologist’s valuable time, and so, an important advancement would be the implementation of an automated method to detect interictal spikes, alleviating some of the neurologist’s work.

### RESULTS

The neural network was designed to have 20 neurons in its input layer which are the 20 electrodes relevant to the analysis of the seizure data as defined in the information file attached to the raw data, 20 neurons in its hidden layer, and 1 neuron in its output layer which will be closer to 0 if the sample belongs to a negative class, and 1 if it belongs to a positive class. The following figure shows the neural network diagram selected for this project.

![neural network diagram](https://raw.githubusercontent.com/jdcedeno/interictal-spikes/master/neural%20network%20diagram.png)

The number of neurons in the hidden layer is decided arbitrarily, and should be modified depending on the results obtained after testing.

After running the classification algorithm over new seizure data from the same patient, we get the following results

![filtered data](https://raw.githubusercontent.com/jdcedeno/interictal-spikes/master/filtered%20data.png)

![classification results](https://raw.githubusercontent.com/jdcedeno/interictal-spikes/master/classification%20results.png)

It can be seen by comparing these two pictures that the network is indeed classifying the desired data as positive (shown as the red lines across all the electrode channels), and negative for other cases that dont fit the description. It can also be observed that there are some samples classified as positive that do not show the characteristics of an interictal spike, these cases are called false positives.

### CONCLUSION

The neural network trained using the sz1 data has acceptable results for classifying spikes of a single patient, however, the next step is to generalize the results for data recorded from different epileptic patients. Each electrode’s recorded data was selected as the neural network’s features, a possible improvement is to add other features to the data. This way, the neural network will have more information to decide at the moment of sample classification.
Another recommendation is the implementation of deep learning networks like convolutional neural networks, and recursive neural networks. With convolutional neural networks, we try to increase the speed of training when problems arise in traditional artificial neural networks when dimensionality increases.
