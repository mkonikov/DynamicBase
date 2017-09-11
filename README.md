# DynamicBase

DynamicBase is a lightweight object-relational mapping tool built with Ruby. By creating a subclass of the `Base` class, existing tables in the database are mapped to these new classes.

Using the sample database as an example, one can retrieve the NYC attractions in the Bronx by running `Borough.first.sights`. To change a property, for example the name, one can simply type
```
bronx = Borough.first
bronx.name = 'The Bronx'
bronx.save
```

## Features
[Base](#base)
* [`::all`](#all)
* [`::first`](#first)
* [`::last`](#last)
* [`::find`](#find)
* [`::new`](#new)
* [`::save`](#save)

[Searchable](#searchable)
* [`::where`](#where)

[Associations](#associations)
* [`::belongs_to`](#belongs_to)
* [`::has_many`](#has_many)
* [`::has_one_through`](#has_one_through)

### Base
#### `all`

Will return an array of all entries in the database for the specified table.

Example: `Borough.all`

#### `first`

Will return the first database entry for the specified table (ordered by id).

Example: `Borough.first`

#### `last`

Will return the last database entry for the specified table (ordered by id).

Example: `Borough.last`

#### `find(id)`

Will return the entry in the database with the id matching the argument.

Example: `Borough.find(4)`

#### `new`

Creates a new Base object (which can be modified and then update or insert intothe database with the save method below)

Example: `Borough.new`

#### `save`

Depending on if entry exists in database, will either update or insert into database.

Example:
```
borough = Borough.new
borough.name = "Queens"
borough.save
```

### Searchable
#### `where`

Returns the results of a SQL query based on the hash parameters passed in as arguments.

Example: `Borough.where(name: "Manhattan")`

### Associations
#### `belongs_to`

Will return base object with the child associated with the selected object.

Example: `Neighborhood.first.borough`

#### `has_many`

Will return base object with the parent associated with the selected object.

Example: `Borough.first.neighborhoods`

#### `has_one_through`

Will return base object with the grandparent associated with the selected object.

Example: `Sight.first.borough`


## Demo
A sample database is included. To run simply clone this repo and open with pry or IRB with the `load 'demo/nyc.rb'` command.
