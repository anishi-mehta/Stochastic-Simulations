%Group members:% Harshita Sahijwani : 201301179% Aarushi Sanghani: 201401403% Nirvisha Mankad: 201401421% Anishi Mehta: 201401439n_sim = 1e5;time = 240/365;dt = 1/365;t = 0:dt:time;S_avg = zeros(1, length(t));mu = 0.18;sigma = 0.3;for i = 1:n_sim    S = ones(1, length(t));    S(1) = 100;    B = zeros(1, length(t));    for step = 2:length(t)        u1 = rand();        u2 = rand();        r = -2*log(u1);        theta = 2*pi*u2;        u3 = r^0.5*cos(theta);        u = u3*(1/365)^0.5;            B(step) = B(step-1) + u;        S(step) = S(1)*exp(sigma*B(step) + (mu - sigma^2/2)*t(step));    end    S_avg = S_avg + S/n_sim;endplot(t, S_avg);title('Stock Price of XYZ');ylabel('Stock Price');xlabel('Time (days)');