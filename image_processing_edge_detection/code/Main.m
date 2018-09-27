function Main( )
    
    addpath( '../TEST_IMAGES' );
    addpath( '../../TEST_IMAGES' );
    %
    % Here is a driving routine that runs the function on a bunch of images:
    %

    % I put all of my images into one directory:
    IMAGE_DIR='IMAGES_FOR_HW';

    % This con-catentates the IMAGE DIR STRING, to form a pattern to match:
    file_pattern    = [ IMAGE_DIR '/' '*.jpg' ]; 
    file_name_list = dir( file_pattern );

    for file_index = 1:length( file_name_list )

        file_name = file_name_list(file_index).name;
        full_name = [ IMAGE_DIR '/' file_name ];
        
        find_edges( full_name );
        
        % Wait for a few seconds:
        pause( 4 );

    end
    
end

