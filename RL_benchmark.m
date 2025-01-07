function RL = RL_benchmark(horizon, sqrt_num_locations, p) 

% Returns primitive objects required for reinforcement learning benchmark

% Length of horizon
RL.N = horizon;

% Range of controller and target coordinates on square grid.
ct = zeros(sqrt_num_locations^2, 2); 
for i = 1:sqrt_num_locations
    for j = 1:sqrt_num_locations
        ct(j+(i-1)*sqrt_num_locations,:) = [i,j];
    end
end

% Controller and target coordinate differences.
differences = zeros(sqrt_num_locations^4,2);
for i = 1:sqrt_num_locations^2
    for j = 1:sqrt_num_locations^2
        differences(j+(i-1)*sqrt_num_locations^2,:) = ct(i,:) - ct(j,:);
    end
end

% Coordinate difference set D
RL.D = unique(differences,'rows');

% Target dynamics set T
r = {[0,1]};    
s = {[0,0]};
d = {[1,1]}; 
RL.T = [r,s,d]; 

% State space S = D x T for benchmark
for i = 1:length(RL.D)
    for j = 1:length(RL.T)
        RL.S{j+(i-1)*length(RL.T)} ... 
            = {RL.D(i,:), RL.T{j}};
    end
end
RL.num_states = length(RL.S);

RL.S_samples = RL.S;
RL.num_samples = RL.num_states;

% Uncomment for Figure 10

% RL.S_samples = {};
% RL.num_samples = floor(RL.num_states*0.78); % Can vary
% % Prefer at least one non-negative spatial coordinate
% counter = 1;
% for i = 1:RL.num_states
%     if (RL.S{i}{1}(1) >= 0 ||  RL.S{i}{1}(2) >= 0)
%         RL.S_samples{counter} = RL.S{i}; 
%         counter = counter + 1;
%     end
% end
% if (counter - 1 > RL.num_samples)
%     disp('ERROR: not enough samples')
% end
% if (counter - 1 < RL.num_samples)
%     counter2 = 1;
%     for i = counter:RL.num_samples
%         while(RL.S{counter2}{1}(1) >= 0 ||  RL.S{counter2}{1}(2) >= 0)
%             counter2 = counter2 + 1;
%         end
%         RL.S_samples{i} = RL.S{counter2};
%         counter2 = counter2 + 1;
%     end
% end

% Control set
RL.U = {[1,0],[0,1],[0,0]};

% Cost per time period
RL.g = @(x) norm(x)^2; 

% Transition probabilities 
RL.P = @(i,j,u) P(i,j,u);

% Markov chain for target dynamics
RL.p = @(b1,b2) prob(b1,b2);

function rhs = P(i,j,u)
    [a1,b1] = i{:}; % "i" is RL.S{index1}
    [a2,b2] = j{:}; % "j" is RL.S{index2}
    if (a2 == a1 + u - b2)
        rhs = prob(b1,b2);
    else
        rhs = 0.0;
    end
end

function rhs = prob(b1,b2)
    if isequal(b1,r{:})
        if isequal(b2,r{:})
            rhs = p;
        elseif isequal(b2,s{:})
            rhs = 1 - p;
        else
            rhs = 0.0;
        end
    elseif (isequal(b1,s{:}) && isequal(b2,d{:}))
        rhs = 1.0;
    elseif (isequal(b1,d{:}) && isequal(b2,r{:}))
        rhs = 1.0;
    else
        rhs = 0.0;
    end
end

end





