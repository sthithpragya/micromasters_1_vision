function M = ImageMorphingTriangulation(warp_frac,dissolve_frac)

if nargin < 1
    warp_frac = .5;
end

if nargin < 2
    dissolve_frac= warp_frac; 
end


% ream images
I = im2double(imread('a.png'));
J = im2double(imread('c.png'));

% load mat file with points, variables Ip,Jp
 load('points.mat');
 
% initialize ouput image (morphed)
M = zeros(size(I));

%  Triangulation (on the mean shape)
MeanShape = (1/2)*Ip+(1/2)*Jp;
TRI = delaunay(MeanShape(:,1),MeanShape(:,2));


% number of triangles
TriangleNum = size(TRI,1); 

% find coordinates in images I and J
CordInI = zeros(3,3,TriangleNum);
CordInJ = zeros(3,3,TriangleNum);

for i =1:TriangleNum
  for j=1:3
    
    CordInI(:,j,i) = [ Ip(TRI(i,j),:)'; 1];
    CordInJ(:,j,i) = [ Jp(TRI(i,j),:)'; 1];
    
  end
end

% create new intermediate shape according to warp_frac
Mp = (1-warp_frac)*Ip+warp_frac*Jp; 


% create a grid for the morphed image
[x,y] = meshgrid(1:size(M,2),1:size(M,1));

% for each element of the grid of the morphed image, find  which triangle it falls in
TM = tsearchn([Mp(:,1) Mp(:,2)],TRI,[x(:) y(:)]);



% YOUR CODE STARTS HERE

K1 = cell(TriangleNum,1);
for i = 1:TriangleNum
    a = TRI(i,1);
    b = TRI(i,2);
    c = TRI(i,3);
    A = [MeanShape(a,:).';1];
    B = [MeanShape(b,:).';1];
    C = [MeanShape(c,:).';1];
    K1{i} = [A B C];
end

K2 = cell(TriangleNum,2);
for i = 1:size(TM)
    tri = TM(i);
    if isnan(tri) == 0
        
        K2{tri,1} = K1{tri};
        [xi,yi] = ind2sub(size(I),i);
        K2{tri,2} = [K2{tri,2} [xi;yi;1]];

    end
end
K3 = cell(TriangleNum,2);
% K3{:,:} = [];
for i = 1:TriangleNum
    bary = inv(K2{i,1})*K2{i,2};
    K3{i,1} = CordInI(:,:,i)*bary;
    K3{i,2} = CordInJ(:,:,i)*bary;
end

IndI = zeros(sub2ind(size(M),size(M,1),size(M,2),size(M,3)),1);
IndJ = zeros(sub2ind(size(M),size(M,1),size(M,2),size(M,3)),1);

for i = 1:TriangleNum
    for j = 1:size(K2{i,2},2)
        map1 = K2{i,2};
        pos1 = map1(1:2,j);
        map2i = K3{i,1};
        map2j = K3{i,2};
        pos2i = map2i(1:2,j)/map2i(3,j)
        pos2j = map2j(1:2,j)/map2j(3,j)
        for k = 1:3
            index = sub2ind(size(M),round(pos1(1)),round(pos1(2)),k);
            %ceil(pos2i(1))
            %(pos2i(2))
            %k
            sub2ind(size(M),ceil(pos2i(1)),ceil(pos2i(2)),k);
            IndI(index) = sub2ind(size(M),ceil(pos2i(1)),ceil(pos2i(2)),k);
            IndJ(index) = sub2ind(size(M),ceil(pos2j(1)),ceil(pos2j(2)),k);
        end
    
    end
end
IndM = 1:sub2ind(size(M),size(M,1),size(M,2),size(M,3));
% YOUR CODE ENDS HERE



% cross-dissolve
M(IndM)=(1-dissolve_frac)* I(IndI)+ dissolve_frac * J(IndJ);



%figure(100);
%subplot(1,3,1);
%imshow(I);
%hold on;
%triplot(TRI,Ip(:,1),Ip(:,2))
%hold off;
%title('First')

%subplot(1,3,2);
%imshow(M);
%hold on;
%triplot(TRI,Jp(:,1),Jp(:,2))
%hold off
%title('Morphed')

%subplot(1,3,3);
%imshow(J);
%hold on;
%triplot(TRI,Jp(:,1),Jp(:,2))
%hold off
%title('Second')

end