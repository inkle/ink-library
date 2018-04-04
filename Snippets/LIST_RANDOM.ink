// Note: This will be very slow since it's a recursive function
// and ink isn't a very fast language! It's a strong contender for
// being implemented natively in ink.

=== function LIST_RANDOM(list) 
    { list:
        ~ return getNth(list, RANDOM(1, LIST_COUNT(list)))
    - else:
        ~ return list 
    }
 
=== function getNth(list, n) 
    { LIST_COUNT(list) > 0:
        ~ n = n mod LIST_COUNT(list)
        { n <= 0:
            ~ return LIST_MIN(list) 
        - else: 
            ~ return getNth(list - LIST_MIN(list), n - 1)
        }
    }
    