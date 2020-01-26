<?hh // strict

namespace Lexidor\FBInterceptPolyfill\TestSubjects;

function plain_function(): void {
  GlobalState::$last_called_function = __FUNCTION__;
}
