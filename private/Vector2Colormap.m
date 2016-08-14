%Vector2Colormap returns an M-by-N-by-3 matrix of colormap values corresponding
%to values in M-by-N-by-1 input_vector.  
%Call as map = Vector2Colormap(input_vector, input_map), where
%input_vector is vector data and input_map is string corresponding to
%desired colormap.  This allows for multiple colormaps to be used in a
%single figure by expressing each as a M-by-N-by-3 matrix in the desired
%colormap.

% Resets colormap back to map at time function is called.

function map = Vector2Colormap(input_vector, input_map, varargin)
original_map = colormap;


if size(varargin) == 0;
    
%     input_vector = varargin{1};
%     input_map = varargin{2};
    
    N_steps = 64;
    
else

% 	input_vector = varargin{1};
%     input_map = varargin{2};
    
    N_steps = varargin{1};
    

end

cm = feval(input_map, N_steps);

%%%%% Find which bins each data bit goes into.

% Normalize input_vector from 1 to N_steps, in integer values only

scaled = round((N_steps-1)*((input_vector - min(input_vector(:)))/(max(input_vector(:)) - min(input_vector(:))))) + 1;

% scaled_vector = (num_steps/(1.0001*max(input_vector(:)) - min(input_vector(:))))*input_vector;
% 
% scaled_vector = scaled_vector - min(scaled_vector(:)) + 1;
% 
% red = interp1(1:(num_steps+1), cm(:,1), scaled_vector);
% green = interp1(1:(num_steps+1), cm(:,2), scaled_vector);
% blue = interp1(1:(num_steps+1), cm(:,3), scaled_vector);



if isvector(input_vector) == 1;
    
    map = [cm(scaled,1) cm(scaled,2) cm(scaled,3)];
    
else 
    
    map = zeros(size(input_vector, 1), size(input_vector, 2), 3);
    
    map(:,:, 1) = reshape(cm(scaled,1), size(input_vector, 1), []);
    map(:,:, 2) = reshape(cm(scaled,2), size(input_vector, 1), []);
    map(:,:, 3) = reshape(cm(scaled,3), size(input_vector, 1), []);
    
    %map = reshape(map, size(input_vector, 1), size(input_vector,2), 3);
    
end
colormap(original_map);
    
    