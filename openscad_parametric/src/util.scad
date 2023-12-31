/**
 * Function: _reduce_do()
 * Description:
 *   Internal recursive function that applies a function to each element of a list,
 *   accumulating the results into a single value.
 * Usage: reduce(list, fn, acc, start, end);
 * Arguments:
 *   list = A list to reduce to a single value.
 *   fn = A function acceping  accumulated value and nex value from the list and returng new accumulated value.
 *   acc = Accumulated value.
 *   start = An index of the array to start processing from.
 *   acc = An index of the array to end processing at.
 */
function _reduce_do(list, fn, acc, start, end) =
  start >= end ? acc : _reduce_do(list, fn, fn(acc, list[start]), start+1, end);

/**
 * Function: reduce()
 * Description: Applies a function to each element of a list, accumulating the results into a single value.
 * Usage: reduce(list, fn, [acc=]);
 * Arguments:
 *   list = A list to reduce to a single value.
 *   fn = A function acceping  accumulated value and nex value from the list and returng new accumulated value.
 *   acc = Initial accumulated value. Default: 0
 */
function reduce(list, fn, acc=0) =
  assert(is_list(list), "List required.")
  _reduce_do(list, fn, acc, 0, len(list));

/**
 * Function: is_in()
 * Description: Returns whether the searched element is present in the given list.
 * Usage: repeat(needle, haystack);
 * Arguments:
 *   needle = The element to search the list for.
 *   n = The list to search the element in.
 */
function is_in(needle, haystack) =
  assert(is_list(haystack), "Haystack is not a list.")
  reduce(
    haystack,
    function (acc, value) acc || value == needle,
    false
  );

/**
 * Function: repeat()
 * Description: Returns a list generated by repeating the given element.
 * Usage: repeat(element, n);
 * Arguments:
 *   element = The element to fill the generated list with.
 *   n = Length of the generated list.
 */
function repeat(element, n) = [ for (i = [0:n-1]) element ];
