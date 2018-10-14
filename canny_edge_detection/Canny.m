%Author : Parag Mali

classdef Canny
    % This class implements canny edge detection algorithm 
    
    methods
        function edge_map = canny_edges(self, im_in, threshold1, ...
                                        threshold2, ...
                                        sigma_for_gaussian_filter)
            
            % This function implements main algorithm
            % It has few helper functions for specific steps in the 
            % algorithm
            
            % ---
            % 1. Smooth the image using Gaussian kernel
            % ---
            
            gauss_fltr = ...
                fspecial('gaussian', [7 7], sigma_for_gaussian_filter);
            im_gauss_filtered = ...
                imfilter(im_in, gauss_fltr, 'same', 'repl'); 
            
            % ---
            % 2. Find the edge strength
            % ---
            
            % Define sobel filters
            sobel_dx_fltr = [  -1  0  1 ; 
                               -2  0  2 ;
                               -1  0  1 ] / 8;
                      
            sobel_dy_fltr = sobel_dx_fltr.';
            
            % Apply Sobel filter in horizontal direction 
            dIdx = imfilter(im_gauss_filtered, sobel_dx_fltr,...
                            'same', 'repl');
                        
            % Apply Sobel filter in vertical direction
            dIdy = imfilter(im_gauss_filtered, sobel_dy_fltr,...
                            'same', 'repl');
            
            % Find edge magnitude
            im_mag = ( dIdx.^2 + dIdy.^2 ) .^ (1/2);
            
            % ---
            % 3. Compute edge direction
            % ---
            angles = atan2( dIdy, dIdx ) * 180 / pi;
            
            angles = self.fix_angles(angles);
            
            %---
            %4. Digitize the edge direction (to nearest 0, 45, 90, or 
            %   135 degree)
            %---
            updated_angles = self.digitize_edge_direction(angles);
            
            %---
            %5. Nonmaximal supression
            %---
            
            im_supressed = self.non_maximal_supression(updated_angles, im_mag);
            
            %---
            %6. Hysteresis
            %---
          
            im_supressed = im_supressed.*im_mag;

            %threshold1 = threshold1 * max(max(im_supressed));
            %threshold2 = threshold2 * max(max(im_supressed));
            
            edge_map = self.hysteresis(im_supressed, threshold1, threshold2);
            
            edge_map = uint8(edge_map.*255);
            
            % display the result
            imshow(edge_map);
        end
        
        function im_in = fix_angles(self, im_in)
            % As our co-ordinate system starts at top-left, we need to 
            % change the directions found in last step
            
            bool_negative_angle = im_in < 0;
            im_in( bool_negative_angle ) =  im_in( bool_negative_angle ) + 180;
            im_in( im_in == 180 ) = 0;
            
        end
        
        function updated_angles = digitize_edge_direction(self, angles)
            
            % This functions converts angles to 0, 45, 135, 180, whichever
            % angle is closest to current value
           
            im_size = size(angles);
            
            n_rows = im_size(1);
            n_cols = im_size(2);
            
            % initialize matrix
            updated_angles = zeros(n_rows, n_cols);
            
            for i = 1  : n_rows
                for j = 1 : n_cols
                    if((angles(i, j) >= 0 ) && (angles(i, j) < 22.5))
                        updated_angles(i, j) = 0;
                    elseif((angles(i, j) >= 22.5 ) && (angles(i, j) < 67.5))
                        updated_angles(i, j) = 45;
                    elseif((angles(i, j) >= 67.5 ) && (angles(i, j) < 112.5))
                        updated_angles(i, j) = 90;
                    elseif((angles(i, j) >= 112.5 ) && (angles(i, j) < 180))
                        updated_angles(i, j) = 135;
                    end
                end
            end
        end
        
        function im_supressed = non_maximal_supression(self, updated_angles, im_mag)
            
            % Perform non maximal supression
            
            im_size = size(im_mag);
            
            n_rows = im_size(1);
            n_cols = im_size(2);
            
            % intialize matrix
            im_supressed = zeros(n_rows, n_cols);

            for i = 2:n_rows-1
                for j = 2:n_cols -1
                    
                    if (updated_angles(i,j) == 0)
                        im_supressed(i,j) = ...
                            (im_mag(i,j) == max([im_mag(i,j), im_mag(i,j+1), im_mag(i,j-1)]));
                    
                    elseif (updated_angles(i,j) == 45)
                        im_supressed(i,j) = ...
                            (im_mag(i,j) == max([im_mag(i,j), im_mag(i+1,j-1), im_mag(i-1,j+1)]));
                    
                    elseif (updated_angles(i,j) == 90)
                        im_supressed(i,j) = ...
                            (im_mag(i,j) == max([im_mag(i,j), im_mag(i+1,j), im_mag(i-1,j)]));
                    
                    elseif (updated_angles(i,j) == 135)
                        im_supressed(i,j) = ...
                            (im_mag(i,j) == max([im_mag(i,j), im_mag(i+1,j+1), im_mag(i-1,j-1)]));
                   
                    end
                end
            end
        end
        
        function im_edges = hysteresis(self, im_supressed, threshold1, threshold2)
            
            % do hysteresis analysis. Use threshold values to decide
            % final prominent edges
            
            im_size = size(im_supressed);
            
            n_rows = im_size(1);
            n_cols = im_size(2);
            
            im_edges = zeros(n_rows, n_cols);

            for i = 1  : n_rows
                for j = 1 : n_cols
                    if (im_supressed(i, j) < threshold1)
                        im_edges(i, j) = 0;
                    elseif (im_supressed(i, j) > threshold2)
                        im_edges(i, j) = 1;
                    elseif (im_supressed(i+1,j)>threshold2 || ...
                            im_supressed(i-1,j)>threshold2 || ...
                            im_supressed(i,j+1)>threshold2 || ...
                            im_supressed(i,j-1)>threshold2 || ...
                            im_supressed(i-1, j-1)>threshold2 || ...
                            im_supressed(i-1, j+1)>threshold2 || ...
                            im_supressed(i+1, j+1)>threshold2 || ...
                            im_supressed(i+1, j-1)>threshold2)
                        im_edges(i,j) = 1;
                    end
                end
            end
        end
            
    end
end

