num_locs_vec = 2:43; % Parameterizes number of states
horizon = 1;
p = 0.0;             % Markov chain parameter
path = 'image_data/';
fundImLen = length(load([path '/ImGDS_cps201005032372.txt']));
initial_state = {[0,0],[0,1]};

for j = 1:length(filename_vec)
    filename = filename_vec{j};
    files = [path filename];
    files_struct = dir(files);
    single_im = zeros(1,length(num_locs_vec));
    single_im2 = zeros(2,length(num_locs_vec));
    counter2 = zeros(1,length(num_locs_vec));
    for i = 1:number_of_images 
        disp(strcat("loading image ", num2str(i)))
        image = load([path files_struct(i).name]);
        % Inner loop
        for k = 1:length(num_locs_vec)
            sqrt_num_locations = num_locs_vec(k);
            disp(strcat("image ", num2str(i)))
            disp(filename)
            disp(num2str(sqrt_num_locations)); disp(' ')
            RL = RL_benchmark(horizon, sqrt_num_locations, p);
            key = @(k,a,b) keyHash([a(1) a(2) b(1) b(2) k]);
            [sqrt_num_pixels, pixel_ranges] = ...
                find_image_patches(image, key, fundImLen, RL);
            input_image{1} = image;
            r = zeros(sqrt_num_pixels^2,RL.N+1);
            [~,iter,tol,relres] = RL_fitted_VI(r,input_image,pixel_ranges,sqrt_num_pixels,key,RL);
            if (relres > tol) % default norm(beta-v*r(:,k))
                disp('Bad solver solution!!!!!!!!!!!!');
                disp('relres (1e-6): ')
                disp(relres)
                break
            else
                % Collect results for each number of states over all images
                single_im(k) = iter + single_im(k);
                single_im2(:,k) = [RL.num_states,sqrt_num_pixels];
                counter2(k) = 1 + counter2(k);
            end
        end
    end
    % Average results over all images
    all_im{j} = {single_im./counter2, single_im2, counter2};
end

% Plot results
plotmarkervec = {'k-o','k-^','b-o','b-^'};
for m = 1:length(filename_vec)
    rep_ave_itersT = all_im{m}{1};
    dp_num_statesT = all_im{m}{2}(1,:);
    rep_sqrt_num_pixT = all_im{m}{2}(2,:);
    counter2T = all_im{m}{3};
    len1 = min(nnz(dp_num_statesT ~= 0), nnz(rep_ave_itersT < max_rep_ave_iters));
    len = min(len1, nnz(counter2T >= floor(counter2T(1))));
    rep_ave_iters = rep_ave_itersT(1:len);
    dp_num_states = dp_num_statesT(1:len);
    rep_sqrt_num_pix = rep_sqrt_num_pixT(1:len);
    hold on; plot(log10(dp_num_states), rep_ave_iters, plotmarkervec{m});
    patch_line(m) = rep_sqrt_num_pix(1)^2;
end
for m = 1:length(filename_vec)
    hold on; line([log10(patch_line(m)),log10(patch_line(m))],[0,max_rep_ave_iters],'linestyle','--','linewidth',1,'color',[0.8500 0.3250 0.0980])
end
xticks(log10(ar))
xticklabels(ar)
xlim([log10(min(ar)) log10(max(ar))])
box on; xlabel('Number of Stored Cost-To-Goes (logarithmic scale)');
ylabel('Number of LS Iterations') 
legend(legend_contents)
legend('boxoff')