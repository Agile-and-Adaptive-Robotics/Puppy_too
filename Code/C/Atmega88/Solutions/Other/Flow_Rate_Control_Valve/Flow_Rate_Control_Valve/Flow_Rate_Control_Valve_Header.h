//Slave Micro Testing Header File

//Include necessary .h files.
#include <stdio.h>
#include <avr/io.h>
#include <avr/interrupt.h>

//Define the clock speed.
#define F_CPU 16000000UL // 16 MHz CPU Clock Frequency
#include <util/delay.h>   // Include the built in Delay Function

//Define pin setting and clearing macros.
#define sbi(var, mask)   ((var) |= (uint8_t)(1 << mask))
#define cbi(var, mask)   ((var) &= (uint8_t)~(1 << mask))

//Define SPIF value (used for SPI communication).
#define SPIF 7

//Define USART Parameters.
#define FOSC F_CPU					//CPU Clock Frequency must be set correctly for the USART to work
//#define BAUD 9600					//BAUD Rate.  Maximum appears to be 921600.
#define BAUD 57600					//BAUD Rate.  Maximum appears to be 921600.
#define MYUBRR FOSC/16/BAUD-1

//Define Robot Parameters.
#define NUM_TOTAL_MUSCLES 24
#define NUM_FRONT_LEG_MUSCLES 6
#define NUM_MULTIPLEXER_PINS 3
#define NUM_PRESSURE_SENSORS 24
#define NUM_POTENTIOMETERS 14
#define NUM_SENSORS_TOTAL 38

//Define Conversion Parameters.
#define NUM_BYTES_PER_FLOAT 4
#define NUM_BYTES_PER_UINT16 2

//Define the necessary structures.
struct int_struct
{
	unsigned int * array;
	unsigned char length;
};

struct float_struct
{
	float * array;
	unsigned char length;
};

struct single_array_struct
{
	unsigned char IDs[38];				//This assumes that there will be <255 muscles, or the ID variable will overflow.
	float values[38];
	unsigned char length;				//This assumes that there will be <255 muscles, or the length variable will overflow.
};

struct int_array_struct
{
	unsigned char IDs[38];				//This assumes that there will be <255 muscles, or the ID variable will overflow.
	uint16_t values[38];			//This assumes that the muscle activation value will be in the range [0, 65535].
	unsigned char length;				//This assumes that there will be <255 muscles, or the length variable will overflow.
};

struct muscle_info_struct 
{
	unsigned char ID;
	unsigned char * port;
	unsigned char pin;
};

struct slave_info_struct
{
	uint8_t muscle_ID;
	uint8_t slave_num;
};


//Type Conversion Functions.
int * int2lowhighbytes(int myint);
unsigned int lowhighbytes2int(unsigned int low_byte, unsigned int high_byte);
uint16_t byte_array2int(unsigned char byte_array[]);
float byte_array2float(unsigned char byte_array[]);
void int2byte_array(uint16_t my_int, unsigned char byte_array[]);
void float2byte_array(float my_float, unsigned char byte_array[]);
float muscle_int2muscle_volt(unsigned int muscle_int);
unsigned int sensor_volt2sensor_int(unsigned int sensor_volt);
uint16_t ADC2uint16( unsigned int ADC_value );
char get_char_bits(char mychar, char no_of_bits);

//Low Level UART Functions.
void uart_putchar(char c, FILE *stream);
unsigned char uart_getchar(void);

//Low Level SPI Functions.
void spi_write(unsigned char spi_data);
unsigned char spi_read( void );
unsigned char spi_read_write(unsigned char spi_data);

//High Level SPI Functions.
void write2slave( uint16_t value_to_write, uint8_t slave_num );
void WriteCommandData2Slaves( struct int_array_struct * command_data_ptr );

//Low Level Pin State Setting Function.
void set_pin_state( unsigned char * port_num, unsigned char pin_num, unsigned char pin_state);

//High Level Serial Write Functions.
void serial_write_start_bytes( void );
void serial_write_end_bytes( void );
void serial_write_string2matlab(char mystring[]);
void serial_write_int2matlab( int myint );
void serial_write_int_array2matlab( int myint_array[], int array_length );
void serial_write_single_array2matlab( float myfloat_array[], int array_length );
void serial_write_sensor_data_ints2matlab( struct int_array_struct * sensor_data_ptr );
void serial_write_sensor_data_singles2matlab( struct single_array_struct * sensor_data_ptr );

//High Level Serial Read Functions.
void wait_for_start_sequence( void );
unsigned int serial_read_matlab_int( void );
struct int_struct serial_read_matlab_int_array( void );
struct float_struct serial_read_matlab_single_array( void );
void serial_read_matlab_muscle_command_ints( struct int_array_struct * command_data_ptr );
void serial_read_matlab_muscle_command_singles( struct single_array_struct * single_array_struct_ptr );

//Setup Functions.
void SetupTimerInterrupts( void );
void SetupUSART( void );
void SetupSPI( void );
void SetupADC( void );
void SetupPins( void );
void SetupMicro( void );

//ADC-DAC Functions.
uint16_t ADC2DAC(uint16_t adc_value);
void write2DAC(unsigned int value_to_write);																						//Medium Level DAC Writing Function.
unsigned int readADC( unsigned int channel_num );																					//Medium Level ADC Reading Function.
void set_multiplexer_channel_with_pins( unsigned char * port_num, unsigned char * pin_nums, unsigned char channel_num );			//Medium Level Multiplexer Channel Setting Function.
void set_multiplexer_channel( unsigned char channel_num );																			//High Level Multiplexer Channel Setting Function.
void GetSensorData( struct int_array_struct * sensor_data_ptr );
unsigned char GetMuscleInfoIndex( unsigned char muscle_ID );
uint8_t GetMuscleIndex( uint8_t muscle_ID_target );
void UpdateMuscleOnOffStates( struct int_array_struct * command_data_ptr);
void UseDACAsMusclePin(struct int_array_struct * command_data_ptr);

//Define the the standard output.
static FILE mystdout = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);

//Declare global constants.
extern const uint16_t dac_on_value;						//[#] Value to which the dac should be set when the valve manifold is turned on.
extern const uint16_t dac_off_value;
extern const uint8_t window_size;
extern const uint8_t multiplexer_pins1[NUM_MULTIPLEXER_PINS];
extern const uint8_t multiplexer_pins2[NUM_MULTIPLEXER_PINS];
extern const uint8_t * multiplexer_port;
extern const struct muscle_info_struct muscle_info[NUM_FRONT_LEG_MUSCLES];
//extern const struct slave_info_struct slave_info[NUM_FRONT_LEG_MUSCLES];
extern const struct slave_info_struct slave_info[NUM_TOTAL_MUSCLES];

extern const uint16_t activation_threshold;

//Declare global variables.
extern unsigned int dac_data;									//[#] Value to send to dac.
extern unsigned int count;										//[#] Counter for the number of interrupt cycles.
extern unsigned char clock_pin_state;							//[T/F] Clock Pin State.
