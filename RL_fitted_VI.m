 function [r, iter, tol, relres] = ...
     RL_fitted_VI(r, images, pixel_ranges, sqrt_num_pixels, key, RL)

% Performs Fitted Value Iteration to determine r (vector of weights) for a 
% linear network function approximator. The function approximator is a 
% scalar product between r and an image patch (representation).

% Initializations and memory allocations
maxiters = 50000; 
tol = 1e-6;       
%v = gpuArray(zeros(RL.num_samples,sqrt_num_pixels^2)); % To enable GPU
v = zeros(RL.num_samples,sqrt_num_pixels^2);
beta = zeros(RL.num_samples,1);

% Value Iteration algorithm
for k = RL.N:-1:1
    for s = 1:RL.num_samples
        rhs = zeros(1,length(RL.U));
        for u = 1:length(RL.U)
            sum1 = 0.0;
            for t = 1:length(RL.T)
                if (RL.p(RL.S_samples{s}{2},RL.T{t}) > 1e-10) % valid next target-move?
                    b2 = RL.T{t};
                    a2 = RL.S_samples{s}{1} + RL.U{u} - b2;
                    if isKey(pixel_ranges,key(1,a2,b2)) % valid control?
                        I = pixel_ranges(key(1,a2,b2));
                        %v_store = images{k+1}(I(1):I(2),I(3):I(4));
                        v_store = images{1}(I(1):I(2),I(3):I(4)); % repeat same image
                        sum1 = sum1 + RL.p(RL.S_samples{s}{2},b2)...
                            *(v_store(:)'*r(:,k+1));
                    else
                        sum1 = 1e6; % Penalty for using non-feasible control
                    end
                end
            end
            % abs(.) is necessary only for Fig. 10 and can be replaced 
            % by sum1 otherwise. 
            rhs(u) = abs(sum1);
        end
        beta(s) = RL.g(RL.S_samples{s}{1}) + min(rhs);
    end
    % Get image vector corresponding to current state
    for s = 1:RL.num_samples
        I = pixel_ranges(key(1,RL.S_samples{s}{1},RL.S_samples{s}{2}));
        %v_store = images{k}(I(1):I(2),I(3):I(4));
        v_store = images{1}(I(1):I(2),I(3):I(4)); % repeat same image
        v(s,:) = v_store(:);
    end
    % Use matlab's least squares solver to determine the weights
    [r(:,k),~,relres,iter] = lsqr(v,beta,tol,maxiters);
end