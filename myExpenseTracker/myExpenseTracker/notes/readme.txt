
Notes :

here are the areas for improvements :

1.
in the connection manager class, one function should be enough.
its task is to take the link and parameters, send out the request and receive the response.
the response data should be in the JSON format.

the connection manager class should not know where or how the data is used.

2.
in the data manager class, it shouls also have one function, and shoud use the PromiseKit way.
its task is to call the function in the connection manager class, and get back the JSON data.

3.
in the processing manager class, it will have multiple functions, for different usages.
and they are all calling the data manager class.

also, can have the json manager class.  this is for parsing the JSON data into objects.
and pass them to the view controllers.

//

4.
in admin / expense report, it has the date selection

problem  : it is tight with the report generation, and is hard to reuse.
solution : re-write the date selection page.  and only send back the date string, as "year-month", or "year".

issue :
in the look up for vendor, it also needs to select a year.  and no need to have duplicated files.

the date selection class is a view displaying page.



