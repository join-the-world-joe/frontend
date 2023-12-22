
void main() {
  var str = '36/1.jpg';
  var key = ((str.split('.')[0]).split('/'))[1];
  print(key);
}