import 'package:http_cookie_parser/http_cookie_parser.dart';
import 'package:test/test.dart';

void main() {
  test('multiple cookies - end on flag', () {
    final cookieStrs = [
      'SecGpc=0; Domain=.cnn.com; Path=/; SameSite=None; Secure',
      'countryCode=US; Domain=.cnn.com; Path=/; SameSite=None; Secure',
      'stateCode=HI; Domain=.cnn.com; Path=/; SameSite=None; Secure',
      'geoData=yep no|HI|12345|US|NA|-400|broadband|0.00|0.00|539; Domain=.cnn.com; Path=/; SameSite=None; Secure',
      'FastAB=0=123,1=123,2=123,3=123,4=123,5=123,6=132,7=123,8=123,9=123,10=123,11=123,12=123,13=123,14=123,15=123,16=123,17=123,18=123,19=123,h=12,c=00000000,u=00000000; Domain=.cnn.com; Path=/; Expires=Fri, 20 Aug 2027 00:55:08 GMT; HttpOnly; SameSite=None; Secure',
      'wbdFch=0000000000000000000000000000000000000000; Domain=www.cnn.com; Path=/; Max-Age=30; SameSite=None; Secure',
    ];

    final cookieStr = cookieStrs.join(',');

    final parser = CookieParser(cookieStr);
    final cookies = parser.cookies;

    expect(cookies.length, cookieStrs.length);
    expect(cookies, cookieStrs);
  });

  test('multi - ends on kvp', () {
    final cookieStrs = [
      'SecGpc=0; Domain=.cnn.com; Path=/; Secure; SameSite=None',
      'countryCode=US; Domain=.cnn.com; Path=/; Secure; SameSite=None',
    ];
    final cookieStr = cookieStrs.join(',');

    final parser = CookieParser(cookieStr);
    final cookies = parser.cookies;

    expect(cookies.length, cookieStrs.length);
    expect(cookies, cookieStrs);
  });

  test('single cookie - end on flag', () {
    final cookieStrs = [
      'wbdFch=0000000000000000000000000000000000000000; Domain=www.cnn.com; Path=/; Max-Age=30; SameSite=None; Secure',
    ];
    final cookieStr = cookieStrs.join(',');

    final parser = CookieParser(cookieStr);
    final cookies = parser.cookies;

    expect(cookies.length, cookieStrs.length);
    expect(cookies, cookieStrs);
  });

  test('single cookie -  ends on kvp', () {
    final cookieStrs = [
      'SecGpc=0; Domain=.cnn.com; Path=/; Secure; SameSite=None',
    ];
    final cookieStr = cookieStrs.join(',');

    final parser = CookieParser(cookieStr);
    final cookies = parser.cookies;

    expect(cookies.length, cookieStrs.length);
    expect(cookies, [
      'SecGpc=0; Domain=.cnn.com; Path=/; Secure; SameSite=None',
    ]);
  });
}
