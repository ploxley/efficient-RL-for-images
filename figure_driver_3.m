num_locs_vec = 2:43; % Parameterizes number of states
horizon = 30;
p = 0.75;            % Markov chain parameter
initial_state1 = {[0,1],[0,0]};
initial_state2 = {[0,0],[0,0]};
path = '../image_data/';
stored_states = zeros(length(filename_vec),2);
fundImLen = length(load([path '/ImGDS_cps201005032372.txt']));

for j = 1:length(filename_vec)
    filename = filename_vec{j};
    files = [path filename];
    files_struct = dir(files);
    single_im = zeros(1,2);
    single_im2 = zeros(2,2);
    counter2 = zeros(1,2);
    disp("loading image ")
    image = load([path files_struct(1).name]);
    % Find limiting number of states for each image representation
    for k = 1:length(num_locs_vec)
        sqrt_num_locations = num_locs_vec(k);
        RL = RL_benchmark(horizon, sqrt_num_locations, p);
        rl_num_states(k) = RL.num_states;
    end
    key = @(k,a,b) 0;
    [sqrt_num_pixels, pixel_ranges] = find_image_patches(image, key, fundImLen, RL);
    best = max(find(rl_num_states(rl_num_states > 0) <= sqrt_num_pixels^2));
    if (best + 1 > length(num_locs_vec))
        other = best;
    else
        other = best + 1;
    end
    stored_states(j,:) = [num_locs_vec(best), num_locs_vec(other)];
    % Inner loop
    index = 1;
    for k = best:other
        sqrt_num_locations = num_locs_vec(k);
        disp(strcat("image ", num2str(1)))
        disp(filename)
        disp(num2str(sqrt_num_locations)); disp(' ')
        RL = RL_benchmark(horizon, sqrt_num_locations, p);
        key = @(k,a,b) keyHash([a(1) a(2) b(1) b(2) k]);
        [sqrt_num_pixels, pixel_ranges] = ...
            find_image_patches(image, key, fundImLen, RL);
        input_image{1} = image;
        r = zeros(sqrt_num_pixels^2,RL.N+1);
        [r,iter,flag,relres] = RL_fitted_VI(r,input_image,pixel_ranges,sqrt_num_pixels,key,RL);
        policy = @(i,k) RL_fvi_opt_policy(i, k, r, input_image, pixel_ranges, key, RL);
        J_fvi = RL_policy_eval(policy, key, RL);
        % Collect results for each number of states over all images
        tcost  = J_fvi(key(1,initial_state1{1},initial_state1{2}));
        single_im(index) = tcost + single_im(index);
        single_im2(:,index) = [RL.num_states,sqrt_num_pixels];
        counter2(index) = 1 + counter2(index);
        index = index + 1;
    end
    % Average results over all images
    all_im{j} = {single_im./counter2, single_im2, counter2};
end

% Optimal and greedy calculations
stored_states = stored_states(:);
for k = 1:length(stored_states)
    sqrt_num_locations = stored_states(k);
    RL = RL_benchmark(horizon, sqrt_num_locations, p);
    d = max(RL.N+2,2*sqrt_num_locations);
    key = @(k,a,b) keyHash([a(1) a(2) b(1) b(2) k]);
    J_star = RL_exact(key, RL);
    oc(k) = J_star(key(1,initial_state1{1},initial_state1{2}));
    policy = @(i,k) RL_greedy_policy(i, RL);
    J_greedy = RL_policy_eval(policy, key, RL);
    gc(k) = J_greedy(key(1,initial_state2{1},initial_state2{2}));
end
% Include optimal and greedy results
all_im = [all_im oc gc];

% Plot results
my_color = ['c','r','g','b'];
x2 = 0;
for m = 1:length(filename_vec)
    rep_ave_costs = all_im{m}{1};
    rl_num_states = all_im{m}{2}(1,:);
    rep_sqrt_num_pix = all_im{m}{2}(2,:);
    patch_line(m) = rep_sqrt_num_pix(1)^2
    best = max(find(rl_num_states(rl_num_states > 0) <= patch_line(m)));
    other = best + 1;
    x1 = x2 + 1;
    x2 = x1 + 1;
    store(x1) = rl_num_states(best); 
    store(x2) = rl_num_states(other);
    hold on; bar(x1, rep_ave_costs(best),my_color(m));
    hold on; bar(x2, abs(rep_ave_costs(other)),my_color(m));
end
hold on; bar(x2+1,all_im{end-1}(end))
hold on; bar(x2+2,all_im{end}(end))
xticks(1:length(store)+2)
xticklabels([arrayfun(@num2str,store,'UniformOutput',false) {'Optimal'} {'Greedy'}])
box on; xlabel('Number of Stored Cost-To-Goes');
ylabel('Expected Total Cost')
legend("\times 1 Whitened Image","","\times 4 Sparse Image","","\times 16 Sparse Image","","\times 64 Sparse Image");
legend('boxoff'); ylim([0 40])

