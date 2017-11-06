function [X, Y] = tracedroite(w, h, wr, hr, x, y)

t = [-hr:hr];


a = (x/double(wr))*pi;

cs = cos(a);
sn = sin(a);

d = y-hr/2;

X = w/2 + cs*d - sn*t;
Y = h/2 - sn*d - cs*t;

