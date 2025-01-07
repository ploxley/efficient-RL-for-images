p = 0.4;            % Markov chain parameter
path = '../image_data/';
fundImLen = length(load([path '/ImGDS_cps201005032372.txt']));
files = [path filename];
files_struct = dir(files);
image = load([path files_struct(1).name]);
input_image{1} = image;
key = @(k,a,b) keyHash([a(1) a(2) b(1) b(2) k]);

% Optimal and greedy calculations over all initial states
RL = RL_benchmark(horizon, sqrt_num_locations, p);
J_star = RL_exact(key, RL);
policy = @(i,k) RL_greedy_policy(i, RL);
J_greedy = RL_policy_eval(policy, key, RL);
all = zeros(num_states,3);
for n = 1:num_states
    initial_state = RL.S{n};
    oc = J_star(key(1,initial_state{1},initial_state{2}));
    gc = J_greedy(key(1,initial_state{1},initial_state{2}));
    all(n,1:2) = [gc oc];
end

% Fitted value iteration over all initial states
fvc_stored = zeros(num_states, 1);
RL = RL_benchmark(horizon, sqrt_num_locations, p);
[sqrt_num_pixels, pixel_ranges] = find_image_patches(image, key, fundImLen, RL);
r = zeros(sqrt_num_pixels^2,RL.N+1);
[r,iter,flag,relres] = RL_fitted_VI(r,input_image,pixel_ranges,sqrt_num_pixels,key,RL);
policy = @(i,k) RL_fvi_opt_policy(i, k, r, input_image, pixel_ranges, key, RL);
J_fvi = RL_policy_eval(policy, key, RL);
for n = 1:num_states
    initial_state = RL.S{n}; 
    fvc_stored(n) = J_fvi(key(1,initial_state{1},initial_state{2}));
end
for n = 1:num_states
    all(n,:) = [all(n,1:2) fvc_stored(n)];
end

% Filter, sort, and plots
I = find(all(:,2) < 1e6); % Detects nonfeasible control states, i.e. [-n,-n]
num_states
kept = length(I)
result = zeros(length(I),3);
for i = 1:length(I)
    result(i,:) = all(I(i),:); % Removes nonfeasible control states
end
[~,II] = sort(result(:,2));
plot_result = zeros(length(II),3);
for i = 1:length(II)
    plot_result(i,:) = result(II(i),:);
end
% [RL.S_samples{I(II(i))} all(I(II(i)),:)]

% figure(1); clf
% hold on; plot(plot_result(:,2), 'xb')
% hold on; plot(plot_result(:,1), '+r')
% hold on; plot(plot_result(:,3), 'sqk')
% legend("Optimal Policy","Greedy Policy","FVI")
% legend('boxoff')
% legend('location','northwest')
% xlabel('Task Index')
% ylabel('Total Cost')
% box on

III = find(plot_result(:,2)<plot_result(:,1));
opt = length(III)

figure(2); clf
hold on; plot(plot_result(III,2), 'xb')
hold on; plot(plot_result(III,1), '+r')
hold on; plot(plot_result(III,3), 'sqk')
legend("Optimal Policy","Greedy Policy","Fitted VI")
legend('boxoff')
legend('location','northeast')
xlabel('Task Index')
ylabel('Total Cost')
box on
axis tight
% [RL.S_samples{I(II(III(i)))} all(I(II(III(i))),:)]

IIII = find(plot_result(:,2)==plot_result(:,1));
opt_greedy = length(IIII)

% figure(3); clf
% hold on; plot(plot_result(IIII,2), 'xb')
% hold on; plot(plot_result(IIII,1), '+r')
% hold on; plot(plot_result(IIII,3), 'sqk')
% legend("Optimal Policy","Greedy Policy","FVI")
% legend('boxoff')
% legend('location','northwest')
% xlabel('Task Index')
% ylabel('Total Cost')
% box on
% [RL.S_samples{I(II(IIII(i)))} all(I(II(IIII(i))),:)]

kept
sum = length(IIII) + length(III)

figure(2)
axes('Position',[.17 .43 .45 .45])
box on
xx = linspace(a,b,length(III(a:b)));
hold on; plot(xx, plot_result(III(a:b),2), 'xb')
hold on; plot(xx, plot_result(III(a:b),1), '+r')
hold on; plot(xx, plot_result(III(a:b),3), 'sqk')
axis tight
set(gca,'YTickLabel',[]);

dist1 = plot_result(III,1) - plot_result(III,2);
p1 = fitdist(dist1,'Kernel');
pp = pdf(p1,linspace(0,1.5*max(dist1)));
figure(4); clf
plot(linspace(0,1.5*max(dist1)), pp,'k')
box on
xlabel('Cost Difference between Sampled and Optimal')
ylabel('Probability Density')