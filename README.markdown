MetricAdapter
==============

There are a [ton of static analyzers for ruby](http://xkcd.com/927/), each providing different insightful metrics.  What do you do when you want to use more than one of them? Each analyzer takes a different configuration, and provides results in different formats.  MetricAdapter solves the latter problem by converting the results of each analyzer into a common format.

Now you can take all of these wonderful libraries and combine their results without worrying about how they internally represent their metrics.

Metrics
-------
Each metric represents a single statement about one line of code.  Flay for instance, generates reports that looks like this:

    1) IDENTICAL code found in :lasgn (mass*2 = 24)
      lib/adapters/flay_adapter.rb:26
      lib/adapters/flog_adapter.rb:23

In this case, two metrics would be generated, one per line.  This makes it easier to annotate source files, or integrate these libraries with your favorite editor (`sed`, I kid, I know we all use `notepad` these days).

Each metric contains:

* Metric#location – An object representing a file path and line number
* Metric#signature – The associated method signature (_not all metrics currently have this_)
* Metric#message – A message explaining the metric, for instance "Has no descriptive comment"
* Metric#score – When applicable, a numeric score or rating indicating the severity

Examples
--------
To get normalized metrics, instantiate the static analysis library of your choice, and pass it to the appropriate adapter:
    
    # Instantiate and configure your analyzer
    flay = Flay.new :mass => 4 
    flay.process(*files)
    flay.analyze
    
    # Report on the adapted metrics
    adapter = MetricAdapter::FlayAdapter.new(flay)
    adapter.metrics.each do |m|
      puts "#{m.location} - #{m.message}"
    end

For a full example, see `examples/report.rb`.

Supported Libraries 
-------------------

* Flay – Code duplication
* Flog – Code complexity
* Reek – Code smells


Contributing
------------
Please do!  Take a look at the existing adapters and tests (`lib/adapters` and `test/*_adapter_test.rb`) for examples.

---

[Adam Sanderson](http://monkeyandcrow.com)