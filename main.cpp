#define TOL 3
extern "C" {
  uint8_t cap();
  unsigned short avg();
}

bool isDisrupted() {
  int initial = avg();
  int secondary = avg();
  if(abs(initial - secondary) >= TOL) return false;
  return true;
}
