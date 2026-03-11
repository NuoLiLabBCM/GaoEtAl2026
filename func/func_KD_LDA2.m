
function v= func_KD_LDA2(rr,ll)
 
 
x = [ll;rr];
groupVar = [ones(size(ll,1),1); ones(size(rr,1),1)*2];
 
xm = mean(x);
n=size(x,1);
x = x - xm(ones(n,1),:);       % done with the original x
T = x'*x;
 
% Now compute the Within sum of squares matrix
W = zeros(size(T));
for j=1:2
   r = find(groupVar == j);
   nr = length(r);
   if (nr > 1)
      z = x(r,:);
      xm = mean(z);
      z = z - xm(ones(nr,1),:);
      W = W + z'*z;
   end
end
 
B=T-W;
 
 
[u,s,v]=svd(pinv(W)*B);
