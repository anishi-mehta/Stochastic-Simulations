n_runs = 1e5;count = 0;n = 10;m = 4;for i = 1:n_runs    pos = 0;    for j = 1:n        u = rand;        if u <= 0.5            pos = pos - 1;        else            pos = pos+1;        end        if pos == m            count = count + 1;            break;        end    endendans=count/n_runs%--------------------------------------------------n = 10;m = 4;C = zeros(n,1);for i = m:n    if i >= m        if mod((i + m), 2) == 0            temp = nchoosek(i, (i + m)/2)/(power(2, i));        else            temp = 0;        end        C(i,1) = (m/i)*temp;    endendans2=sum(C)%Practical =  0.22803%Theoretical =  0.22656