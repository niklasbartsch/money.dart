/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 - 2019 LitGroup LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:money2/money2.dart';
import 'package:test/test.dart';

void main() {
  final usd = Currency.create('USD', 2);
  final euro = Currency.create('EUR', 2,
      symbol: '€', invertSeparators: true, pattern: '0,00 S');
  // final long = Currency.create('LONG', 2);

  // final Money usd10d25 = Money.fromInt(1025, usd);
  // final Money usd10 = Money.fromInt(1000, usd);
  // final Money long1000d90 = Money.fromInt(100090, long);

  group('Money.parse', () {
    test('Default Currency Pattern', () {
      expect(Money.parse(r'$10.25', code: 'USD'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Money.parse('10.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Money.parse('USD10.25', code: 'USD', pattern: 'CCC#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Money.parse(r'$USD10.25', code: 'USD', pattern: 'SCCC#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Money.parse('1,000.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromInt(100025, code: 'USD')));
    });

    test('Default Currency Pattern with negative number', () {
      expect(Money.parse(r'$-10.25', code: 'USD'),
          equals(Money.fromInt(-1025, code: 'USD')));
      expect(Money.parse('-10.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromInt(-1025, code: 'USD')));
      expect(Money.parse('USD-10.25', code: 'USD', pattern: 'CCC#.#'),
          equals(Money.fromInt(-1025, code: 'USD')));
      expect(Money.parse(r'$USD-10.25', code: 'USD', pattern: 'SCCC#.#'),
          equals(Money.fromInt(-1025, code: 'USD')));
      expect(Money.parse('-1,000.25', code: 'USD', pattern: '#.#'),
          equals(Money.fromInt(-100025, code: 'USD')));
    });

    test('Inverted Decimal Separator with pattern', () {
      expect(Money.parse('10,25', code: 'EUR', pattern: '#,#'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Money.parse('€10,25', code: 'EUR', pattern: 'S0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Money.parse('EUR10,25', code: 'EUR', pattern: 'CCC0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Money.parse('€EUR10,25', code: 'EUR', pattern: 'SCCC0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Money.parse('1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromInt(100025, code: 'EUR')));
      expect(Money.parse('1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromInt(100025, code: 'EUR')));
    });

    test('Inverted Decimal Separator with pattern with negative number', () {
      expect(Money.parse('-10,25', code: 'EUR', pattern: '#,#'),
          equals(Money.fromInt(-1025, code: 'EUR')));
      expect(Money.parse('€-10,25', code: 'EUR', pattern: 'S0,0'),
          equals(Money.fromInt(-1025, code: 'EUR')));
      expect(Money.parse('EUR-10,25', code: 'EUR', pattern: 'CCC0,0'),
          equals(Money.fromInt(-1025, code: 'EUR')));
      expect(Money.parse('€EUR-10,25', code: 'EUR', pattern: 'SCCC0,0'),
          equals(Money.fromInt(-1025, code: 'EUR')));
      expect(Money.parse('-1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromInt(-100025, code: 'EUR')));
      expect(Money.parse('-1.000,25', code: 'EUR', pattern: '#.###,00'),
          equals(Money.fromInt(-100025, code: 'EUR')));
    });

    test(
        'Decode and encode with the same currency should be inverse operations',
        () {
      final currency = Currency.create('MONEY', 0, pattern: '0 CCC');
      const stringValue = '1025 MONEY';
      expect(Money.parseWithCurrency(stringValue, currency).toString(),
          equals(stringValue));

      for (var precision = 1; precision < 5; precision++) {
        final currency = Currency.create('MONEY', precision,
            pattern: '0.${'0' * precision} CCC');
        final stringValue = '1025.${'0' * (precision - 1)}1 MONEY';
        expect(Money.parseWithCurrency(stringValue, currency).toString(),
            equals(stringValue));
      }
    });
  });

  test('Decode and encode with the same currency should be inverse operations',
      () {
    final currency = Currency.create('MONEY', 0, pattern: '0 CCC');
    const stringValue = '1025 MONEY';
    expect(Money.parseWithCurrency(stringValue, currency).toString(),
        equals(stringValue));

    for (var precision = 1; precision < 5; precision++) {
      final currency = Currency.create('MONEY', precision,
          pattern: '0.${'0' * precision} CCC');
      final stringValue = '1025.${'0' * (precision - 1)}1 MONEY';
      expect(Money.parseWithCurrency(stringValue, currency).toString(),
          equals(stringValue));
    }
  });

  group('Currency.parse', () {
    test('Default Currency Pattern', () {
      expect(usd.parse(r'$10.25'), equals(Money.fromInt(1025, code: 'USD')));
      expect(usd.parse('10.25', pattern: '#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(usd.parse('USD10.25', pattern: 'CCC#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(usd.parse(r'$USD10.25', pattern: 'SCCC#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(usd.parse('1,000.25', pattern: '#.#'),
          equals(Money.fromInt(100025, code: 'USD')));
    });

    test('Missing decimals', () {
      expect(euro.parse('€EUR10,2', pattern: 'SCCC0,0'),
          equals(Money.fromInt(1020, code: 'EUR')));
      expect(euro.parse('€EUR10,200', pattern: 'SCCC0,0'),
          equals(Money.fromInt(1020, code: 'EUR')));
    });

    test('White space', () {
      expect(usd.parse(r'$ 10.25', pattern: 'S #.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(usd.parse(r'$USD 10.25', pattern: 'SCCC #.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(usd.parse(r'$ USD 10.25', pattern: 'S CCC #.#'),
          equals(Money.fromInt(1025, code: 'USD')));
    });

    test('White space with negative number', () {
      expect(usd.parse(r'$ -10.25', pattern: 'S #.#'),
          equals(Money.fromInt(-1025, code: 'USD')));
      expect(usd.parse(r'$USD -10.25', pattern: 'SCCC #.#'),
          equals(Money.fromInt(-1025, code: 'USD')));
      expect(usd.parse(r'$ USD -10.25', pattern: 'S CCC #.#'),
          equals(Money.fromInt(-1025, code: 'USD')));
    });

    test('Inverted Decimal Separator with pattern', () {
      expect(euro.parse('10,25', pattern: '#,#'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(euro.parse('€10,25', pattern: 'S0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(euro.parse('EUR10,25', pattern: 'CCC0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(euro.parse('€EUR10,25', pattern: 'SCCC0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(euro.parse('1.000,25', pattern: '#.###,00'),
          equals(Money.fromInt(100025, code: 'EUR')));
      expect(euro.parse('1.000,25', pattern: '#.###,00'),
          equals(Money.fromInt(100025, code: 'EUR')));
    });
  });

  group('Currencies().parse', () {
    Currencies().register(usd);
    Currencies().register(euro);

    test('Default Currency Pattern', () {
      expect(Currencies().parse(r'$USD10.25', pattern: 'SCCC0.0'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Currencies().parse('USD10.25', pattern: 'CCC#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Currencies().parse('USD10.25', pattern: 'CCC#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Currencies().parse(r'$USD10.25', pattern: 'SCCC#.#'),
          equals(Money.fromInt(1025, code: 'USD')));
      expect(Currencies().parse('USD1,000.25', pattern: 'CCC#.#'),
          equals(Money.fromInt(100025, code: 'USD')));
    });

    test('Inverted Decimal Separator with pattern', () {
      expect(Currencies().parse('EUR10,25', pattern: 'CCC#,#'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Currencies().parse('€EUR10,25', pattern: 'SCCC0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Currencies().parse('EUR10,25', pattern: 'CCC0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Currencies().parse('€EUR10,25', pattern: 'SCCC0,0'),
          equals(Money.fromInt(1025, code: 'EUR')));
      expect(Currencies().parse('EUR1.000,25', pattern: 'CCC#.###,00'),
          equals(Money.fromInt(100025, code: 'EUR')));
      expect(Currencies().parse('EUR1.000,25', pattern: 'CCC#.###,00'),
          equals(Money.fromInt(100025, code: 'EUR')));
    });
  });

  group('parse methods', () {
    test('Money', () {
      expect(Money.parse(r'$10.25', code: 'USD'),
          equals(Money.fromInt(1025, code: 'USD')));
    });

    test('Currency', () {
      expect(usd.parse(r'$10.25'), equals(Money.fromInt(1025, code: 'USD')));
    });

    test('Currencies', () {
      expect(Currencies().parse(r'$USD10.25', pattern: 'SCCC0.0'),
          equals(Money.fromInt(1025, code: 'USD')));
    });

    test('example', () {
      final aud = Currency.create('AUD', 2);
      final one = aud.parse(r'$1.12345');
      expect(one.minorUnits.toInt(), equals(112));
      expect(one.format('#'), equals('1'));
      expect(one.format('#.#'), equals('1.1'));
      expect(one.format('#.##'), equals('1.12'));
      expect(one.format('#.##0'), equals('1.120'));

      expect(one.format('#.0'), equals('1.1'));
      expect(one.format('#.00'), equals('1.12'));
      expect(one.format('#.000'), equals('1.120'));
    });
  });
}
