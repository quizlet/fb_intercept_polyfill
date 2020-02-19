<?hh // strict

namespace Lexidor\FBInterceptPolyfill;

use type HH\Lib\Ref;

function fb_intercept_full(
  string $name,
  ?(function(string, mixed, varray<mixed>, mixed, Ref<bool>): mixed) $handler,
  mixed $data = null,
): bool {
  if ($handler === null || $handler === '') {
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2($name, null);
  } else {
    invariant($name !== '', 'Using the catch-all intercept is not supported');
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2($name, (
      string $name,
      mixed $obj_or_classname,
      inout varray<mixed> $params,
    ) ==> {
      if (!\is_callable($handler)) {
        \trigger_error(
          'The given handler could not be called!',
          \E_USER_WARNING,
        );
        return shape('value' => null);
      }
      $done = new Ref(true);
      $ret = $handler($name, $obj_or_classname, $params, $data, $done);
      if ($done->value) {
        return shape('value' => $ret);
      } else {
        return shape();
      }
    });
  }
}

function fb_intercept_four(
  string $name,
  ?(function(string, mixed, varray<mixed>, mixed): mixed) $handler,
  mixed $data = null,
): bool {
  if ($handler === null || $handler === '') {
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2($name, null);
  } else {
    invariant($name !== '', 'Using the catch-all intercept is not supported');
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2(
      $name,
      (string $name, mixed $obj_or_classname, inout varray<mixed> $params) ==> {
        if (!\is_callable($handler)) {
          \trigger_error(
            'The given handler could not be called!',
            \E_USER_WARNING,
          );
          return shape('value' => null);
        }
        return shape(
          'value' => $handler($name, $obj_or_classname, $params, $data),
        );
      },
    );
  }
}
function fb_intercept_three(
  string $name,
  ?(function(string, mixed, varray<mixed>): mixed) $handler,
  mixed $data = null,
): bool {
  if ($handler === null || $handler === '') {
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2($name, null);
  } else {
    invariant($name !== '', 'Using the catch-all intercept is not supported');
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2(
      $name,
      (string $name, mixed $obj_or_classname, inout varray<mixed> $params) ==> {
        if (!\is_callable($handler)) {
          \trigger_error(
            'The given handler could not be called!',
            \E_USER_WARNING,
          );
          return shape('value' => null);
        }
        return shape('value' => $handler($name, $obj_or_classname, $params));
      },
    );
  }
}

function fb_intercept_two(
  string $name,
  ?(function(string, mixed): mixed) $handler,
  mixed $data = null,
): bool {
  if ($handler === null || $handler === '') {
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2($name, null);
  } else {
    invariant($name !== '', 'Using the catch-all intercept is not supported');
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2(
      $name,
      (string $name, mixed $obj_or_classname, inout varray<mixed> $_) ==> {
        if (!\is_callable($handler)) {
          \trigger_error(
            'The given handler could not be called!',
            \E_USER_WARNING,
          );
          return shape('value' => null);
        }
        return shape('value' => $handler($name, $obj_or_classname));
      },
    );
  }
}

function fb_intercept_one(
  string $name,
  ?(function(string): mixed) $handler,
  mixed $data = null,
): bool {
  if ($handler === null || $handler === '') {
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2($name, null);
  } else {
    invariant($name !== '', 'Using the catch-all intercept is not supported');
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2(
      $name,
      (string $name, mixed $_, inout varray<mixed> $_) ==> {
        if (!\is_callable($handler)) {
          \trigger_error(
            'The given handler could not be called!',
            \E_USER_WARNING,
          );
          return shape('value' => null);
        }
        return shape('value' => $handler($name));
      },
    );
  }
}

function fb_intercept_zero(
  string $name,
  ?(function(): mixed) $handler,
  mixed $data = null,
): bool {
  if ($handler === null || $handler === '') {
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2($name, null);
  } else {
    invariant($name !== '', 'Using the catch-all intercept is not supported');
    /*HH_IGNORE_ERROR[2049] no hhi*/
		/*HH_IGNORE_ERROR[4107] no hhi*/
		return \fb_intercept2(
      $name,
      (string $a, mixed $_, inout varray<mixed> $_) ==> {
        if (!\is_callable($handler)) {
          \trigger_error(
            'The given handler could not be called!',
            \E_USER_WARNING,
          );
          return shape('value' => null);
        }
        return shape('value' => $handler());
      },
    );
  }
}
