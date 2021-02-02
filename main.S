#define __SFR_OFFSET 0
#define TOL 7
#include "avr/io.h"

.global cap
.global avg
.global detect

cap:
  cbi PORTB, PORTB0  
  sbi DDRB, DDB0
  ldi r19, 1 
  rcall sleep_ms
  cbi DDRB, DDB0      
  clr r24
  wait:
    sbic PINB, PINB0        
    rjmp fin
    inc r24
    brne wait
  fin:
    cbi PORTB, PORTB0       
    sbi DDRB, DDB0
  ret

sleep_ms: ;16Mhz F_CPU
  push r17
  push r18
  ldi r17, 0xff
  ldi r18, 0x10
  sl:  
    nop
    dec r17
    brne sl 
    clr r17
    dec r18
    brne sl
    dec r19
    brne sl
  pop r18
  pop r17
  ret

avg:
  cli
  push r16
  push r19
  push r28
  push r29
  ldi r16, 0x40 ;num loops
  ldi r29, 0x00
  ldi r28, 0x00
  readloop:
    rcall cap
    add r28, r24
    adc r29, r1
    ldi r19, 1
    rcall sleep_ms
    dec r16
    brne readloop
  movw r24, r28
  ;divide by 2^[r18]
  ldi r18, 5
  divide:
    asr r25
    ror r24
    dec r18
    brne divide
  pop r29
  pop r28
  pop r19
  pop r16
  sei
  ret