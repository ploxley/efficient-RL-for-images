% Paper figures 3--10 (see README.md for instructions)

% Uncomment and run each code block as necessary

% % Figure 3
% clear all
% initial_state_opt = {[0,1],[0,0]};
% initial_state_greedy = {[0,0],[0,0]};
% p = 0.0; % Markov chain parameter 
% run("figure_driver_1") 
% p = 1.0;
% run("figure_driver_1")

% % Figure 4
% clear all
% p = 0.0; % Markov chain parameter
% initial_state_opt = {[0,1],[0,0]};
% initial_state_greedy = initial_state_opt;
% run("figure_driver_1")
% initial_state_opt = {[3,0],[0,0]};
% initial_state_greedy = initial_state_opt;
% run("figure_driver_1")
% initial_state_opt = {[4,0],[0,0]};
% initial_state_greedy = initial_state_opt;
% run("figure_driver_1")

% % Figure 5 (number_of_images = 1 instead of 48)
% clear all
% number_of_images = 1; % 48;
% filename_vec = {'ImGDS_*.txt', 'OC_up*.txt', 'W*.txt', 'OC_S*.txt'};
% max_rep_ave_iters = 4e3;
% ar = arrayfun(@(x) 10*x, [2,4,8,16,32,64,128,256]);
% legend_contents = ["\times 1 Raw Image","\times 4 Raw Image","\times 1 Whitened Image","\times 4 Sparse Code"];
% run("figure_driver_2")

% % Figure 6 (number_of_images = 1 takes around 40 minutes with a gpu)
% clear all
% number_of_images = 1; % 48;
% filename_vec = {'W*.txt', 'OC_S*.txt', 'OOC_S*.txt', 'OOOC_S*.txt'};
% max_rep_ave_iters = 10e3;
% ar = arrayfun(@(x) 100*x, [1,2,4,8,16,32,64,128,256]);
% legend_contents = ["","\times 4 Sparse Code","\times 16 Sparse Code","\times 64 Sparse Code"];
% run("figure_driver_2")

% % Figure 7 (takes around 5 to 6 hours with a gpu)
% clear all
% filename_vec = {'W*.txt', 'OC_S*.txt', 'OOC_S*.txt', 'OOOC_S*.txt'};
% run("figure_driver_3")

% % Figures 8 and 9 (num_states = 21675 takes around 33 hours with a gpu:
% % this corresponds to about 10 minutes per time period)
% clear all
% horizon = 200;
% sqrt_num_locations = 43;   % 5, 11, 21, 43
% num_states = 21675;        % 243, 1323, 5043, 21675
% filename = 'OOOC_S*.txt';  % 'W*.txt', 'OC_S*.txt','OOC_S*.txt','OOOC_S*.txt'
% a = 4000; b = 4050;
% run("figure_driver_4")

% % Figure 10: %%% Also need to uncomment code block in RL_benchmark.m %%%
% clear all
% horizon = 400;
% sqrt_num_locations = 11;        
% num_states = 1323; 
% filename = 'OC_S*.txt'; 
% a = 300; b = 350;
% run("figure_driver_4")