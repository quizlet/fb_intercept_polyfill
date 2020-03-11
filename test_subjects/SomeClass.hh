<?hh // strict

namespace Quizlet\FBInterceptPolyfill\TestSubjects;

final class SomeClass {
  public static function get42Static(): int {
    return 42;
  }
  public function get42NonStatic(): int {
    return 42;
  }
}
