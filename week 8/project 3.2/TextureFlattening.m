function I = TextureFlattening
    
% read image and mask
target = im2double(imread('bean.jpg')); 
mask = imread('mask_bean.dib');

% edge detection
Edges = edge(rgb2gray(target),'canny',0.1);
M = Edges;


N=sum(mask(:));  % N: Number of unknown pixels == variables

% enumerating pixels in the mask
mask_id = zeros(size(mask));
mask_id(mask) = 1:N;   
    
% neighborhood size for each pixel in the mask
[ir,ic] = find(mask);
%ir - column indices of non-zero elements
%ic - row indices of non-zero elements
Np = zeros(N,1); 


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
          if M(i,j) == true || M(i-1,j) == true
              b(ib)=b(ib)+ target(i-1,j,color)*(1-mask(i-1,j))+...
                              target(i,j,color)-target(i-1,j,color);
          else
              b(ib)=b(ib)+ target(i-1,j,color)*(1-mask(i-1,j));
          end
      end
      
      if (i<size(mask,1))
          if M(i,j)== true ||M(i+1,j) == true
              b(ib)=b(ib)+ target(i+1,j,color)*(1-mask(i+1,j))+ ...
              target(i,j,color)-target(i+1,j,color);
          else
              b(ib)=b(ib)+  target(i+1,j,color)*(1-mask(i+1,j));
          end
      end

      if (j>1)
          if M(i,j)== true ||M(i,j-1) == true
              b(ib)= b(ib) + target(i,j-1,color)*(1-mask(i,j-1))+...
              target(i,j,color)-target(i,j-1,color);
          else
              b(ib)= b(ib) +  target(i,j-1,color)*(1-mask(i,j-1));
          end
      end

      if (j<size(mask,2))
          if M(i,j)== true ||M(i,j+1) == true
              b(ib)= b(ib)+ target(i,j+1,color)*(1-mask(i,j+1))+...
              target(i,j,color)-target(i,j+1,color);
          else
              b(ib)= b(ib)+ target(i,j+1,color)*(1-mask(i,j+1)); 
          end
      end
      
    end
    


    
     % solve linear system A*x = b;
    % your CODE begins here

    x = A\b;
    % your CODE ends here

   
    


    
    % impaint target image
    
     for ib=1:N
           seamless(ir(ib),ic(ib),color) = x(ib);
     end
    
end
     I = seamless;
     figure(1), imshow(target)
     figure(2), imshow(seamless)
end
