function resizeFig(figHand, newSize)
% Set size of figure.  Keeps figure center position in the same place

currPost = get(figHand, 'position');
currCenter = [currPost(1) + floor(currPost(3)/2), currPost(2) + floor(currPost(4)/2)];
newPost = [currCenter(1) - floor(newSize(1)/2), currCenter(2) - floor(newSize(2)/2)];

set(figHand, 'position', [newPost, newSize]);
