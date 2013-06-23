MetricAdapter
==============

There are a [ton of static analyzers for ruby](http://xkcd.com/927/), each providing different insightful metrics.  What do you do when you want to use more than one of them? Each analyzer takes a different configuration, and provides results in different formats.  MetricAdapter solves the latter problem by converting the results of each analyzer into a common format.

Now you can take all of these wonderful libraries and combine their results without worrying about how they internally represent their metrics.

Supported Libraries 
-------------------

* Flay – Code duplication
* Flog – Code complexity
* Reek – Code smells

Metrics
-------
Each metric represents a single statement about one line of code.  Flay for instance, generates reports that looks like this:

    1) IDENTICAL code found in :lasgn (mass*2 = 24)
      lib/adapters/flay_adapter.rb:26
      lib/adapters/flog_adapter.rb:23

In this case, two metrics would be generated, one per line.  This makes it easier to annotate source files, or integrate these libraries with your favorite editor (`sed`, I kid, I kid).

Contributing
------------
Please do!  Take a look at the existing adapters (`lib/adapters`) for examples.

---

[Adam Sanderson](http://monkeyandcrow.com)