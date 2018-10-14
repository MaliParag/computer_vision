function contrast_enhancement_methods(im_path)
    
    % read input image
    im_gry = im2double(imread(im_path));
    
    if (ndims(im_gry) == 3)
        % select green channel
        im_gry = im_gry(:,:,2);
    end
    
    imwrite(im_gry, 'gray.jpg');
    
    % log. It enhanced dark areas in the image
    im_log(im_gry)
    
    % gamma correction
    im_gamma(im_gry)
    
    % exponentiation
    im_exp(im_gry);
    
    % square root
    im_pow(im_gry, 0.5);
    
    % cube root
    im_pow(im_gry, (1/3));
    
    % square
    im_pow(im_gry, 2);    
    
    % cube
    im_pow(im_gry, 3);    
    
    % histogram equilization
    hist_eq(im_gry);
    
    % im adjust
    im_adjust(im_gry);
    
    % dynamic ranging
    im_dynamic_range(im_gry);
    
    % hist stretching
    im_hist_stretch(im_gry);
    
    % hist match. Can not do histogram matching without reference image
    % im_hist_match( im_gry, im_gry );
    
end

function im_dynamic_range(im_gry)
    
    % hype-parameter
    alpha = 0.5;
    im_new = (1+alpha).^im_gry - 1;
    display(im_new, 'Modified by using dynamic ranging');

end

function im_hist_stretch(im_gry)
    
    % Using stetchlim function for implementing histogram stetch
    im_new = imadjust(im_gry, stretchlim(im_gry), []);
    display(im_new, 'Modified by using histogram stretching');

end

function im_gamma(im_gry)
    im_new = imadjust(im_gry,[],[],0.5);
    display(im_new, 'Modified by using gamma correction');
end


function im_exp(im_gry)
    
    % exp^(each value)
    im_new = exp(im_gry);
    im_new = mat2gray(im_new);
    display(im_new, 'Modified by taking exp of EACH VALUE');

end


function im_log(im_gry)
    
    % Take the log of it by adding 1, to avoid taking log of zero.
    im_new = log(im_gry + 1);
    
    % Normalize to the range 0-1.
    im_new = mat2gray(im_new);
    
    display(im_new, 'Modified by taking log of EACH VALUE');

end

function display(im_new, im_title) 
    
    % diplay the image
    figure('Position',[200 10 1024 800]);
    imshow( im_new );
    colormap(gray);
    axis on;
    title(im_title);
    pause(2);
    
end

function im_pow(im_gry, ex)
    
    % pow transform
    im_new = im_gry.^(ex);
    str = strcat('Modified by taking (EACH VALUE)^{', num2str(ex),'}');
    display(im_new, str);

end

function hist_eq(im_gry)
    
    % histogram equalization
    im_new = histeq( im_gry );
    display(im_new, 'Modified by using histeq');
end

function im_adjust(im_gry)
    
    % imagjust
    im_new = imadjust( im_gry );
    display(im_new, 'Modified by using imadjust');
end 

function im_hist_match(im_gry)
    
    % histogram matching
    im_new = imhistmatch( im_in_gry, im_ref_gry );
    display(im_new, 'Modified Using Histogram Matching');
end