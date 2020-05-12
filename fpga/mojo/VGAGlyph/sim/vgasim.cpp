#include <fcntl.h>
#include <stdlib.h>
#include "VVGA.h"
#include "verilated.h"

#define LOG(...) fprintf(stderr, __VA_ARGS__)

bool needDump = false; /* when the vsync signal transition from low to high */
bool old_hsync = true; /* hsync is useless since it's not moved during the vsync */
bool old_vsync = true;

int main(int argc, char *argv[]) {
    LOG(" [+] starting VGA simulation\n");
    uint64_t tickcount = 0;

    VVGA* vga = new VVGA;

    vga->rst = 0;

    /* bad enough 24bits data type doesn't exist! */
    uint8_t image[801*526*3]; /* FIXME: should be 800*525 */
    memset(image, 'A', sizeof(image));

    uint32_t idx = 0;

    unsigned int count_image = 0;

    for ( ; count_image < 10; ) {
        if (tickcount > 10) {
            vga->rst = 1;
        }
        vga->clk = 0;
        vga->eval();

        vga->clk = 1;
        vga->eval();

        /* we need to dump when both vsync and hsync transition from low to high */
        needDump = (!old_vsync && vga->vsync_out);

        if (needDump) {
            char filename[64];
            snprintf(filename, 63, "frames/frame-%08d.bmp", count_image++);
            LOG(" [-> dumping frame %s at idx %d]\n", filename, idx);
            int fd = creat(filename, S_IRUSR | S_IWUSR);

            if (fd < 0) {
                perror("opening file for frame");
                break;
            }

            char header[] = "P6\n801 526\n255\n";

            write(fd, header, sizeof(header));
            write(fd, image, sizeof(image));

            close(fd);

            idx = 0;
        }

        image[idx++] = ((vga->pixel & 1) * 0xff);
        image[idx++] = ((vga->pixel & 2) >> 1) * 0xff;
        image[idx++] = ((vga->pixel & 4) >> 2) * 0xff;

        old_vsync = vga->vsync_out;
        old_hsync = vga->hsync_out;

        tickcount++;
        vga->clk = 0;
        vga->eval();

    }

    return EXIT_SUCCESS;
}
