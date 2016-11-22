# FlexiblePermissions

*At the moment this gem is tied to ActiveRecord but it's easy to change that
by overriding default permitted methods for fields and resource*

For building APIs (and not only) I have been using Pundit gem for years.
It's an awesome gem.
However there is a tiny issue: Pundit has a black and white policy whereas in
APIs usually you need a grayscale. The user might have access to a specific
resource/action, only in certain attributes of that resource.

An explanation can be found in some parts of this presentation.

## So what this gem does?
This gem allows you to specify in an easy way the following properties of a resource
based on the user role:

* default attributes of a resource
* permitted attributes of a resource (superset of default attributes)
* default associations of resource
* permitted associations of resource

You filter the associations based on the name of the association found.
However the gem provides you an easy way to map any attributes/associations to
the ones you have defined in your API/serializer.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flexible_permissions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flexible_permissions

## Usage

So let's say that we have a `User` resource in our API that we want to allow
different representations based on the current user role: Guest user,
Regular user and Admin user.

Here is how a pundit policy looks like:

```ruby
class UserPolicy < ApplicationPolicy
  def create?
    return Regular.new(record)
  end

  def show?
    return Guest.new(record) unless user
    return Admin.new(record) if user.admin?
    return Regular.new(record)
  end

  def update?
    raise Pundit::NotAuthorizedError unless user
    return Admin.new(record) if user.admin?
    return Regular.new(record)
  end

  def destroy?
    raise Pundit::NotAuthorizedError unless user
    return Admin.new(record) if user.admin?
    return Regular.new(record)
  end

  class Scope < Scope
    def resolve
      return Guest.new(record, User) unless user
      return Admin.new(scope, User) if user.admin?
      return Regular.new(scope, User)
    end
  end

  #admin has access to everything, plus, some extra fields
  class Admin < FlexiblePermissions::Base
    class Fields < self::Fields
      def permitted
        super + [
          :links, :following_state, :follower_state
        ]
      end
    end

    class Includes < self::Includes
      def transformations
        {following: :followings}
      end
    end
  end

  #we chop fields for regular user
  class Regular < Admin
    class Fields < self::Fields
      def permitted
        super - [
          :activated, :activated_at, :activation_digest, :admin,
          :password_digest, :remember_digest, :reset_digest, :reset_sent_at,
          :token, :updated_at,
        ]
      end
    end
  end

  #and we chop even more for an admin
  class Guest < Regular
    class Fields < self::Fields
      def permitted
        super - [:following_state, :follower_state]
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/flexible_permissions. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
