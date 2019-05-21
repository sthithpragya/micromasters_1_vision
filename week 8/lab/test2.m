% read images 
target= im2double(imread('target_3.jpg')); 
source= im2double(imread('source_3.jpg')); 

% mask image
mask=imread('mask_3.dib');

% image offsets
row_offset=20;
col_offset=40; 


% N: Number of pixels in the mask
N=sum(mask(:)); 

% enumerating pixels in the mask
mask_id = zeros(size(mask));
mask_id(mask) = 1:N;

[ir,ic] = find(mask);
%ir - column indices of non-zero elements
%ic - row indices of non-zero elements
Np = zeros(N,1); 

for ib=1:N
    
    i = ir(ib);
    j = ic(ib);
    
    Np(ib)=  double((row_offset+i> 1))+ ...
             double((col_offset+j> 1))+ ...
             double((row_offset+i< size(target,1))) + ...
             double((col_offset+j< size(target,2)));
end

Np