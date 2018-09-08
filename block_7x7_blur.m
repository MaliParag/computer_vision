%
% Author : Parag Mali
%
% Create a function block_7x7_blur(im_in) that, given a grayscale image,
% computes and returns the 7x7 block average of the image. Ignore the edges.
% Actually implement the algorithm to step through each row and column,
% and manually implements the process of adding up a total, and dividing
% by 25.
% Run this on the provided image and display the results.
%

function block_7x7_blur(im_in)

    % read the image
    im_in = imread(im_in);
    
    % convert im_in to double format, it allows more precise math operations
    im_in = im2double(im_in);
      
    % create storage space to store blurerd image
    blur_im = zeros(size(im_in));

    % access surrounding 7x7 values for each pixel in original image
    % find the average and store it in new blurred image
    original_size = size(im_in);
    
    % find average of surrounding 7x7 pixel values
    for row = 4 : original_size(1) - 4
        for col = 4 : original_size(2) - 4
            sum = 0.0;
            for surrounding_row = -3 : 3
                for surrounding_col = -3 : 3
                   sum = sum + im_in(row + surrounding_row, col + surrounding_col);   
                end
            end
            
            % store the computed value
            blur_im(row, col) = sum / 49;
        end
    end
    
    % display the results in grayscale
    imshow(blur_im)
    
    
    