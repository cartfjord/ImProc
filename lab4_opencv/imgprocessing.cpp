#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <stdlib.h>
#include <iostream>
#include <stdio.h>
#include <string>

using namespace std;
using namespace cv;

/// Global variables

Mat src, src_gray;
Mat dst, detected_edges;

char* window_name0 = "Original Image";
char* window_name1 = "Grayscale Image";
char* window_name2 = "Image After Histogram Equalization";
char* remap_window1 = "Remap - upside down";
char* remap_window2 = "Remap - reflection in the x direction";
char* window_name4 = "Median Filtered Image";
char* window_name5 = "Gaussian Filtered Image";

int ddepth = CV_16S;
int scale = 1;
int delta = 0;
int kernel_size = 3;
char* window_name6 = "Laplace Demo";

char* window_name7 = "Sobel Demo - Simple Edge Detector";

/// Global Variables
int MAX_KERNEL_LENGTH = 6;

void im2file(const char* filename, Mat image){
	char with_file_extension[50];
	strcpy(with_file_extension,filename);
	strcat(with_file_extension,".jpg");
	imwrite(with_file_extension, image );
}

/** @function main */
int main( int argc, char** argv )
{

    if( argc != 2)
    {
     cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
     return -1;
    }

	// Call the appropriate function in OPENCV to load the image
	src = imread( argv[1] );
	if( !src.data )
	{ return -1; }

	// Create a window called "Original Image" and show original image
	imshow(window_name0, src);
	im2file(window_name0,src);
	// Call the appropriate function in OPENCV to convert the image to grayscale
	cvtColor(src ,src_gray, COLOR_BGR2GRAY);

	// Create a window called "Grayscale Image" and show grayscale image
	imshow(window_name1, src_gray);
	im2file(window_name1,src_gray);
	// Apply histogram equalization to the grayscale image
	equalizeHist(src_gray, src_gray);
	
	// Create a window called "Image After Histogram Equalization" and show the image after histogram equalization
	imshow(window_name2, src_gray);
	im2file(window_name2,src_gray);
	// Apply remapping; first turn the image upside down and then reflect the image in the x direction

	// For this part, the upside down image and the flipped left image are created as the Mat variables "image_upsidedown" and "image_flippedleft".
	//Also, map_x and map_y are created with the same size as equalized_image:
		Mat image_upsidedown = Mat::zeros( src.rows, src.cols, src.type() );
		Mat image_flippedleft = Mat::zeros( src.rows, src.cols, src.type() );
		Mat map_x = Mat::zeros( src.rows, src.cols, src.type() ); //These are unused.
		Mat map_y = Mat::zeros( src.rows, src.cols, src.type() ); //These are unused.

	// Apply upside down operation to the image for which histogram equalization is applied.
	flip(src_gray, image_upsidedown, 0);

	// Create a window called "Remap - upside down" and show the image after applying remapping - upside down
	imshow(remap_window1, image_upsidedown);
	im2file(remap_window1, image_upsidedown);
	// Apply reflection in the x direction operation to the image for which histogram equalization is applied.
	flip(src_gray, image_flippedleft, 1);
	
	// Create a window called "Remap - reflection in the x direction" and show the image after applying remapping - reflection in the x direction
	imshow(remap_window2, image_flippedleft);
	im2file(remap_window2, image_flippedleft);
   
	// Apply Median Filter to the Image for which histogram equalization is applied 
	medianBlur(src_gray, dst, 7);

	// Create a window called "Median Filtered Image" and show the image after applying median filtering
	imshow(window_name4, dst);
	im2file(window_name4, dst);
    // Remove noise from the image for which histogram equalization is applied by blurring with a Gaussian filter
	GaussianBlur(src_gray, src_gray, Size(kernel_size, kernel_size), 0, 0);

	// Create a window called "Gaussian Filtered Image" and show the image after applying Gaussian filtering
	imshow(window_name5, src_gray);
	im2file(window_name5, src_gray);
	/// Apply Laplace function to compute the edge image using the Laplace Operator
	
	Laplacian(src_gray, dst, ddepth, kernel_size, scale, delta, BORDER_DEFAULT);
	convertScaleAbs(dst,dst);
    /// Create window called "Laplace Demo" and show the edge image after applying Laplace Operator
	imshow(window_name6, dst);
	im2file(window_name6, dst);
	// Apply Sobel Edge Detection
	/// Appropriate variables grad, grad_x and grad_y, abs_grad_x and abs_grad_y are generated
	Mat grad;
	Mat grad_x, grad_y;
	Mat abs_grad_x, abs_grad_y;

	/// Compute Gradient X
	Sobel( src_gray, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT );
	convertScaleAbs( grad_x, abs_grad_x );  

	/// Compute Gradient Y
	Sobel( src_gray, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT );
	convertScaleAbs( grad_y, abs_grad_y );

	/// Compute Total Gradient (approximate)
	addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );
	
	/// Create window called "Sobel Demo - Simple Edge Detector" and show Sobel edge detected image
	imshow(window_name7, grad);
	im2file(window_name7, grad);
  /// Wait until user exit program by pressing a key
  waitKey(0);

  return 0;
  }