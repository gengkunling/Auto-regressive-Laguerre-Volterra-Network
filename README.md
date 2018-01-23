Modeling Hodgkin-Huxley Equations with Autoregressive Laguerre-Volterra Network (ASLVN)

1. Generate H-H Data
Run HH_data_gen.m to generate the training data HH_train.mat and test data HH_test.mat. In order to change the parameters of H-H equations, please go to HH_equation.m.

2. Train ASLVN
Run ASLVN_train.m. The program will use the training data from HH_train.mat and optimize the ASLVN using simulated annealing algorithm.  The results are stored in the ASLVN_training_results.mat.

3. Evaluate the ASLVN using test data
Run ASLVN_test.m.  The program will load the test data from HH_test.mat and the ASLVN model from ASLVN_training_results.mat. Then it will evaluate the model performance by plotting the continuous data predictions, binary data predictions and ROC plot.

For more details, please look into the ASLVN_paper.pdf included. 
