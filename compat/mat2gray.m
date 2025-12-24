function B = mat2gray(A)
% Minimal mat2gray replacement
% Scales numeric array to [0,1] using min/max.

A = double(A);
mn = min(A(:));
mx = max(A(:));

if isempty(mn) || isempty(mx)
    B = A;
    return;
end

if mx <= mn
    B = zeros(size(A));
else
    B = (A - mn) ./ (mx - mn);
end

B(B < 0) = 0;
B(B > 1) = 1;

end
