#define S (13)
#define O (A5)
#define L (A4)
#define T (A1)
#define A (A3)
#define B (A2)
#define FOO (A0)

void setup() {
  pinMode(S, OUTPUT);
  pinMode(O, OUTPUT);
  pinMode(L, OUTPUT);
  pinMode(T, OUTPUT);
  pinMode(A, OUTPUT);
  pinMode(B, OUTPUT);
  pinMode(FOO, OUTPUT);
  digitalWrite(S, LOW);
  digitalWrite(O, LOW);
  digitalWrite(L, LOW);
  digitalWrite(T, LOW);
  digitalWrite(A, LOW);
  digitalWrite(B, LOW);
  digitalWrite(FOO, LOW);

  Serial.begin(115200);
  Serial.setTimeout(1000);

  Serial.println("Commands: S, O, L, T, A, B or N for None");
  Serial.println("READY");
}


void setRelay(char d){
  if(d == 'S' || d == 'O' || d == 'L' || d == 'T' || d == 'A' || d == 'B' || d == 'N'){
  if(d=='S') digitalWrite(S, HIGH);
  else digitalWrite(S, LOW);

  if(d=='O') digitalWrite(O, HIGH);
  else digitalWrite(O, LOW);
  
  if(d=='L') digitalWrite(L, HIGH);
  else digitalWrite(L, LOW);

  if(d=='T') digitalWrite(T, HIGH);
  else digitalWrite(T, LOW);

  if(d=='A') digitalWrite(A, HIGH);
  else digitalWrite(A, LOW);

  if(d=='B') digitalWrite(B, HIGH);
  else digitalWrite(B, LOW);

  if(d=='N') digitalWrite(FOO, HIGH);
  else digitalWrite(FOO, LOW);
  
  Serial.println(d);
  }
}

void loop() {
  char data;
  if(Serial.available()){
    data=Serial.read();
    setRelay(data);
    
    // put your main code here, to run repeatedly:
  }
}
