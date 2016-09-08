For this section, feel free to reference any material in mozilla's js documentation online.  Please do not search on stackoverflow, or old code that you submitted.

We wrote you an index.html section, so that if you do open . in the javascript folder, and then open the index.html file in chrome, you can test your code.


We want a store, which will hold our state.  Think of how we did this in the OO js section (we are not talking about redux store, nor are we putting any requirements on immutability).
We want to add the following methods to each of the classes
An all method, where each object is added upon initialization of the object
A find_by_name method for both the customer and the restaurant

Build the following methods on the following classes.

  # Customer#add_review
  # Customer#add_restaurant
  # Customer.all

  # Review#customer
  # Review#restaurant

  # Restaurant#customers
  # Restaurant#reviews

If you are not re-sketching out your domain, and thinking about single source of truth,
you are doing it wrong.
