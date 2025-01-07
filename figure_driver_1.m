% Finds and evaluates optimal and greedy policies for benchmark
% for all horizons from 1 to horizon_max.

% Maximum horizon length
horizon_max = 30;

% Parameterizes number of benchmark states via set D: 
% i.e., smallest value of 2 corresponds to 27 states.
% Maximum spatial range in states is:
% [sqrt_num_locations - 1, sqrt_num_locations - 1]
sqrt_num_locations = 5;            

% Keys for map containers
key = @(k,a,b) keyHash([a(1) a(2) b(1) b(2) k]);

% Find and evaluate optimal and greedy policies
for t = 1:horizon_max
    RL = RL_benchmark(t, sqrt_num_locations, p);
    J_star = RL_exact(key, RL);
    oc(t) = J_star(key(1,initial_state_opt{1},initial_state_opt{2}));
    policy = @(i,k) RL_greedy_policy(i, RL);
    J_greedy = RL_policy_eval(policy, key, RL);
    gc(t) = J_greedy(key(1,initial_state_greedy{1},initial_state_greedy{2}));
end

figure(1);
hold on; plot(1:horizon_max, oc, '-ob')
hold on; plot(1:horizon_max, gc, '-+r')
legend("Optimal Policy","Greedy Policy")
legend('boxoff')
legend('location','northwest')
xlabel('Horizon')
ylabel('Total Cost')
box on

% Uncomment to include policy for fitted value iteration

% path = 'image_data/';
% fundImLen = length(load([path '/ImGDS_cps201005032372.txt']));
% filename = 'W*.txt';
% files = [path filename];
% files_struct = dir(files);
% image = load([path files_struct(1).name]);
% input_image{1} = image;
% fvc = zeros(1,horizon_max);
% for t = 1:horizon_max
%     RL = RL_benchmark(t, sqrt_num_locations, p); 
%     [sqrt_num_pixels, pixel_ranges] = find_image_patches(image, key, fundImLen, RL);
%     r = zeros(sqrt_num_pixels^2,RL.N+1);
%     [r,iter,flag,relres] = RL_fitted_VI(r,input_image,pixel_ranges,sqrt_num_pixels,key,RL);
%     policy = @(i,k) RL_fvi_opt_policy(i, k, r, input_image, pixel_ranges, key, RL);
%     J_fvi = RL_policy_eval(policy, key, RL);
%     fvc(t) = J_fvi(key(1,initial_state_opt{1},initial_state_opt{2}));
% end
% hold on; plot(1:horizon_max, fvc, '-+k')
% legend("Optimal Policy","Greedy Policy","Fitted VI")