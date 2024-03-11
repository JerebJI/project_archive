#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h> 

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image.h"
#include "stb_image_write.h"

#define COLOR_CHANNELS 1

#define S(dx,dy) ((cx+dx<0 || cy+dy<0 || cy+dx>=width || cy+dy>=height) ? 0 : h_imageIn[(cy+dy)*width+cx+dx])

int main(int argc, char *argv[]) {
    if (argc < 3)
    {
        printf("USAGE: sample input_image output_image\n");
        exit(EXIT_FAILURE);
    }
    
    char szImage_in_name[255];
    char szImage_out_name[255];

    snprintf(szImage_in_name, 255, "%s", argv[1]);
    snprintf(szImage_out_name, 255, "%s", argv[2]);

    // Load image from file and allocate space for the output image
    int width, height, cpp;
    unsigned char *h_imageIn = stbi_load(szImage_in_name, &width, &height, &cpp, COLOR_CHANNELS);
    cpp = COLOR_CHANNELS;

    if (h_imageIn == NULL)
    {
        printf("Error reading loading image %s!\n", szImage_in_name);
        exit(EXIT_FAILURE);
    }
    //printf("Loaded image %s of size %dx%d.\n", szImage_in_name, width, height);
    const size_t datasize = width * height * cpp * sizeof(unsigned char);
    unsigned char *h_imageOut = (unsigned char *)malloc(datasize);

    clock_t t;
    t = clock();
    for (int cx=0; cx<width; cx++){
        for (int cy=0; cy<height; cy++) {
            int gx = -S(-1,-1)-2*S(0,-1)-S(1,-1)+S(-1,1)+2*S(0,1)+S(1,1);
            int gy = S(-1,-1)+2*S(-1,0)+S(-1,1)-S(1,-1)-2*S(1,0)-S(1,1);
            int r = sqrt((float)(gx*gx + gy*gy));
            h_imageOut[cy*width+cx] = (char)(r<255 ? r : 255);
        }
    }
    t = clock() - t;
    printf("%f\n",((double)t)/CLOCKS_PER_SEC*1000);

    // Zapisemo izhodno sliko v datoteko
    char szImage_out_name_temp[255];
    strncpy(szImage_out_name_temp, szImage_out_name, 255);
    char *token = strtok(szImage_out_name_temp, ".");
    char *FileType = NULL;
    while (token != NULL)
    {
        FileType = token;
        token = strtok(NULL, ".");
    }

    if (!strcmp(FileType, "png"))
        stbi_write_png(szImage_out_name, width, height, cpp, h_imageOut, width * cpp);
    else if (!strcmp(FileType, "jpg"))
        stbi_write_jpg(szImage_out_name, width, height, cpp, h_imageOut, 100);
    else if (!strcmp(FileType, "bmp"))
        stbi_write_bmp(szImage_out_name, width, height, cpp, h_imageOut);
    else
        printf("Error: Unknown image format %s! Only png, bmp, or bmp supported.\n", FileType);

    // Sprostimo pomnilnik na gostitelju
    free(h_imageIn);
    free(h_imageOut);

    return 0;
}