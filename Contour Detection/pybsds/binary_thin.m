function x = binary_thin(x,n)
    if ~exist('n','var')
          n = Inf;
    end
    x = bwmorph(x,'thin',n);
end