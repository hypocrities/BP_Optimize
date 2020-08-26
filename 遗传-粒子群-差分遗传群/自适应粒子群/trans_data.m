function y=trans_data(x)
y=zeros(4,250);
for i=1:250
    if x(i)==0.3;
        y(:,i)=[1 0 0 0]';
    elseif x(i)==0.5
        y(:,i)=[0 1 0 0]';
    elseif x(i)==0.7
        y(:,i)=[0 0 1 0]';
    elseif x(i)==0.9
        y(:,i)=[0 0 0 1]';
    end
        




end