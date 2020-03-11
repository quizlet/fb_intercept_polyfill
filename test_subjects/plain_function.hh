<?hh // strict

namespace Quizlet\FBInterceptPolyfill\TestSubjects;

function plain_function(): void {
  GlobalState::$last_called_function = __FUNCTION__;
}
