function g = reduce(I)

    % Input:
    % I: the input image
    % Output:
    % g: the image after Gaussian blurring and subsampling

    % Please follow the instructions to fill in the missing commands.
    
    % 1) Create a Gaussian kernel of size 5x5 and 
    % standard deviation equal to 1 (MATLAB command fspecial)
    G = fspecial('gaussian',[5 5],1);
    % 2) Convolve the input image with the filter kernel (MATLAB command imfilter)
    % Tip: Use the default settings of imfilter
    I1 = imfilter(I,G);
    % 3) Subsample the image by a factor of 2
    % i.e., keep only 1st, 3rd, 5th, .. rows and columns
    [m,n,o] = size(I1);
    r = 0;
    c = 0;
    if mod(m,2) == 1
        r = (m+1)/2;
    else
        r = m/2;
    end
    
    if mod(n,2) == 1
        c = (n+1)/2;
    else
        c = n/2;
    end
    
    I2 = zeros(r,c,o);
    for x = 1:o
        for i = 0:(r-1)
            for j = 0:(c-1)
                I2(i+1,j+1,x) = I1(2*i+1,2*j+1,x);
            end
        end
    end    
    g = I2;  

end