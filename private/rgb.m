% Convenience function to convert colors copied from FlatUIColors.com into
% MATLAB-compatible format without any changes in calling file.

function colorOut = rgb(a, b, c)

colorOut = [a, b, c]/255;