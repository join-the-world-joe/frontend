
void main() {
  var str = '40/0.png';
  var key = ((str.split('.')[0]).split('/'))[1];
  print(key);
}