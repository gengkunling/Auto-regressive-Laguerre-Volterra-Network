# Modeling Hodgkin-Huxley Equations with Autoregressive Sparse Laguerre-Volterra Network (ASLVN)

Here is the implementation of Autoregressive Sparse  LVN  (ASLVN) in Matlab. ASLVN is the extension of the [LVN](https://github.com/gengkunling/Laguerre-Volterra-Network) that is able to model nonlinear systems that exhibit transitions in dynamic states, such as the classic Hodgkin–Huxley (H-H) equations.  

The Laguerre-Volterra Network (LVN) is an advanced method to analyze time seires data and the nonlinear dynamic relationships in the systems. 

LVN combines the idea of Laguerre kernel expansions with Artificial Neural Network (ANN). The Laguerre kernel expansions can be viewed as 1-D convolutional layer in the time domain. 

Unlike Long short-term memory (LSTM) network, LVN is very compact and can learn the nonlinear dynamic patterns from a very limited amount of data. 



## To run this program:

### 1. Generate Data from Hodgkin-Huxley Equations
Run [HH_data_gen.m](HH_data_gen.m) to generate the training data [HH_train.mat](HH_train.mat) and test data [HH_test.mat](HH_train.mat). If you would like to change the parameters of H-H equations, please modify [HH_equation.m](HH_equation.m).

### 2. Train ASLVN
Run [ASLVN_train.m](ASLVN_train.m). The program will use the training data from [HH_train.mat](HH_train.mat) and optimize the ASLVN using simulated annealing algorithm.  The results will be stored in the [ASLVN_training_results.mat](ASLVN_training_results.mat).

### 3. Evaluate the ASLVN using test data
Run [ASLVN_test.m](ASLVN_test.m).  The program will load the test data from [HH_test.mat](HH_test.mat) and the ASLVN model from [ASLVN_training_results.mat](ASLVN_training_results.mat), and then it will evaluate the model performance by plotting the continuous data predictions, binary data predictions and ROC curve plots.

For more details, please look into the [ASLVN_paper.pdf](ASLVN_paper.pdf) included.

## If you are looking for Standard LVN (Single-Input Single-Output)
Plase to go to: [https://github.com/gengkunling/Laguerre-Volterra-Network.git](https://github.com/gengkunling/Laguerre-Volterra-Network.git)

## If you find this code useful, please cite:

[Geng, K., & Marmarelis, V. Z. (2015). Pattern recognition of Hodgkin-Huxley equations by auto-regressive Laguerre Volterra network. BMC Neuroscience, 16(Suppl 1), P156.](https://www.researchgate.net/profile/Kunling_Geng/publication/287346598_Pattern_recognition_of_Hodgkin-Huxley_equations_by_auto-regressive_Laguerre_Volterra_network/links/5692cea108aec14fa55da757.pdf?origin=publication_detail)

[Geng, K., & Marmarelis, V. Z. (2016). Methodology of Recurrent Laguerre-Volterra Network for Modeling Nonlinear Dynamic Systems. IEEE Transactions on Neural Networks and Learning Systems.](https://www.researchgate.net/publication/304403209_Methodology_of_Recurrent_Laguerre-Volterra_Network_for_Modeling_Nonlinear_Dynamic_Systems)
