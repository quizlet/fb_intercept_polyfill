# fb_intercept_polyfill
A polyfill for using fb_intercept across hhvm 3.24 -> 4.present

Why _you_ don't need this polyfill.
The polyfill bridges the gap between a hhvm that understands `inout` without being in the transition period for `&$references` and one that doesn't understand `&$references`.
The `HH\Lib\Ref<T>` is a class does not require runtime support, so it can be used as a mediator.
If your hhvm is not in the transition period for `&$references`, but it does have `HH\Lib\Ref<T>` support, you may want to use this polyfill.

### Limitations

`fb_intercept()` is a built-in function.
This gives it the superpower that it can't be intercepted itself.
The polyfill is userland code, so it can be intercepted.
Therefore you can't use the catchall interceptor key `''` (empty string),
since you would be intercepting calls to the polyfill itself.
This makes it impossible to call `fb_intercept()` after that.
The polyfill will throw if you pass it the catchall key, telling you that this is not supported.
If you intercept the polyfill by name intentionally, you'll not be able to restore it.
So don't do that. :wink:
