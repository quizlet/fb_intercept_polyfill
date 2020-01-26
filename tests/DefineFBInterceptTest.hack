namespace Lexidor\FBInterceptPolyfill\Tests;

use type HH\Lib\Ref;
use namespace HH\Lib\Str;
use type Facebook\HackTest\{DataProvider, HackTest};
use function Facebook\FBExpect\expect;
use namespace Lexidor\FBInterceptPolyfill\TestSubjects;
use type Lexidor\FBInterceptPolyfill\TestSubjects\GlobalState;
use namespace Lexidor\FBInterceptPolyfill\_Private;
use namespace Lexidor\FBInterceptPolyfill;

class DefineFBInterceptTest extends HackTest {
  #region fully-qualified function names

  const string PLAIN_FUNCTION =
    'Lexidor\FBInterceptPolyfill\TestSubjects\plain_function';
  const string GET_42 = 'Lexidor\FBInterceptPolyfill\TestSubjects\get_42';
  const string THROW_AN_EXCEPTION =
    'Lexidor\FBInterceptPolyfill\TestSubjects\throw_an_exception';
  const string TAKES_THREE_ARGUMENTS =
    'Lexidor\FBInterceptPolyfill\TestSubjects\takes_three_arguments';
  const string VARIADIC_FUNCTION =
    'Lexidor\FBInterceptPolyfill\TestSubjects\variadic_function';
  const string GET_42_STATIC =
    'Lexidor\FBInterceptPolyfill\TestSubjects\SomeClass::get42Static';
  const string GET_42_NON_STATIC =
    'Lexidor\FBInterceptPolyfill\TestSubjects\SomeClass::get42NonStatic';

  const keyset<string> ALL_FUNCTIONS = keyset[
    self::PLAIN_FUNCTION,
    self::GET_42,
    self::THROW_AN_EXCEPTION,
    self::TAKES_THREE_ARGUMENTS,
    self::VARIADIC_FUNCTION,
    self::GET_42_STATIC,
    self::GET_42_NON_STATIC,
  ];

  #endregion
  #region HackTest configuration


  <<__Override>>
  public async function beforeEachTestAsync(): Awaitable<void> {
    GlobalState::$last_called_function = null;
    foreach (self::ALL_FUNCTIONS as $function) {
      self::fbInterceptRequireSuccess($function, null);
    }
  }
  #endregion
  #region tests

  /**
   * @spec By default `$done` is `true` so it will return handler's return immediately without executing old function's code.
   */
  public function test_the_default_value_of_done_is_false(): void {
    self::fbInterceptRequireSuccess(
      self::PLAIN_FUNCTION,
      /*HH_FIXME[2087] Reference use*/
      (mixed $_, mixed $_, mixed $_, mixed $_, bool &$done) ==>
        invariant($done, 'Done should be true, got: %s', \print_r($done)),
    );
  }

  /**
   * @spec If this handler returns `FALSE`, code will continue with original function.
   *
   * This test fails with the default implementation of fb_intercept.
   * I am assuming that this is a problem with the spec.
   */
  public function test_return_false_from_handler_with_done_set_to_true_calls_the_original_function(
  ): void {
    self::markTestSkipped(
      'The documentation does not match the implementation',
    );

    self::fbInterceptRequireSuccess(
      self::PLAIN_FUNCTION,
      self::getFalseHandlerWithDoneAsTrue(),
    );
    TestSubjects\plain_function();

    expect(GlobalState::$last_called_function)->toBeSame(self::PLAIN_FUNCTION);
  }

  /**
   * @spec If this handler returns `FALSE`, code will continue with original function.
   *
   * This test fails with the default implementation of fb_intercept.
   * I am assuming that this is a problem with the spec.
   */
  public function test_return_false_from_handler_with_done_set_to_true_propagates_exceptions_from_the_original_function(
  ): void {
    self::markTestSkipped(
      'The documentation does not match the implementation',
    );

    self::fbInterceptRequireSuccess(
      self::GET_42,
      self::getFalseHandlerWithDoneAsTrue(),
    );
    $fourty_two = TestSubjects\get_42();

    expect($fourty_two)->toBeSame(42);
  }

  /**
   * @spec If this handler returns `FALSE`, code will continue with original function.
   *
   * This test fails with the default implementation of fb_intercept.
   * I am assuming that this is a problem with the spec.
   */
  public function test_return_false_from_handler_with_done_set_to_true_returns_the_value_from_to_original_function(
  ): void {
    self::markTestSkipped(
      'The documentation does not match the implementation',
    );

    self::fbInterceptRequireSuccess(
      self::THROW_AN_EXCEPTION,
      self::getFalseHandlerWithDoneAsTrue(),
    );

    expect(() ==> TestSubjects\throw_an_exception())->toThrow(
      \Exception::class,
      self::THROW_AN_EXCEPTION,
    );
  }

  /**
   * @spec If this handler returns `FALSE`, code will continue with original function.
   * @spec Set `$done` to `false` to indicate function should continue its execution with old function as if interception did not happen.
   */
  public function test_return_false_from_handler_with_done_set_to_false_calls_the_original_function(
  ): void {
    self::fbInterceptRequireSuccess(
      self::PLAIN_FUNCTION,
      self::getFalseHandlerWithDoneAsFalse(),
    );
    TestSubjects\plain_function();

    expect(GlobalState::$last_called_function)->toBeSame(self::PLAIN_FUNCTION);
  }

  /**
   * @spec If this handler returns `FALSE`, code will continue with original function.
   * @spec Set `$done` to `false` to indicate function should continue its execution with old function as if interception did not happen.
   */
  public function test_return_false_from_handler_with_done_set_to_false_propagates_exceptions_from_the_original_function(
  ): void {
    self::fbInterceptRequireSuccess(
      self::GET_42,
      self::getFalseHandlerWithDoneAsFalse(),
    );
    $fourty_two = TestSubjects\get_42();

    expect($fourty_two)->toBeSame(42);
  }

  /**
   * @spec If this handler returns `FALSE`, code will continue with original function.
   * @spec Set `$done` to `false` to indicate function should continue its execution with old function as if interception did not happen.
   */
  public function test_return_false_from_handler_with_done_set_to_false_returns_the_value_from_to_original_function(
  ): void {
    self::fbInterceptRequireSuccess(
      self::THROW_AN_EXCEPTION,
      self::getFalseHandlerWithDoneAsFalse(),
    );

    expect(() ==> TestSubjects\throw_an_exception())->toThrow(
      \Exception::class,
      self::THROW_AN_EXCEPTION,
    );
  }

  /**
   * @spec If this handler returns `FALSE`, code will continue with original function.
   * @spec Set `$done` to `false` to indicate function should continue its execution with old function as if interception did not happen.
   */
  public function test_return_value_from_handler_is_returned_when_done_is_set_to_true(
  ): void {
    self::fbInterceptRequireSuccess(
      self::THROW_AN_EXCEPTION,
      self::getEchoingHandlerWithDoneAsTrue('<<<MY_INPUT>>>'),
    );

    /*HH_FIXME[4133] This function will not be noreturn at runtime.*/
    expect(TestSubjects\throw_an_exception())->toBeSame('<<<MY_INPUT>>>');
  }

  /**
   * @spec Returns `bool` - - `TRUE` if successful, `FALSE` otherwise
   */
  public function test_intercepting_an_non_existant_function_is_a_successful_case(
  ): void {
    expect(self::fbIntercept(
      '__this_function_should_not_exists',
      self::getFalseHandlerWithDoneAsTrue(),
    ))->toBeTrue();
  }

  /**
   * @spec Returns `bool` - - `TRUE` if successful, `FALSE` otherwise
   */
  public function test_passing_a_handler_with_an_too_many_arguments_is_a_successful_case(
  ): void {
    /*HH_FIXME[2087] Reference use*/
    expect(self::fbIntercept(self::PLAIN_FUNCTION, (mixed $_, mixed $_, mixed $_, mixed $_, mixed &$_, mixed $_) ==> false))->toBeTrue();
  }

  /**
   * @spec Returns `bool` - - `TRUE` if successful, `FALSE` otherwise
   */
  public function test_passing_a_handler_with_an_too_few_arguments_is_a_successful_case(
  ): void {
    expect(self::fbIntercept(self::PLAIN_FUNCTION, (mixed $_) ==> false))
      ->toBeTrue();
  }

  /**
   * @spec Returns `bool` - - `TRUE` if successful, `FALSE` otherwise
   */
  public function test_passing_a_handler_with_a_non_existant_function_name_is_a_succesful_case(
  ): void {
    expect(self::fbIntercept(
      self::PLAIN_FUNCTION,
      '__this_function_should_not_exist',
    ))->toBeTrue();
  }

  /**
   * @spec `$name` is original function's fully-qualified name ('`Class::method`'),
   */
  public function test_the_first_argument_passed_to_handler_is_the_fully_qualified_name_of_the_function(
  ): void {
    $function_name = new Ref<?string>(null);
    self::fbInterceptRequireSuccess(
      self::THROW_AN_EXCEPTION,
      (mixed $x) ==> $x,
    );
    self::fbInterceptRequireSuccess(
      self::GET_42,
      (string $name, mixed ...$_) ==> {
        $function_name->value = $name;
        return false;
      },
    );
    self::fbInterceptRequireSuccess(self::PLAIN_FUNCTION, (mixed $x) ==> $x);
    TestSubjects\get_42();

    expect($function_name->value)->toBeSame(self::GET_42);
  }

  /**
   * @spec `$obj` is ... `null` for ... function calls. 
   */
  public function test_the_second_argument_passed_to_handler_is_null_when_calling_a_function(
  ): void {
    $object_reference = new Ref<mixed>('<<<NOT_CHANGED>>>');
    self::fbInterceptRequireSuccess(
      self::GET_42,
      (mixed $_, mixed $obj, mixed ...$_) ==> {
        $object_reference->value = $obj;
        return false;
      },
    );
    TestSubjects\get_42();

    expect($object_reference->value)->toBeNull();
  }

  /**
   * @spec `$obj` is ... `null` for static method call. 
   *
   * This test fails with the default implementation of fb_intercept.
   * I am assuming that this is a problem with the spec.
  */
  public function test_the_second_argument_passed_to_handler_is_null_when_calling_a_static_method(
  ): void {
    self::markTestSkipped(
      'It is actually the classname of the class you are intercepting',
    );
    $object_reference = new Ref<mixed>('<<<NOT_CHANGED>>>');
    self::fbInterceptRequireSuccess(
      self::GET_42_STATIC,
      (mixed $_, mixed $obj, mixed ...$_) ==> {
        $object_reference->value = $obj;
        return false;
      },
    );
    TestSubjects\SomeClass::get42Static();

    expect($object_reference->value)->toBeNull();
  }

  /**
   * @spec `$obj` is `$this` for an instance method call. 
   */
  public function test_the_second_argument_passed_to_handler_is_this_when_calling_a_non_static_method(
  ): void {
    $object_reference = new Ref<mixed>('<<<NOT_CHANGED>>>');
    $instance = new TestSubjects\SomeClass();
    self::fbInterceptRequireSuccess(
      self::GET_42_NON_STATIC,
      (mixed $_, mixed $obj, mixed ...$_) ==> {
        $object_reference->value = $obj;
        return false;
      },
    );

    $instance->get42NonStatic();

    expect($object_reference->value)->toBeSame($instance);

    $object_reference->value = '<<<RESET>>>';
    $instance2 = new TestSubjects\SomeClass();
    $instance2->get42NonStatic();

    expect($object_reference->value)->toBeSame($instance2);
  }

  /**
   * @spec `\$params` are original call's parameters.
   */
  public function test_the_third_argument_is_an_empty_array_when_zero_arguments_are_passed(
  ): void {
    $parameters = new Ref<?varray<mixed>>(null);
    self::fbInterceptRequireSuccess(
      self::GET_42,
      (mixed $_, mixed $_, varray<mixed> $params, mixed ...$_) ==> {
        $parameters->value = $params;
        return false;
      },
    );
    TestSubjects\get_42();

    expect($parameters->value)->toBeSame(varray[]);
  }

  /**
   * @spec `\$params` are original call's parameters.
   */
  public function test_the_third_argument_is_an_array_containing_the_arguments_that_were_passed(
  ): void {
    $param_tuple = tuple(1337, 'h4x0r', new \LengthException('This class'));
    $parameters = new Ref<?varray<mixed>>(null);
    self::fbInterceptRequireSuccess(
      self::TAKES_THREE_ARGUMENTS,
      (mixed $_, mixed $_, varray<mixed> $params, mixed ...$_) ==> {
        $parameters->value = $params;
        return false;
      },
    );
    TestSubjects\takes_three_arguments(...$param_tuple);

    expect($parameters->value)->toBeSame(
      \array_values($param_tuple as Container<_>),
    );
  }

  /**
   * @spec `\$params` are original call's parameters.
   */
  public function test_the_third_argument_is_an_array_containing_the_arguments_that_were_passed_for_variadic_functions(
  ): void {
    $param_tuple = tuple(1337, 'h4x0r', new \LengthException('This class'));
    $parameters = new Ref<?varray<mixed>>(null);
    self::fbInterceptRequireSuccess(
      self::VARIADIC_FUNCTION,
      (mixed $_, mixed $_, varray<mixed> $params, mixed ...$_) ==> {
        $parameters->value = $params;
        return false;
      },
    );
    TestSubjects\variadic_function(...$param_tuple);

    expect($parameters->value)->toBeSame(
      \array_values($param_tuple as Container<_>),
    );
  }

  /**
   * @spec `$data` is what's passed to `fb_intercept()`.
   */
  public function test_the_fourth_argument_contains_the_free_data_passed_to_fb_intercept(
  ): void {
    $exception = new \LengthException('The function names');
    $free_data = new Ref<mixed>('<<<NOT_CHANGED>>>');
    $handler = (mixed $_, mixed $_, mixed $_, mixed $data) ==> {
      $free_data->value = $data;
      return false;
    };
    self::fbInterceptRequireSuccess(self::GET_42, $handler);
    self::fbInterceptRequireSuccess(self::PLAIN_FUNCTION, $handler, $exception);

    TestSubjects\get_42();

    expect($free_data->value)->toBeSame(null);
    $free_data->value = '<<<RESET>>>';

    TestSubjects\plain_function();
    expect($free_data->value)->toBeSame($exception);
  }

  /**
   * @spec If empty, all functions will be intercepted by the specified handler and individual handlers will be replaced.
   */
  public function test_setting_an_empty_string_as_name_intercepts_all_functions_and_methods_and_resets_previously_set_interceptions(
  ): void {
    self::markTestSkipped(<<<'EOF'
      I cannot pass this test.
      If I pass in the empty string as the first argument,
      fb_intercept will intercept all the internal calls in HackTest and fbexpect.
      I'll also not be able to support this in my polyfill,
      since you'll not be able to call fb_intercept again,
      because my polyfill is being intercepted.
      If you need to use this behavior, this package isn't for you.
EOF
    );
  }

  /**
   * @spec Use `null`, `false` or empty string `""` unregister a previously registered handler.
   */
  public function test_calling_fb_intercept_with_empty_string_false_null_or_handler_deregisters_the_handler(
  ): void {
    self::fbInterceptRequireSuccess(
      self::THROW_AN_EXCEPTION,
      self::getFalseHandlerWithDoneAsTrue(),
    );

    expect(() ==> TestSubjects\throw_an_exception())->notToThrow();

    self::fbInterceptRequireSuccess(self::THROW_AN_EXCEPTION, '');

    expect(() ==> TestSubjects\throw_an_exception())->toThrow(
      \Exception::class,
      self::THROW_AN_EXCEPTION,
    );

    self::fbInterceptRequireSuccess(
      self::THROW_AN_EXCEPTION,
      self::getFalseHandlerWithDoneAsTrue(),
    );

    expect(() ==> TestSubjects\throw_an_exception())->notToThrow();

    self::fbInterceptRequireSuccess(self::THROW_AN_EXCEPTION, false);

    expect(() ==> TestSubjects\throw_an_exception())->toThrow(
      \Exception::class,
      self::THROW_AN_EXCEPTION,
    );
    self::fbInterceptRequireSuccess(
      self::THROW_AN_EXCEPTION,
      self::getFalseHandlerWithDoneAsTrue(),
    );

    expect(() ==> TestSubjects\throw_an_exception())->notToThrow();

    self::fbInterceptRequireSuccess(self::THROW_AN_EXCEPTION, null);

    expect(() ==> TestSubjects\throw_an_exception())->toThrow(
      \Exception::class,
      self::THROW_AN_EXCEPTION,
    );
  }

  /**
   * @spec If name is empty, all previously handlers, including those that are set by individual function names, will be removed.
   * @spec Use `null`, `false` or empty string `""` unregister a previously registered handler.
   */
  public function test_passing_an_empty_string_as_name_and_null_as_handler_remoev_all_registered_handlers(
  ): void {
    self::fbInterceptRequireSuccess(
      self::GET_42,
      self::getFalseHandlerWithDoneAsTrue(),
    );
    self::fbInterceptRequireSuccess(
      self::GET_42_STATIC,
      self::getFalseHandlerWithDoneAsTrue(),
    );

    self::fbInterceptRequireSuccess('', null);

    expect(TestSubjects\get_42())->toBeSame(42);
    expect(TestSubjects\SomeClass::get42Static())->toBeSame(42);
  }

  /**
   * @spec Note that built-in functions are not interceptable.
   */
  public function test_intercepting_a_builtin_function_fails(): void {
    self::fbInterceptRequireSuccess(
      'intval',
      self::getEchoingHandlerWithDoneAsTrue(42),
    );
    expect(\intval('43'))->toBeSame(
      43,
      'We intercepted a builtin. This shouldn\'t work. This should still be 43, but got %d',
      \intval('43'),
    );
  }

  /**
   * @spec <none>
   * @nospec This is the behavior of fb_intercept in hhvm 4.25.1
   */
  public function test_intercepting_with_an_invalid_handler_logs_a_warning_and_returns_null(
  ): void {
    self::fbInterceptRequireSuccess(self::GET_42, 'i_do_not_exist');
    expect(TestSubjects\get_42())->toBeNull();
  }

  #endregion
  #region Helpers

  private static function getEchoingHandlerWithDoneAsTrue(
    mixed $output,
  ): (function(string, mixed, varray<mixed>, mixed, bool): mixed) {
    /*HH_FIXME[2087] Reference use*/
    return ($name, $obj, $params, $data, &$done) ==> {
      $done = true;
      return $output;
    };
  }

  private static function getFalseHandlerWithDoneAsTrue(
  ): (function(string, mixed, varray<mixed>, mixed, bool): bool) {
    /*HH_FIXME[2087] Reference use*/
    return ($name, $obj, $params, $data, &$done) ==> {
      $done = true;
      return false;
    };
  }

  private static function getFalseHandlerWithDoneAsFalse(
  ): (function(string, mixed, varray<mixed>, mixed, bool): bool) {
    /*HH_FIXME[2087] Reference use*/
    return ($name, $obj, $params, $data, &$done) ==> {
      $done = false;
      return false;
    };
  }

  private static function fbIntercept(
    string $name,
    mixed $handler,
    mixed $data = null,
  ): bool {
    /*HH_IGNORE_ERROR[2049]*/
    /*HH_IGNORE_ERROR[4107]*/
    return \fb_intercept($name, $handler, $data);
  }

  private static function fbInterceptRequireSuccess(
    string $name,
    mixed $handler,
    mixed $data = null,
  ): bool {
    invariant(
      /*HH_IGNORE_ERROR[2049]*/
      /*HH_IGNORE_ERROR[4107]*/
      \fb_intercept($name, $handler, $data),
      'fb_intercept did not register',
    );
    return true;
  }

  #endregion
}
