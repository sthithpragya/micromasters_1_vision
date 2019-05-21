function [ f, pos ] = compute_f_pos( d1_ref, d2_ref, H1, H2, ratio, f_ref )
% compute camera focal length and camera position to achieve centain ratio
% between objects
%
% Input:
% - d1_ref: distance of the first object
% - d2_ref: distance of the second object
% - H1: height of the first object in physical world
% - H2: height of the second object in physical world
% - ratio: ratio between two objects (h1/h2)
% - f_ref: 1 by 1 double, previous camera focal length
% Output:
% - f: 1 by 1, camera focal length
% - pos: 1 by 1, camera position

% Put your CODE here
h1 = f_ref*H1/d1_ref;
syms ff poss
eq1 = ff*H1-h1*d1_ref+h1*poss == 0;
eq2 = ff*H2-(h1/ratio)*d2_ref+(h1/ratio)*poss == 0;
eq = [eq1, eq2];
var = [ff, poss];
[fff, posss] = solve(eq, var);
f = fff;
pos = posss;

end