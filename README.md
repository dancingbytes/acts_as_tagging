Acts as tagging
======


Simple tags for rails.

### Supported environment

Ruby:   1.9.2, 1.9.3

Rails:  3.0, 3.1, 3.2

ORM:    ActiveRecord, MondgoID

### DSL example

    acts_as_tagging do

      add do |c|
        [ c.name, c.ext ] if c.source?
      end

    end # acts_as_tagging


### License

Authors: redfield (up.redfield@gmail.com), Tyralion (piliaiev@gmail.com)

Copyright (c) 2012 DansingBytes.ru, released under the BSD license