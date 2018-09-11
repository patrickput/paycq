module Testdata

    GIST_RUBY = {
        "description": "Hello World Example Ruby",
        "public": true,
        "files": {
            "hello_world.rb": {
                "content": "class HelloWorld\n   def initialize(name)\n      @name = name.capitalize\n   end\n   def sayHi\n      puts \"Hello !\"\n   end\nend\n\nhello = HelloWorld.new(\"World\")\nhello.sayHi"
            },
            "hello_world_ruby.txt": {
                "content": "Run `ruby hello_world.rb` to print Hello World"
            }
        }
    }

    GIST_RUBY_CHANGED = {
        "description": "Hello World Example Ruby 2",
        "files": {
            "hello_world.rb": nil,
            "hello_world2.rb": {
                "content": "class HelloWorld\n   def initialize(name)\n      @name = name.capitalize\n   end\n   def sayHi\n      puts \"Hello !\"\n   end\nend\n\nhello = HelloWorld.new(\"World 2\")\nhello.sayHi",
            },
            "hello_world_ruby.txt": {
                "content": "Run `ruby hello_world2.rb` to print Hello World 2",
                "filename": "hello_world_ruby.txt"
            }
        }
    }

    GIST_PYTHON = {
        "description": "Hello World Example Python",
        "public": true,
        "files": {
            "hello_world.py": {
                "content": "class HelloWorld:\n\n    def __init__(self, name):\n        self.name = name.capitalize()\n       \n    def sayHi(self):\n        print \"Hello \" + self.name + \"!\"\n\nhello = HelloWorld(\"world\")\nhello.sayHi()"
            },
            "hello_world_python.txt": {
                "content": "Run `python hello_world.py` to print Hello World"
            }
        }
    }

    GIST_INVALID = {
        "unexpected_field": "Hello World Example Python",
        "public": true,
        "filez": {
            "hello_world.py": {
                "content": "class HelloWorld:\n\n    def __init__(self, name):\n        self.name = name.capitalize()\n       \n    def sayHi(self):\n        print \"Hello \" + self.name + \"!\"\n\nhello = HelloWorld(\"world\")\nhello.sayHi()"
            },
            "hello_world_python.txt": {
                "content": "Run `python hello_world.py` to print Hello World"
            }
        }
    }

end