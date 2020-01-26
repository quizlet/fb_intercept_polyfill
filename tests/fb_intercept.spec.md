#### This is a copy from the documentation as of Decomber 2019 with a few changes to improve readbility

[Documentation](https://docs.hhvm.com/hack/reference/function/fb_intercept/)

# fb_intercept

Invokes a user handler upon calling a function or a class method

```
function fb_intercept(
  string $name,
  mixed $handler,
  mixed $data = NULL,
): bool;
```

If this handler returns `FALSE`, code will continue with original function.
Otherwise, it will return what handler tells.
The handler function looks like "`intercept_handler($name, $obj, $params, $data, &$done)`", where

-   `\$name` is original function's fully-qualified name ('`Class::method`'),
-   `$obj` is `$this` for an instance method call or `null` for static method call or function calls.
-   `\$params` are original call's parameters.
-   `$data` is what's passed to `fb_intercept()`
-   set `$done` to `false` to indicate function should continue its execution with old function as if interception did not happen.

By default `$done` is `true` so it will return handler's return immediately without executing old function's code.
Note that built-in functions are not interceptable.

## Parameters

-   string `\$name` - The function or class method name to intercept. Use "`class::method`" for name. If empty, all functions will be intercepted by the specified handler and individual handlers will be replaced. To make sure individual handlers not affected by such call, call `fb_intercept()` with individual names afterwards.

-   mixed `\$handler` - Callback to handle the interception. Use `null`, `false` or empty string `""` unregister a previously registered handler. If name is empty, all previously handlers, including those that are set by individual function names, will be removed.

-   mixed `\$data` = `NULL` - Extra data to pass to the handler when intercepting

## Returns

`bool` - - `TRUE` if successful, `FALSE` otherwise
