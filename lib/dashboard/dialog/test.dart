
void main() {
  var url = ' https://advertisement-image.oss-cn-shenzhen.aliyuncs.com/1/0.jpg';
  
  var commonPath = url.split('1/0.jpg')[0];
  print('commonPath: $commonPath');

  // var str = '40/0.png';
  // var key = ((str.split('.')[0]).split('/'))[1];
  // print(key);

  // var timestamp = (DateTime.now().millisecondsSinceEpoch)~/1000;
  // print('timestamp: $timestamp');
}