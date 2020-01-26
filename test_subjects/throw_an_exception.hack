namespace Lexidor\FBInterceptPolyfill\TestSubjects;

function throw_an_exception(): noreturn {
  GlobalState::$last_called_function = __FUNCTION__;
  throw new \Exception(__FUNCTION__);
}
