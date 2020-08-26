function y=reverse_data(x)
[m n]=max(x',[],2);
for i=1:length(n)
if n(i)==1;
    y(i)=0.3;
elseif n(i)==2;
    y(i)=0.5;
elseif n(i)==3;
    y(i)=0.7;
    elseif n(i)==4;
    y(i)=0.9;
    
end

end