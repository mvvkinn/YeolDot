#include <WiFi.h>
#include <PubSubClient.h>
#include <PubSubClientTools.h>

const char* ssid = "5453M3DEV";
const char* password = "qwer1234";
const char* mqttServer = "192.168.0.17";
const int mqttPort = 1883;
const char* mqttUser = "YeolDot-1";
const char* mqttPassword = "";

String s = "";

WiFiClient ESPClient;
PubSubClient client(ESPClient);
PubSubClientTools mqtt(client);


void setup() {
  Serial.begin(115200);
  Serial.println("Fine Dust Window Controller");
  delay(1000);
  Serial.println("Initialinzing..");
  delay(4000);

  // 와이파이 연결
  WiFi.begin(ssid, password);

  // 미연결시 지속적으로 메시지 표시
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Connecting to WiFi, please wait");
  }

  Serial.println("Device > Connected to WiFi");

  // MQTT 서버 주소, 포트 지정
  client.setServer(mqttServer, mqttPort);

  while (!client.connected()) {
    Serial.println("Device > Connecting to MQTT Server...");

    // 클라이언트 이름, 유저이름, 유저 비밀번호
    if (client.connect("ESP32Client", mqttUser, mqttPassword) ) {
      Serial.println("Connected to MQTT");

      mqtt.subscribe("esp/test1", topic1_subscriber);
      mqtt.subscribe("esp/test2", topic1_subscriber);
    } else {
      Serial.print("ERROR > Failed with state : ");
      Serial.println(client.state());
      delay(2000);
    }
  }

  mqtt.publish("esp/test1", "connected test 1");
  mqtt.publish("esp/test2", "connected test 2");
}

void loop() {
  client.loop();
}

void topic1_subscriber(String topic, String message) {
  Serial.println(s + "Message arrived in function 1 [" + topic + "] " + message);
}
