% Author : Parag Mali
%
% Write a function, which when given thegrayscale image, and a matrix of
% smoothing weights multiplies each pixel in a region of the image by the 
% associated weights, and outputs the weighted result.For example, a 3x3 
% block moving average would use the weights: 
%       1/9 1/9 1/9
%       1/9 1/9 1/9 
%       1/9 1/9 1/9
% Instead, for example, you want a function:
%     function im_resulting = weighted_blur_function( im_in, weights );
% which can handle any weights in a MxM matrix.For example, 
% try the following matrix of weights
%     weights = [ 1    4    6    4    1 ;
%                 4   16   24   16    4 ;
%                 6   24   36   24    6 ;
%                 4   16   24   16    4 ;
%                 1    4    6    4    1 ] / 256;
%     im_in  = imread('cameraman_with_fiducials.tif');
%     im_blurred = weighted_blur_function( im_in, weights );
%     

function blur_im = weighted_blur_function(im_in, weights)
    
    % get the size of weights
    size_of_weights = size(weights);
    n_surrounding_rows = size_of_weights(1);
    n_surrounding_cols = size_of_weights(2);
    
    % find the original size of input image
    original_size = size(im_in);
    
    % create storage space to store blurerd image
    blur_im = zeros(original_size);

    n_surrounding_pixels = floor(n_surrounding_rows / 2) + 1;
    
    % find block average of surrounding pixel values
    for row = n_surrounding_pixels : original_size(1) - n_surrounding_pixels
        for col = n_surrounding_pixels : original_size(2) - n_surrounding_pixels
            
            sum = 0.0;
            
            for surrounding_row = -(n_surrounding_pixels-1) : (n_surrounding_pixels-1)
                for surrounding_col = -(n_surrounding_pixels-1) : (n_surrounding_pixels-1)
                   
                    sum = sum + (im_in(row + surrounding_row, col + surrounding_col) * ... 
                                weights(n_surrounding_pixels + surrounding_row, ...
                                        n_surrounding_pixels + surrounding_col));   
                
                end
            end
            
            % store the computed value
            blur_im(row, col) = sum / (n_surrounding_rows * n_surrounding_cols);
        end
    end
    
    