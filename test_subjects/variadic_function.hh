<?hh // strict

namespace Quizlet\FBInterceptPolyfill\TestSubjects;

function variadic_function(mixed $required, mixed ...$rest): void {
  GlobalState::$last_called_function = __FUNCTION__;
}
