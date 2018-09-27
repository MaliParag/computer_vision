function find_edges( fn_in )
MARGIN          = 20;
CUTOFF_PERCENT  = 0.98;

    % imread function reads the image from fn_in
    % im2double converts the image read using imread to double precision, 
    % rescaling the data if necessary
    im_in  = im2double( imread( fn_in ) );
    
    % Once we have double precision image, convert it to grayscale
    % If image is grayscale already, no need to convert
    % otherwise, access the gray channel and store it in im_gray
    if ( length( size( im_in) ) ~= 3 )
         % As numbers of channels are not 3, that means image is 
         % already grayscale
        im_gray = im_in;
    else
        % Change input image from RGB colorspace to YCbCr colorspace
        % Access Y channel and assign it to im_gray
        im_tmp          = rgb2ycbcr( im_in );   % change colorspace
        im_gray         = im_tmp(:,:,1);        % store grayscale channel in im_gray  
        clear im_tmp;
    end

    % Following is a Gaussian Kernel 
    % It is weighted by 16, so that overall brightness reamins constant  
    % after applying this filter.
    fltr            = [ 1 2 1 ;
                        2 4 2 ;
                        1 2 1 ] / 16;
    im_gray         = imfilter( im_gray, fltr, 'same', 'repl' );
    
    
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
    edges_a            = imfilter( im_gray, fltr_vt, 'same', 'repl' );
    edges_2            = imfilter( im_gray, fltr_hz, 'same', 'repl' );
    
    % We find the magnitude of edge vector at each point using 
    % following computation. We only retain the positive root
    % of the magnitude
    edge_mag            = ( edges_a.^2 + edges_2.^2 ).^(1/2);
    
    % All the boundary values of the eddges within MARGIN  
    % are set to 0
    % All the four margins will have value 0
    edge_mag( 1:MARGIN,         : )                = 0;
    edge_mag( end-MARGIN-1:end, : )                = 0;
    edge_mag( :,                1:MARGIN )         = 0;
    edge_mag( :,                end-MARGIN-1:end ) = 0;
    
    % Find number of pixels in the im_gray and store the value in
    % n_pixels
    n_pixels            = numel( im_gray );
    
    % Find the maximum edge maginitude and store it in edge_mmax
    %
    %
    edge_mmax           = max( edge_mag(:) );
    
    
    % Find the size of bin increment. Divide the edge_mmax by 256 
    % to find size of each bin
    edge_bin_inc        = edge_mmax / 256; 
    
    
    % Find label for each bucket of histogram. Here we are labelling  
    % from 0 to edge_mmax with increment of edge_bin_inc found in last
    % step
    bin_edges           = 0 : edge_bin_inc : edge_mmax; 

    % From edge_mag(:) we put each edge magnitude in the correct bin
    % depending on the value. After doing this for all edges, we will have
    % histogram of edge magnitudes 
    [bin_counts, ~]     = histcounts( edge_mag(:), bin_edges );
    
    % Once we have histogram of edge magnitudes, we can find the cumulative
    % sum of bin counts using 'cumsum' function. The result is stored in 
    % the bin_cumulatives
    bin_cumulatives     = cumsum( bin_counts );
    
    % Find the 95% of n_pixels and store it in ninty_five_pc_count
    %
    %
    ninty_five_pc_count = CUTOFF_PERCENT * n_pixels;
    
    % The following 'find' function find 1st non-zero index   
    % store it in stop_ind. stop_ind will have index when cumulative sum
    % of frequencies becomes greater than 95% of number of pixels
    stop_ind            = find( bin_cumulatives > ninty_five_pc_count, 1, 'first' );
    
    % Use stop_ind defined in the last function
    % to find value in bin_edges and store it in
    % over_ninty_five_val
    over_ninty_five_val = bin_edges( stop_ind );

    % If edge magnitude is less than or equal to over_ninty_five_val
    % set it to 0
    %
    edge_mag( edge_mag <= over_ninty_five_val ) = 0;
    
    % Create a figure 
    figure('Position', [40 40 1024 768] );
    stem( bin_edges(1:end-1), bin_counts, 'MarkerFaceColor', 'b');
    set(gca(), 'Position', [0.05 0.05 0.9 0.9]);
    
    
    % Set axis limits, y axis has automatic sized ticks 
    % x axis has ticks of size 0.10
    new_axis        = axis();
    new_axis(1)     = 0;
    new_axis(2)     = 0.10;
    axis( new_axis );
    
    % Retain current plot as we add new plots. It is necessary as we are 
    % plotting more than one plot
    hold on;
    
    % 
    % This line is plotting a vertical magenta line at x co-ordinate  
    % over_ninty_five_val+edge_bin_inc/2 and y co-ordinate from 0 to
    % 400000. In the x co-ordinate edge_bin_inc/2 is added so that the line
    % is exactly at the center of the bin.
    %
    % Magenta Line: 
    % When cumultative histogram count (calculated above) reaches to 95% of 
    % total pixel count, that bin index is used to get the edge 
    % value from bin_edges and magenta line is drawn at that value.
    
    plot( [1 1]*(over_ninty_five_val+edge_bin_inc/2), [0 new_axis(4)], 'm-', 'LineWidth', 1.5 );

    
    % Create another figure with given window 
    % 
    % 
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


