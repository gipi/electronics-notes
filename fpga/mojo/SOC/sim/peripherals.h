/*
 * General code to handle with the "environment"
 */

/*
 * This is not completely the SYSCON from the wishbone specification,
 * since here i'm including also peripherals like UART.
 */
#include <iomanip>
#include <plog/Log.h> /* this for all the code that needs the PLOG_* stuff */
#include <string>
#include "verilated_vcd_c.h"

typedef enum {
    IDLE,
    TRANSMITTING
} tx_state_t;

extern size_t tx_counter;

extern tx_state_t tx_state;
extern unsigned char tx_data;


template<typename T>
class SysCon {
    public:
        T* device = new T;
        SysCon(std::string tracename) : mTraceName(tracename) { init(); };
        void tick();
        void transmit(uint8_t);
    private:
        VerilatedVcdC* mTrace = new VerilatedVcdC;
        std::string mTraceName;
        size_t tickcount = 0;

        void init();
        void tickPeripherals();
};

#define TRACING_LEVEL 99

template<typename T>
void SysCon<T>::init() {
    device->trace(mTrace, TRACING_LEVEL);
    mTrace->open(mTraceName.c_str());

    PLOG_INFO << " [+] start tracing into '" << mTraceName << "'";
}

template<typename T>
void SysCon<T>::tickPeripherals() {
    // if in reset state we have nothing to do
    if (!device->reset)
        return;

    switch (tx_state) {
        case IDLE:
            if (!device->o_uart_tx) {
                PLOG_DEBUG << " [+] tx starting communications";
                tx_counter = 0;
                tx_data = 0x00;
                tx_state = TRANSMITTING;
            }
            break;

        case TRANSMITTING:
            if (tx_counter < 8) {
                //PLOG_DEBUG << device->o_uart_tx;
                tx_data = tx_data | device->o_uart_tx << (tx_counter);
                tx_counter++;
            } else {
                std::stringstream ss;
                ss << "transmitted byte: '" << tx_data << "' (" << std::setfill('0') << std::setw(1) << std::hex << static_cast<int>(tx_data) << ")";
                PLOG_DEBUG << ss.str();
                tx_state = IDLE;
                tx_counter = 0;
            }
            break;
    }
}

template<typename T>
void SysCon<T>::tick() {
    tickcount++;
    device->eval();
    if (mTrace)
        mTrace->dump(tickcount*10 - 2);
    device->clk = 1;
    device->eval();
    if (mTrace)
        mTrace->dump(tickcount*10);
    device->clk = 0;
    device->eval();
    if (mTrace) {
        mTrace->dump(tickcount*10 + 5);
        mTrace->flush();
    }

    tickPeripherals();
}


template<typename T>
void SysCon<T>::transmit(uint8_t data) {
    /* configure starting handshake */
    device->i_wb_addr = 0; /* TX_REG */
    device->i_wb_we = 1;   /* writing */
    device->i_wb_cyc = 1;  /* start cycle */
    device->i_wb_stb = 1;  /* start phase */
    device->i_wb_data = data; /* data to TX */

    tick(); /* make the TX latch the data */

    assert(device->o_wb_ack == 1); /* the slave asserts o_wb_ack in response to i_wb_stb */
    device->i_wb_stb = 0; /* the master negates i_wb_stb in response to o_wb_ack */

    tick();

    device->i_wb_cyc = 0;

    for (unsigned int count = 0; count < 20 ; count++) {
        tick();
    }

    assert(device->o_wb_ack == 0);
}
