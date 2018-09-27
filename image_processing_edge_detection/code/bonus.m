function bonus(fn_in)
    
    % Answer 4
    % This function is specially written to find edges using method
    % described in question 4 for CIELAB space
    
    % imread function reads the image from fn_in
    % im2double converts the image read using imread to double precision, 
    % rescaling the data if necessary
    im_in  = im2double( imread( fn_in ) );
    
    % Once we have double precision image, convert it to lab
    % find edge magnitudes of each channel
    % find max from each edge magnitudes obtained from different channels
    im_tmp          = rgb2lab( im_in );
    edge_mag1 = find_edge_magnitudes(im_tmp(:,:,1));
    edge_mag2 = find_edge_magnitudes(im_tmp(:,:,2));
    edge_mag3 = find_edge_magnitudes(im_tmp(:,:,3));
    
    edge_mag = max(max(edge_mag1, edge_mag2), edge_mag3);
    
    % Create another figure with given window 
    f2_posit    = [250 250 1024 1024];
    f2          = figure('Position', f2_posit );
    
    % Display the image of edge magnitudes
    % Set default colomap, add colorbar, set title, font size
    % for current figure
    imagesc( edge_mag );
    set(gca(), 'Position', [0.05 0.05 0.9 0.9]);
    axis image;
    colormap( 'default' );
    colorbar;
    ttl =  [ fn_in ' '];
    ttl( ttl == '_' ) = ' ';
    title( ttl , 'FontSize', 20 );
    
    set(f2, 'Position', f2_posit );

end

function edge_mag = find_edge_magnitudes(img)
    
    % Following is a Gaussian Kernel 
    % It is weighted by 16, so that overall brightness reamins constant  
    % after applying this filter.
    fltr            = [ 1 2 1 ;
                        2 4 2 ;
                        1 2 1 ] / 16;
    img             = imfilter( img, fltr, 'same', 'repl' );
    
    
    % This is a Sobel filter which finds gradient in the 
    % vertical direction. That means it detects edges in the 
    % horizontal direction
    fltr_vt    = [ 1  2  1 ; 
                   0  0  0 ;
                  -1 -2 -1 ]/8;
    
    % If we transpose above Sobel filter, we get another Sobel filter  
    % which finds gradient in horizontal direction. That means it can
    % find edges in the vertical direction
    fltr_hz    = fltr_vt.';

    % use the filters defined above to actually calculate horizontal 
    % and vertical edges. edges_a will contain horizontal edges and 
    % edges_2 will contain vertical edges
    edges_a            = imfilter( img, fltr_vt, 'same', 'repl' );
    edges_2            = imfilter( img, fltr_hz, 'same', 'repl' );
    
    % We find the magnitude of edge vector at each point using 
    % following computation. We only retain the positive root
    % of the magnitude
    edge_mag            = ( edges_a.^2 + edges_2.^2 ).^(1/2);
    
end

