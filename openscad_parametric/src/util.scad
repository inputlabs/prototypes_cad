function _reduce_do(list, fn, acc, start, end) =
  start >= end ? acc : _reduce_do(list, fn, fn(acc, list[start]), start+1, end);

function reduce(list, fn, acc=0) =
  assert(is_list(list), "List required.")
  _reduce_do(list, fn, acc, 0, len(list));

function is_in(needle, haystack) =
  assert(is_list(haystack), "Haystack is not a list.")
  reduce(
    haystack,
    function (acc, value) acc || value == needle,
    false
  );
  