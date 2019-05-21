% ream images
II = imread('a.png');
I = im2double(imread('a.png'));
J = im2double(imread('c.png'));

% load mat file with points, variables Ip,Jp
load('points.mat');
 
% initialize ouput image (morphed)
M = zeros(size(I));
MeanShape = (1/2)*Ip+(1/2)*Jp;
TRI = delaunay(MeanShape(:,1),MeanShape(:,2));
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

Mp = (1-0.5)*Ip+0.5*Jp; 

% create a grid for the morphed image
[x,y] = meshgrid(1:size(M,2),1:size(M,1));

% for each element of the grid of the morphed image, find  which triangle it falls in
TM = tsearchn([Mp(:,1) Mp(:,2)],TRI,[x(:) y(:)]);


K1 = zeros(3,3,TriangleNum); %contains the data on indices of triangle which houses each pixel in M
for i = 1:TriangleNum
    a = TRI(i,1);
    b = TRI(i,2);
    c = TRI(i,3);
    A = [MeanShape(a,:).';1];
    B = [MeanShape(b,:).';1];
    C = [MeanShape(c,:).';1];
    K1(:,:,i) = [A B C];
end

for i = 1:TriangleNum
C = CordInI(:,:,i)
K = K1(:,:,i) 
end