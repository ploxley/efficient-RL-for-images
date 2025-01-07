function u_star = RL_fvi_opt_policy(i, k, r, images, pixel_ranges, key, RL)

%%% Returns optimal control given state and time period

rhs = zeros(1,length(RL.U));
for u = 1:length(RL.U)
    sum1 = 0.0;
    for t = 1:length(RL.T)
        if (RL.p(i{2},RL.T{t}) > 1e-10)
            b2 = RL.T{t};
            a2 = i{1} + RL.U{u} - b2;
            if (isKey(pixel_ranges,key(1,a2,b2)))
                I = pixel_ranges(key(1,a2,b2));
                v_store = images{1}(I(1):I(2),I(3):I(4));
                sum1 = sum1 + RL.p(i{2},b2)*(v_store(:)'*r(:,k+1));
            else
                sum1 = 1e6; % Penalty for using non-feasible control
            end
        end
    end
    rhs(u) = sum1; 
end
[~,I] = min(rhs);
u_star = RL.U{I};