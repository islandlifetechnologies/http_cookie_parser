<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents**

- [Introduction](#introduction)
- [Usage](#usage)
- [Why is this necessary?](#why-is-this-necessary)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

Parser for the comma joined `set-header` cookie header that the [http] package gives back. The `CookieParser` will accept that singular header value and then attempt to parse it back into the original separated values.

## Usage

```dart
import 'package:http/http.dart' as http;
import 'package:http_cookie_parser/http_cookie_parser.dart';

Future<void> load() async {
  final response = await http.get('https://www.cnn.com'); // CNN is known to have troublesome cookies
  final cookies = CookieParser(response.headers['set-cookie']).cookies;

  // Now you can do whatever you need as each element in the cookies array is an
  // individual cookie value again.
}
```

## Why is this necessary?

Cookie values can contain commas within them. In fact, the `Expires` value is spec'd to have one in it. Let's say you get back the cookies from the server:

```
set-cookie: foo=bar; Expires=Expires=Fri, 20 Aug 2027 00:55:08 GMT; HttpOnly
set-cookie: commas=a,b,c,d; HttpOnly
```

Then what you will get back from the [http] package when you query the `set-cookie` header is actually:

```
foo=bar; Expires=Expires=Fri, 20 Aug 2027 00:55:08 GMT,commas=a,b,c,d; HttpOnly
```

Try to do a `value.split(',')` and you get:

```dart
[
  'foo=bar; Expires=Expires=Fri',
  '20 Aug 2027 00:55:08 GMT',
  'HttpOnly',
  'commas=a',
  'b',
  'c',
  'd; HttpOnly'
]
```

Try to parse those items using any standard cookie decoder and you're toing to get a parse error.

<!-- Links -->

[http]: https://pub.dev/packages/http
