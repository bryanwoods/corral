# Corral

![Corral](http://cl.ly/image/0Q1E2Z451v2a/corral.jpg)

Use Corral to disable certain features in your application.

### Is it any good?

[Yes](http://news.ycombinator.com/item?id=3067434)

### What was your inspiration?

I love [Paddock](https://github.com/pivotalexperimental/paddock) (for which
Corral should be a nearly drop-in replacement), but
found its Rails environment specific approach to be too concrete for my
needs. Specifically, I wanted to toggle my features on arbitrary--or
at least callable--Ruby expressions.

## Setup
Put this somewhere like: `config/initializers/corral.rb`

```ruby
include Corral

# Pass an environment to use the `in` option...
Corral.corral(Rails.env) do
  Corral.disable :torpedoes, when: -> { true }
  Corral.disable :fun_and_games, in: [:staging, :production]
  Corral.disable :cupcakes, if: ->(person) { person == "Bryan" }
end
```

("when" and "if" mean the same thing. Use whichever makes you happy.)

If you don't mind polluting your global namespace and want to more
easily refer to these methods, you can include `Corral::Helpers`

```ruby
include Corral::Helpers

corral(Rails.env) do
  disable :caching, in: [:development, :test, :staging]
  disable :crying, when: ->(user) { user.birthday == Date.today }
end
```

## Usage

```ruby
fire! if enabled?(:torpedoes)
sulk if disabled?(:cupcakes, "Bryan") # And I don't even *like* sweets!
```

## Installation

Add this line to your application's Gemfile:

    gem 'corral'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install corral

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
