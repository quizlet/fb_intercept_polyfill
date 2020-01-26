namespace Lexidor\FBInterceptPolyfill\TestSubjects;

function takes_three_arguments(int $one, string $two, \Exception $three): void {
  GlobalState::$last_called_function = __FUNCTION__;
}
