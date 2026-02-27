#include "serial_tank.h"
#include "Arduino.h"
#include "main.h"

unsigned int volume_value;
unsigned char valueh, valuel;

void init_serial_tank(void) {
  Serial.begin(19200);
  Serial.write(0xFF); // sincroniza comunicação
  Serial.write(0xFF);
  Serial.write(0xFF);
}

unsigned int volume(void) {
  // Clear any garbage in the buffer before requesting new data
  while (Serial.available()) {
    Serial.read();
  }

  // Sending command to request the volume of water
  Serial.write(0xFF);
  Serial.write(VOLUME);

  // Wait for up to 100 milliseconds for a response
  unsigned long timeout = millis();
  while (Serial.available() < 2) {
    if (millis() - timeout > 100) {
      // Timeout reached, return the LAST KNOWN volume instead of getting stuck
      return volume_value;
    }
  }

  valueh = Serial.read();
  valuel = Serial.read();
  volume_value = (valueh << 8) | valuel;

  return volume_value;
}
void enable_inlet(void) {
  Serial.write(0xFF); // Sync header
  Serial.write(INLET_VALVE);
  Serial.write(ENABLE);
  delay(10);
}
void disable_inlet(void) {
  Serial.write(0xFF);
  Serial.write(INLET_VALVE);
  Serial.write(DISABLE);
  delay(10);
}
void enable_outlet(void) {
  Serial.write(0xFF);
  Serial.write(OUTLET_VALVE);
  Serial.write(ENABLE);
  delay(10);
}
void disable_outlet(void) {
  Serial.write(0xFF);
  Serial.write(OUTLET_VALVE);
  Serial.write(DISABLE);
  delay(10);
}
