function J = RL_exact(key, RL)

% Implementation of the dynamic programming algorithm.

% Cost-to-go values
J = containers.Map('KeyType','double','ValueType','double');

% Set terminal cost.
for s = 1:RL.num_states
    J(key(RL.N+1, RL.S{s}{1}, RL.S{s}{2})) = 0.0;
end

% Backwards iteration of dynamic programming algorithm
for k = RL.N:-1:1
    for s = 1:RL.num_states
        rhs = zeros(1,length(RL.U)); 
        for u = 1:length(RL.U)
            sum1 = 0.0;
            for t = 1:length(RL.T)
                if (RL.p(RL.S{s}{2},RL.T{t}) > 1e-10) % valid next target-move?
                    b2 = RL.T{t};                    
                    a2 = RL.S{s}{1} + RL.U{u} - b2;
                    if isKey(J,key(k+1,a2,b2)) % valid control?
                        sum1 = sum1 + RL.p(RL.S{s}{2},b2)*J(key(k+1,a2,b2));
                    else
                        sum1 = 1e6; % Penalty for using non-feasible control
                    end
                end
            end
            rhs(u) = sum1;
        end
        J(key(k,RL.S{s}{1},RL.S{s}{2})) = RL.g(RL.S{s}{1}) + min(rhs);
    end
end