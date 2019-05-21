function Ic = ImageCarving(N)

% N: number of vertical seams you have to remove


% read image
I = im2double(imread('waterfall.png'));

% get grayscale image
Ig0 = rgb2gray(im2double(I));

% colored image 
Ic = I; 


for iIter = 1:N

    Ig = rgb2gray(Ic);
    Gx = imfilter(Ig,.5*[-1 0 1],'replicate');
    Gy = imfilter(Ig,.5*[-1 0 1]','replicate');
    E = abs(Gx) +  abs(Gy); % energy
    M = zeros(size(Ig)); % cumulative energy
    % your CODE starts here
    P = zeros(size(Ig));
    M(1,:) = E(1,:);
    for r = 2:size(Ig,1)
        for c = 1:size(Ig,2)
            if c == 1
                neighbour = M(r-1,1:2);
                [m,n] = min(neighbour);
                M(r,c) = E(r,c) + m;
                P(r,c) = n-1;
            elseif c == size(Ig,2)
                neighbour = M(r-1,size(Ig,2)-1:size(Ig,2));
                [m,n] = min(neighbour);
                M(r,c) = E(r,c) + m;
                P(r,c) = n-2;
            else
                neighbour = M(r-1,c-1:c+1);
                [m,n] = min(neighbour);
                M(r,c) = E(r,c) + m;
                P(r,c) = n-2;
            end
        end
    end
    
    
    pix_removal = zeros(size(Ig,1),2);
    [minV,end_pixel] = min(M(size(Ig,1),:));
    pix_removal(end,:) = [size(pix_removal,1) end_pixel];
    
    
    for r = size(Ig,1)-1:-1:1
        parent_index = pix_removal(r+1,:);
        current = parent_index(2) + P(parent_index(1),parent_index(2));
        pix_removal(r,1) = r;
        pix_removal(r,2) = current;
    end
    
    I_new = zeros(size(Ic,1),size(Ic,2)-1,size(Ic,3));
    for k = 1:3
        for r = 1:size(Ic,1)
            interim = Ic(r,:,k);
            interim(pix_removal(r,2)) = [];
            I_new(r,:,k) = interim;
        end
    end
    Ic = I_new;
        
end
size(I)
size(Ic)
                
% figure(1),imshow(I)
% figure(2),imshow(Ic)

    % your CODE ends here


end


% figure(1)
% imshow(I)
% figure(2),
% imshow(Ic)


