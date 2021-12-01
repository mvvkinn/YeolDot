
int dustpin = 10;
unsigned long duration;
unsigned long starttime;
unsigned long sampletime_ms = 30000; //30초, 측정에 필요한시간(측정 해상도 높이기 위함)
unsigned long lowpulseoccupancy = 0;
float ratio = 0;
float concentration = 0;
float ugm3 = 0;

void setup() {
  Serial.begin(9600);
  pinMode(dustpin, INPUT);
  starttime = millis();
}

int sample_dust(int pin, float ugm3, unsigned long sampletime_ms) {
  duration = pulseIn(pin, LOW);
  lowpulseoccupancy = lowpulseoccupancy + duration;

  if ((millis() - starttime) < 1000) {
    Serial.println("\n측정 중...");
  }

  if ((millis() - starttime) > sampletime_ms) {
    ratio = lowpulseoccupancy / (sampletime_ms * 10.0);

    // 미세먼지 측정값 공식// 미세먼지 측정값 공식
    concentration = 1.1 * pow(ratio, 3) - 3.8 * pow(ratio, 2) + 520 * ratio + 0.62;
    ugm3 = concentration * 100 / 13000;

    lowpulseoccupancy = 0;
    starttime = millis();

    Serial.print("PM 1.0 : ");
    Serial.print(ugm3);
    Serial.println("㎍/㎥");
    return ugm3;
  }  
}

void loop() {
  ugm3 = sample_dust(dustpin, ugm3, sampletime_ms);
}
