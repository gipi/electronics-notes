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
        void warmup();
        void tick();
#ifdef _WISHBONE_
        void transmit(uint8_t);
#endif
    protected:
#ifdef _WISHBONE_
        uint32_t wb_transaction(uint32_t addr, uint32_t data, bool write);
#endif
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
    Verilated::traceEverOn(true);

    device->trace(mTrace, TRACING_LEVEL);
    mTrace->open(mTraceName.c_str());

    PLOG_INFO << " [+] start tracing into '" << mTraceName << "'";
}

/* this function simply starts the system in reset for a couple of cycle and
 * then starts it */
template<typename T>
void SysCon<T>::warmup() {
    device->reset = 0;
    device->clk = 0;

    size_t count = 0;
    while(count++ < 2) {
        tick();
    }

    device->reset = 1;

}

template<typename T>
void SysCon<T>::tickPeripherals() {
#ifdef _UART_
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
#endif
}

#define TICK_STEP 100
#define TICK_OFFSET_LOW -10
#define TICK_OFFSET_HIGH 50
/**
 * Execute a clock cycle.
 *
 * The idea here is that the caller set the values needed just before a rasing
 * edge of the clock
 *      _____
 *     |     |
 *     |     |
 * ____|     |_
 *
 * 
 */
template<typename T>
void SysCon<T>::tick() {
    assert(device->clk == 0); /* we are in a asserted clock but not raising edge */

    tickcount++;
    device->eval(); /* eval combinational logic */
    if (mTrace)
        mTrace->dump(tickcount * TICK_STEP + TICK_OFFSET_LOW); /* dump it */

    device->clk = 1; /* falling edge */
    device->eval();  /* evaluate sequential */
    if (mTrace)
        mTrace->dump(tickcount * TICK_STEP);

    device->clk = 0; /* raising edge */
    device->eval();
    if (mTrace) {
        mTrace->dump(tickcount * TICK_STEP + TICK_STEP / 2);
        mTrace->flush();
    }

    tickPeripherals();
}

#ifdef _WISHBONE_

template<typename T>
uint32_t SysCon<T>::wb_transaction(uint32_t addr, uint32_t data, bool write) {
    /* configure starting handshake */
    device->i_wb_addr = addr; /* TX_REG */
    device->i_wb_we = write;   /* writing */
    device->i_wb_cyc = 1;  /* start cycle */
    device->i_wb_stb = 1;  /* start phase */
    device->i_wb_data = data; /* data to TX */

    tick(); /* make the TX latch the data */

    assert(device->o_wb_ack == 1); /* the slave asserts o_wb_ack in response to i_wb_stb */
    device->i_wb_stb = 0; /* the master negates i_wb_stb in response to o_wb_ack */

    uint32_t result = device->o_wb_data;
    tick();

    assert(device->o_wb_ack == 0);
    device->i_wb_cyc = 0;

    return result;
}

template<typename T>
void SysCon<T>::transmit(uint8_t data) {
    wb_transaction(0, data, true);

    for (unsigned int count = 0; count < 20 ; count++) {
        tick();
    }
}
#endif
