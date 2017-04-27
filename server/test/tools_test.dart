import 'package:test/test.dart';
import 'package:dartalog/tools.dart';

void main() {
  group("Server tools", () {

    group("normalizeReadableId()", () {
      test("null",() {
        expect(() => normalizeReadableId(null), throwsArgumentError);
      });
      test("plain",() {
        final String result = normalizeReadableId("plain");
        expect(result=="plain", isTrue);
      });
      test("extra whitespace",() {
        final String result = normalizeReadableId("  plain  ");
        expect(result=="plain", isTrue);
      });
      test("uppercase",() {
        final String result = normalizeReadableId("PlaiN");
        expect(result=="plain", isTrue);
      });
      test("escape characters",() {
        final String result = normalizeReadableId("foo%3Dfoo%26bar%3Dbar");
        expect(result=="foo=foo&bar=bar", isTrue);
      });

      test("combined",() {
        final String result = normalizeReadableId("foo%3DFOO%26bar%3Dbar%20 %20");
        expect(result=="foo=foo&bar=bar", isTrue);
      });


    });
  });
}
