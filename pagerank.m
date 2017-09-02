%function from http://www.math.iit.edu/~fass/matlab/pagerank.m
function x = pagerank(U,G,p)
% PAGERANK  Google's PageRank
% pagerank(U,G,p) uses the URLs and adjacency matrix produced by SURFER,
% together with a damping factory p, (default is .85), to compute and plot
% a bar graph of page rank, and print the dominant URLs in page rank order.
% x = pagerank(U,G,p) returns the page ranks instead of printing.
% See also SURFER, SPY.

if nargin < 3, p = .85; end

% Eliminate any self-referential links

G = G - diag(diag(G));
  
% c = out-degree, r = in-degree

[n,n] = size(G);
c = full(sum(G,1));   % modified by G.F. so that sprintf does not get sparse input 
r = full(sum(G,2));   % (which it used to be able to handle, but no longer can)

% Scale column sums to be 1 (or 0 where there are no out links).

k = find(c~=0);
D = sparse(k,k,1./c(k),n,n);

% Solve (I - p*G*D)*x = e

e = ones(n,1);
I = speye(n,n);
x = (I - p*G*D)\e;

% Normalize so that sum(x) == 1.

x = x/sum(x);

% Bar graph of page rank.

shg
bar(x)
title('Page Rank')

% Print URLs in page rank order.

if nargout < 1
   [ignore,q] = sort(-x);
   disp('     page-rank  in  out  url')
   k = 1;
   while (k <= n) & (x(q(k)) >= .005)
      j = q(k);
      disp(sprintf(' %3.0f %8.4f %4.0f %4.0f  %s', ...
         j,x(j),r(j),c(j),U{j}))
      k = k+1;
   end
   %erotima 2o
   pos= randi(n); %position of A
   A = U(pos) %url
   x(pos) %pagerank of A 
   %B = G(pos, :); %the pages that connect with A
   %PR = x(1:10);
   k=1; m=1; 
   disp('     page-rank  in  out  url        pagerank of A')
   while(k <= 10) & (x(q(k)) >= .005)
       if(c(k)~=0)
           prank = x(pos)+x(k)/(c(k)+1);
       else
           prank = x(pos) + x(k);
       end
       disp(sprintf(' %3.0f %8.4f %4.0f %4.0f  %s  %8.4f', ...
         k,x(k),r(k),c(k),U{k},prank))
       k=k+1;
   end
   
   %erotima 3o
   %trim A
   Adomain = regexp(A, ...
     '([^/]*)(?=/[^/])','match');
   while(k <= n) & (x(q(k)) >= .005)
       %trim url
       Udomain = regexp(U(k), ...
            '([^/]*)(?=/[^/])','match');
       if(strcmp(Adomain(1),Udomain(1)))
           if(c(k)~=0)
               prank = x(pos)+x(k)/(c(k)+1);
           else
               prank = x(pos) + x(k);
           end
           disp(sprintf(' %3.0f %8.4f %4.0f %4.0f  %s  %8.4f', ...
               k,x(k),r(k),c(k),U{k},prank))
           k=n+1;
       else
           disp('URL with domain of A not found')
       end
       k=k+1;
   end
   
end


