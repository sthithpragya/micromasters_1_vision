function [seamless,A] = PoissonImageEditing

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
    
% neighborhood size for each pixel in the mask
[ir,ic] = find(mask);
%ir - column indices of non-zero elements
%ic - row indices of non-zero elements
Np = zeros(N,1); 

%rth element of Np indicates the # of neighbours of r i.e. 2,3,4 etc
for ib=1:N
    
    i = ir(ib);
    j = ic(ib);
    
    Np(ib)=  double((row_offset+i> 1))+ ...
             double((col_offset+j> 1))+ ...
             double((row_offset+i< size(target,1))) + ...
             double((col_offset+j< size(target,2)));
end


% compute matrix A

% your CODE begins here
A = sparse(N,N);
% rows_A = size(A,1);
% A = A - A(logical(eye(rows_A))) + eye(rows_A)*4;
for i = 1:N
    r = ir(i);
    c = ic(i);
    A(i,i) = 4;
    
    if mask(r,c-1) == true
        n1 = mask_id(r,c-1);
        A(i,n1) = -1;
    end 
    
    if mask(r,c+1) == true
        n3 = mask_id(r,c+1);
        A(i,n3) = -1;
    end
    
    if mask(r-1,c) == true
        n2 = mask_id(r-1,c);
        A(i,n2) = -1;
    end
    
    if mask(r+1,c) == true
        n4 = mask_id(r+1,c);
        A(i,n4) = -1;
    end
end
    
size(A)
% your CODE ends here



% output intialization
seamless = target; 


for color=1:3 % solve for each colorchannel

    % compute b for each color
    b=zeros(N,1);
    
    for ib=1:N
    
    i = ir(ib);
    j = ic(ib);
    
            
      if (i>1) 
          b(ib)=b(ib)+ target(row_offset+i-1,col_offset+j,color)*(1-mask(i-1,j))+...
                          source(i,j,color)-source(i-1,j,color);
      end

      if (i<size(mask,1))
          b(ib)=b(ib)+  target(row_offset+i+1,col_offset+j,color)*(1-mask(i+1,j))+ ...
                           source(i,j,color)-source(i+1,j,color);
      end

      if (j>1)
          b(ib)= b(ib) +  target(row_offset+i,col_offset+j-1,color)*(1-mask(i,j-1))+...
                           source(i,j,color)-source(i,j-1,color);
      end


      if (j<size(mask,2))
          b(ib)= b(ib)+ target(row_offset+i,col_offset+j+1,color)*(1-mask(i,j+1))+...
                         source(i,j,color)-source(i,j+1,color); 
      end     


 

    end

    
     % solve linear system A*x = b;
    % your CODE begins here

    x = A\b;
    % your CODE ends here

   
    


    
    % impaint target image
    
     for ib=1:N
           seamless(row_offset+ir(ib),col_offset+ic(ib),color) = x(ib);
     end
    
end


figure(1), imshow(target);
figure(2), imshow(seamless);