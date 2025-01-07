function J = RL_policy_eval(policy, key, RL)

% Implements policy evaluation using dynamic programming iterations.

% Cost-to-go values
J = containers.Map('KeyType','double','ValueType','double');

% Set terminal cost.
for s = 1:RL.num_states
    J(key(RL.N+1, RL.S{s}{1}, RL.S{s}{2})) = 0.0;
end

% Policy evalution using dynamic programming iterations
for k = RL.N:-1:1
    for s = 1:RL.num_states
        u = policy(RL.S{s}, k);
        sum1 = 0.0;
        for t = 1:length(RL.T)
            if (RL.p(RL.S{s}{2},RL.T{t}) > 1e-10)
                b2 = RL.T{t};
                a2 = RL.S{s}{1} + u - b2;
                if(isKey(J,key(k+1, a2, b2)))
                    sum1 = sum1 + RL.p(RL.S{s}{2},b2)...
                        *J(key(k+1, a2, b2));
                end
            end
        end
        J(key(k,RL.S{s}{1},RL.S{s}{2})) = RL.g(RL.S{s}{1}) + sum1;
    end
end