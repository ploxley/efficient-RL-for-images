function u_g = RL_greedy_policy(i, RL)

% Returns greedy control given current state.

rhs = zeros(1,length(RL.U));
for u = 1:length(RL.U)
    sum1 = 0.0;
    for t = 1:length(RL.T)
        b2 = RL.T{t};
        a2 = i{1} + RL.U{u} - b2;
        if (RL.p(i{2},b2) > 1e-10)
            sum1 = sum1 + RL.p(i{2},b2)*RL.g(a2);
        end
    end
    rhs(u) = sum1;
end
[~,I] = min(rhs);
u_g = RL.U{I};