# Org2mindmap

Welcome!

```ruby
org2mindmap = {:org => mindmap}
browser.open org2mindmap.fetch :org
```

## Demo

http://nonghao.me/demo/org2mindmap/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'org2mindmap'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install org2mindmap
    
For quick installing, try installing without documentation:

    $ gem install org2mindmap --no-rdoc --no-ri

## Usage

### Used as a library

Run irb:
    
    $ irb
    
Import Org2mindmap:

```ruby
require 'org2mindmap'
```
    
Then call:

```ruby
Org2mindmap:ConstMod.new my_org_file
```
    
More info in the API Guide(TODO)

### Generate a visual diagram

Run:
    
    $ org2mindmap org-filename
    
Open the output file named **index.html**
 
See the corresponding mind map in your browser.

### Convert to JSON format
TODO

### Convert to OPML format
TODO

## To-Do List

- More export choice
- Item status and priority support
- Date support
- Both sides expanding

## Building

If you are familiar with [RubyGem](https://rubygems.org/), you may skip this section.

Org2mindmap is a Ruby Gem project, so you can apply the method used in Gem to build it.

    $ gem build org2mindmap.gemspec

After that, you will find a .gem file named org2mindmap.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/lds56/org2mindmap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
