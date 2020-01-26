<?hh // strict

namespace Lexidor\FBInterceptPolyfill\TestSubjects;

function get_42(): int {
  GlobalState::$last_called_function = __FUNCTION__;
  return 42;
}
