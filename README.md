# What is this?

A test of how functional composition would work in a data pipeline. Mainly 
just to see how the affordances feel.

# Conclusion

It wasn't nearly as easy as I remembered it to be. Though it was a simple 
linear pipeline, it took a bunch of fumbling to get
it all plugged up and correct. I think the model in Airflow and Rake works
better, where you just specify who the parents are. 

However, just specifying parents, while easy to get up and running, won't help
people write correct systems, especially if they want it distributed.

I think while we'll give people enough rope to hang themselves to get up
and running quickly, we won't guarantee their problem will be correct unless
they have certain rules and fences.

Some of these that come to mind are:

- type enforcement between stages in the pipeline.
- pure functional stages in order to sign the data structures
- functional composition to make parallelism easier
- operations that are associative, commutative, and idempotent to be usable in a bloom lattice