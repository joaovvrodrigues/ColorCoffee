#include <opencv2/opencv.hpp>
#include <chrono>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
#define IS_WIN32
#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#ifdef IS_WIN32
#include <windows.h>
#endif

#if defined(__GNUC__)
    // Attributes to prevent 'unused' function from being removed and to make it visible
    #define FUNCTION_ATTRIBUTE __attribute__((visibility("default"))) __attribute__((used))
#elif defined(_MSC_VER)
    // Marking a function for export
    #define FUNCTION_ATTRIBUTE __declspec(dllexport)
#endif

using namespace cv;
using namespace std;

long long int get_now() {
    return chrono::duration_cast<std::chrono::milliseconds>(
            chrono::system_clock::now().time_since_epoch()
    ).count();
}

void platform_log(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
#ifdef __ANDROID__
    __android_log_vprint(ANDROID_LOG_VERBOSE, "ndk", fmt, args);
#elif defined(IS_WIN32)
    char *buf = new char[4096];
    std::fill_n(buf, 4096, '\0');
    _vsprintf_p(buf, 4096, fmt, args);
    OutputDebugStringA(buf);
    delete[] buf;
#else
    vprintf(fmt, args);
#endif
    va_end(args);
}

// Avoiding name mangling
extern "C" {
    FUNCTION_ATTRIBUTE
    const char* version() {
        return CV_VERSION;
    }

    // FUNCTION_ATTRIBUTE
    // const vector<Mat>* getHSV(char* inputImagePath, char* outputImagePath) {
    //     Mat src  = imread(inputImagePath);

    //     // Mudando espaço de cor para HSV
    //     platform_log("Aplicando Equalização de Histograma");
    //     Mat hsv_image;
    //     cvtColor(src, hsv_image, COLOR_BGR2HSV);
        
    //     // Separando os canais H, S e V
    //     vector<Mat> vec_channels;
    //     split(hsv_image, vec_channels);

    //     return vec_channels;
    // }

    FUNCTION_ATTRIBUTE
    void process_image(char* inputImagePath, char* outputImagePath) {
        long long start = get_now();
        // Lendo imagem
        Mat src  = imread(inputImagePath);

        // Mudando espaço de cor para HSV
        platform_log("Aplicando Equalização de Histograma");
        Mat hsv_image;
        cvtColor(src, hsv_image, COLOR_BGR2HSV);
        
        // Separando os canais H, S e V
        vector<Mat> vec_channels;
        split(hsv_image, vec_channels);

        // Equalizando somente o canal V (Da intensidade o brilho)
        equalizeHist(vec_channels[2], vec_channels[2]);

        // Unindo os canais e voltando o canal RGB
        Mat dst;
        merge(vec_channels, dst); 
        cvtColor(dst, dst, COLOR_HSV2BGR);

        imwrite(outputImagePath, dst);
        
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Processamento finalizado em %dms\n", evalInMillis);
    }

    FUNCTION_ATTRIBUTE
    void process_image_with_clahe(char* inputImagePath, char* outputImagePath) {
        long long start = get_now();
        platform_log("Aplicando Median Blur");
        
        Mat src  = imread(inputImagePath);
        Mat dst;

        medianBlur(src, dst, 5);

        imwrite(outputImagePath, dst);

        platform_log("Aplicando CLAHE Gray");
        Mat gray_image;
        cvtColor(dst, gray_image, COLOR_BGR2GRAY);

        Ptr<CLAHE> clahe = createCLAHE();
        clahe->setClipLimit(4);
        clahe->setTilesGridSize(Size(8,8));
        Mat dst_clahe;
        clahe->apply(gray_image, dst_clahe);

        imwrite(outputImagePath, dst_clahe);
        
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Processamento finalizado em %dms\n", evalInMillis);
    }

    // Teste de função: medianBlur
    FUNCTION_ATTRIBUTE
    void process_median_blur(char* inputImagePath, char* outputImagePath) {
        long long start = get_now();
        
        Mat src  = imread(inputImagePath);
        Mat dst;

        medianBlur(src, dst, 5);

        imwrite(outputImagePath, dst);
        
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("MEDIAN BLUR (5) - Processamento finalizado em %dms\n", evalInMillis);
    }

    // Teste de função: Equalização de Histograma CLAHE com escala de cinza
    FUNCTION_ATTRIBUTE
    void process_gray_clahe(char* inputImagePath, char* outputImagePath) {
        long long start = get_now();
        
        Mat bgr_image  = imread(inputImagePath);

        Mat gray_image;
        cvtColor(bgr_image, gray_image, COLOR_BGR2GRAY);

        Ptr<CLAHE> clahe = createCLAHE();
        clahe->setClipLimit(4);
        clahe->setTilesGridSize(Size(8,8));
        Mat dst;
        clahe->apply(gray_image, dst);

        imwrite(outputImagePath, dst);
        
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("CLAHE - Processamento finalizado em %dms\n", evalInMillis);
    }

    // Teste de função: Equalização de Histograma CLAHE com RGB
    FUNCTION_ATTRIBUTE
    void process_color_clahe(char* inputImagePath, char* outputImagePath) {
        long long start = get_now();
        
        Mat bgr_image  = imread(inputImagePath);

        Mat lab_image;
        cvtColor(bgr_image, lab_image, COLOR_BGR2Lab);
        
        // Extract the L channel
        vector<Mat> lab_planes(3);
        split(lab_image, lab_planes);  // now we have the L image in lab_planes[0]

        // apply the CLAHE algorithm to the L channel
        Ptr<CLAHE> clahe = createCLAHE();
        clahe->setClipLimit(4);
        Mat dst;
        clahe->apply(lab_planes[0], dst);

        // Merge the the color planes back into an Lab image
        dst.copyTo(lab_planes[0]);
        merge(lab_planes, lab_image);

        // convert back to RGB
        Mat image_clahe;
        cvtColor(lab_image, image_clahe, COLOR_Lab2BGR);
        
        imwrite(outputImagePath, image_clahe);
        
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Processamento finalizado em %dms\n", evalInMillis);
    }

    // Teste de função: threshold
    FUNCTION_ATTRIBUTE
    void process_image_threshold(char* inputImagePath, char* outputImagePath) {
        long long start = get_now();
        
        Mat input = imread(inputImagePath, IMREAD_GRAYSCALE);
        Mat threshed, withContours;

        vector<vector<Point>> contours;
        vector<Vec4i> hierarchy;
        
        adaptiveThreshold(input, threshed, 255, ADAPTIVE_THRESH_GAUSSIAN_C, THRESH_BINARY_INV, 77, 6);
        findContours(threshed, contours, hierarchy, RETR_TREE, CHAIN_APPROX_TC89_L1);
        
        cvtColor(threshed, withContours, COLOR_GRAY2BGR);
        drawContours(withContours, contours, -1, Scalar(0, 255, 0), 4);
        
        imwrite(outputImagePath, withContours);
        
        int evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Processing done in %dms\n", evalInMillis);
    }
}
