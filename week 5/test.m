a = [1 2 3 4 5];
b = [1 2 3 4 5;
    6 7 8 9 10;
    11 12 13 14 15;
    4 4 4 4 4];

[idx,d] = knnsearch(b,a,'K',2)