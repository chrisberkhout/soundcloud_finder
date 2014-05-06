# SoundCloud logo finder

Finds string of digits of π which match a reference image of the SoundCloud
logo, as described in the [Berlin Buzzwords 2014 competition](https://developers.soundcloud.com/blog/buzzwords-contest).

## Running it

First download the π dataset:

    wget http://stuff.mit.edu/afs/sipb/contrib/pi/pi-billion.txt

Then run the script (and wait):

    time ./find.rb

## Approach

To compare a given sequence against the reference image, I treat them as
vectors, normalize them and take their dot product. Results closer to 1
are an indicator of similarity.

I compare the reference image with all 84 digit sequences in the dataset.

Note that I use an offset, not a position number (in 3.14, the 4 has offset 1
from the first position after the decimal point).

## Initial results

The first run took about 18 hours, and produced these results:

    rank score              sequence                                                                             offset
    ---- ------------------ ------------------------------------------------------------------------------------ ---------
       1 0.9018471816515615 212021479960265330123798820231693768599316147634474729776147987653958935291919768971 972165009
       2 0.8956365329645389 142204297650171312983445842322141909755200787408739757838589593329762648444919386594 789652973
       3 0.8917083816019378 000053743536020032496985553181128909983810344939134894807349584729687746183109884672 981165565
       4 0.8906804210240471 082201638940102393659252475011295776958920282336494898427768768699465405437965994582 297640118
       5 0.8905080641864346 550102559883030032554777740311168209788431215087224778318624465588678712221754465965 631227821
       6 0.8898532149254554 332452589481104338097947650120327619888771199667178684846769749795766452942814660495 284697015
       7 0.8892122810762422 510156458661130607192979267020226915882203362539599684666929466072856307246449876945 702340520
       8 0.8878272558991023 354620487514105418474764560050385320664841325748344878716574596189588307694738854864 488773100
       9 0.8875721008625794 302321259572523301981596224941484528858538242826488993452527976746746718372576656991 273959857
      10 0.8873664118765552 130019949965424134524366868405264468588833190509687699654959636496916755646763968671 509863835

    real    1092m22.071s
    user    1089m25.117s
    sys     4m14.717s

## Improvements

The code is rough and could be refactored for readability.

The results could be visualized by generating an HTML report.

To improve performance without changing the general approach, the following
steps could be taken:

* In calculating the norm of the new vector, the squares could be retained and
  the previous sum adjusted to only subtract the outgoing digit's square and
  add the incoming digit's square before taking the square root.

* Rather than resorting the list of top matches on each run, a minimum score
  could be tracked, so that worse results can be disregarded with a single
  comparison. Alternatively, a larger, unsorted list of matches could be
  maintained and only sorted and pruned occasionally.

* Determine whether the dot product of the non-normalized vectors could provide
  a useful comparison score.

To improve the quality of the matches and/or shorten the search time, other
image comparison methods could be implemented.

