n = 51;len = 0;n_runs = 1e5;p = 0.4;r = 0.5;queueLength = zeros(1,n_runs);count = zeros(1, 51);for i=1:n_runs    u1 = rand();        u2 = rand();        if len == 0        if u1 <= p            len = len+1;        end    elseif len == 50        if u2 <= r            len = len-1;        end     else         if u1 <= p                len=len+1;         end         if u2 <= r                len = len-1;         end     end     queueLength(i)= len;    count(len+1) = count(len+1) + 1; end     %Practical stationary vector prac = count/n_runs; prac'  %Creating transition matrix    matrix = zeros(n,n);    matrix(1,1)=1-p;    matrix(1,2)=p;    row=zeros(1,48);    % P(s+1) = P(A-B) = p - p*r  = 0.4 - 0.2 = 0.2 : Probability of only increasing length    % P(s-1) = P(B-A) = r - p*r  = 0.5 - 0.2 = 0.3 : Probability of only decreasing length    % P(s) = 1 - P(s+1) - P(s-1) =  0.5                  : Probability of only decreasing length    row =[r - p*r, 1 - p - r + 2*p*r, p - p*r, row];        for j=2:n-1        matrix(j,:)=row;        row = [0,row(1:end-1)];    end        matrix(end,end)=1-r;    matrix(end,end-1)=r;        PI = zeros(1, 51);    PI(1) = 1;    V = PI*matrix;        for step = 1:n_runs      V = V*matrix;    end    %Theoretical stationary vector    theo = V;    V'    %Stationary Vector%pis = [matrix' - eye(size(matrix)); ones(1, length(matrix))] \ [zeros(length(matrix), 1); 1];%pis' - count/n_runs;error = count/n_runs - V;error'%----------------------------------------------------------------len = 0;p = 0.5;r = 0.4;queueLength = zeros(1,n_runs);count = zeros(1, 51);for i=1:n_runs    u1 = rand();        u2 = rand();        if len == 0        if u1 <= p            len = len+1;        end    elseif len == 50        if u2 <= r            len = len-1;        end     else         if u1 <= p                len=len+1;         end         if u2 <= r                len = len-1;         end     end     queueLength(i)= len;    count(len+1) = count(len+1) + 1; end     %Practical stationary vector prac2 = count/n_runs; prac2'  %Creating transition matrix    matrix = zeros(n,n);    matrix(1,1)=1-p;    matrix(1,2)=p;    row=zeros(1,48);    % P(s+1) = P(A-B) = p - p*r  = 0.5 - 0.2 = 0.3 : Probability of only increasing length    % P(s-1) = P(B-A) = r - p*r  = 0.4 - 0.2 = 0.2 : Probability of only decreasing length    % P(s) = 1 - P(s+1) - P(s-1) =  0.5                  : Probability of only decreasing length    row =[r - p*r, 1 - p - r + 2*p*r, p - p*r, row];        for j=2:n-1        matrix(j,:)=row;        row = [0,row(1:end-1)];    end        matrix(end,end)=1-r;    matrix(end,end-1)=r;        PI = zeros(1, 51);    PI(1) = 1;    V = PI*matrix;        for step = 1:n_runs      V = V*matrix;    end    %Theoretical stationary vector    theo2 = V;    V'%Stationary Vector%pis = [matrix' - eye(size(matrix)); ones(1, length(matrix))] \ [zeros(length(matrix), 1); 1];%pis' - count/n_runs;error2 = count/n_runs - V;error2'%Difference when probabilities changeFinal_error = prac - prac2;%hist(queueLength, 100)%prac =%% Columns 1 through 18:%%   0.19836   0.26972   0.18062   0.12136   0.07956   0.04962   0.03335   0.02235   0.01503   0.00931   0.00641   0.00441   0.00334   0.00252   0.00144   0.00087   0.00064   0.00036%% Columns 19 through 36:%%   0.00038   0.00026   0.00008   0.00001   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000%% Columns 37 through 51:%%   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000   0.00000%%theo =%% Columns 1 through 14:%%   2.0000e-01   2.6667e-01   1.7778e-01   1.1852e-01   7.9012e-02   5.2675e-02   3.5117e-02   2.3411e-02   1.5607e-02   1.0405e-02   6.9366e-03   4.6244e-03   3.0829e-03   2.0553e-03%% Columns 15 through 28:%%   1.3702e-03   9.1346e-04   6.0898e-04   4.0598e-04   2.7066e-04   1.8044e-04   1.2029e-04   8.0194e-05   5.3463e-05   3.5642e-05   2.3761e-05   1.5841e-05   1.0561e-05   7.0404e-06%% Columns 29 through 42:%%   4.6936e-06   3.1291e-06   2.0860e-06   1.3907e-06   9.2713e-07   6.1809e-07   4.1206e-07   2.7470e-07   1.8314e-07   1.2209e-07   8.1394e-08   5.4263e-08   3.6175e-08   2.4117e-08%% Columns 43 through 51:%%   1.6078e-08   1.0719e-08   7.1457e-09   4.7638e-09   3.1759e-09   2.1172e-09   1.4115e-09   9.4100e-10   3.7640e-10%%error =%% Columns 1 through 14:%%  -1.6400e-03   3.0533e-03   2.8422e-03   2.8415e-03   5.4765e-04  -3.0549e-03  -1.7666e-03  -1.0611e-03  -5.7738e-04  -1.0949e-03  -5.2661e-04  -2.1441e-04   2.5706e-04   4.6471e-04%% Columns 15 through 28:%%   6.9805e-05  -4.3463e-05   3.1024e-05  -4.5984e-05   1.0934e-04   7.9563e-05  -4.0291e-05  -7.0194e-05  -5.3463e-05  -3.5642e-05  -2.3761e-05  -1.5841e-05  -1.0561e-05  -7.0404e-06%% Columns 29 through 42:%%  -4.6936e-06  -3.1291e-06  -2.0860e-06  -1.3907e-06  -9.2713e-07  -6.1809e-07  -4.1206e-07  -2.7470e-07  -1.8314e-07  -1.2209e-07  -8.1394e-08  -5.4263e-08  -3.6175e-08  -2.4117e-08%% Columns 43 through 51:%%  -1.6078e-08  -1.0719e-08  -7.1457e-09  -4.7638e-09  -3.1759e-09  -2.1172e-09  -1.4115e-09  -9.4100e-10  -3.7640e-10