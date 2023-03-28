SRC = 	main.c\
		APP/smart_fan.c\
		MCAL/DIO/dio.c\
		MCAL/EXT_INT/External_INT.c\
		MCAL/TIMER/timer.c\
		MCAL/PWM/PWM.c\
		MCAL/ADC/ADC.c\
		HAL/LCD/LCD.c\
		HAL/L298_H_Bridge/L298_H_Bridge.c\
		HAL/LM35/LM35.c\


OBJ = $(subst .c,.o, $(SRC))

MCU = atmega32
FLASHER = usbasp
F_CPU = 16000000UL 

CFLAGS = -Og -ggdb -Wall -mmcu=$(MCU) -DF_CPU=$(F_CPU)

INCLUDE  = -I./utils
INCLUDE += -I./MCAL
INCLUDE += -I./HAL
# INCLUDE += -I/lib/avr/include

# LD_AVR = -L/lib/avr/lib/avr5 -latmega32a
# LD_AVR = 

all: compile build flash

compile:$(OBJ)
	
	@avr-gcc $(CFLAGS) $(INCLUDE) $(LD_AVR) $(OBJ)  -o ./bin/main.elf
%.o:%.c
	@echo "compiling $^"
	@avr-gcc $(CFLAGS) $(INCLUDE) $(LD_AVR) $^ -c  -o $@ 

build:
	@echo " building Hex file ... "

	@avr-objcopy  -j .text -j .data -O ihex ./bin/main.elf ./bin/main.hex

flash:build
	avrdude -c $(FLASHER) -p $(MCU)  -U flash:w:./bin/main.hex

clean:
	$(foreach file,$(OBJ),$(shell rm $(file)))


sim:
	simavr -g -m $(MCU) ./bin/main.elf
gdb:
	avr-gdb -x gdb-commands -tui 
