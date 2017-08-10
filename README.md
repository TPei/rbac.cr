# rbac.cr
[![Build Status](https://travis-ci.org/TPei/rbac.cr.svg?branch=master)](https://travis-ci.org/TPei/rbac.cr)
[![Release](https://img.shields.io/github/release/tpei/rbac.cr.svg)](https://github.com/TPei/rbac.cr/releases)
[![MIT](https://badges.frapsoft.com/os/mit/mit.png?v=103)](https://github.com/TPei/rbac.cr/blob/master/LICENSE)
[![Docs](https://img.shields.io/badge/docs-lastest-brightgreen.svg)](https://tpei.github.io/rbac.cr)

rbac.cr provides simple role based access control for crystal programs

## Installation


Add to your shard.yml

```yaml
dependencies:
  rbac.cr:
    github: tpei/rbac.cr
    branch: master
```

and then install the library into your project with

```bash
$ crystal deps
```

## Usage

rbac.cr come with two basic modules

- `Rbac::Resource`: for which access is required
- `Rbac::Roleable`: for instances that can be given access to resources

Consider the following simple example:
```crystal
# a DataStore that has different access levels
class DataStore
  include Rbac::Resource
end

# a User that can also have different access levels
class User
  include Rbac::Roleable
end

# create a DataStore and add access levels
ds = DataStore.new
ds.has_roles :add, :edit, :delete
ds.roles # => [:add, :edit, :delete]
ds.has_role? :add # => true
ds.has_role? :read # => false

# create users with different access levels
admin = User.new
admin.has_roles ds.roles

author = User.new
author.has_roles :add, :edit

editor = User.new
editor.has_roles :edit

impotent = User.new
impotent.has_roles :read

# now you can simply check if a user has any of the resource rights
ds.authorized? author # => true
ds.authorized? impotent # => false

ds.may?(admin, :delete) # => true
ds.may?(editor, :add) # => false

```


## Contributing

1. Fork it ( https://github.com/[your-github-name]/rbac/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[tpei]](https://github.com/[tpei]) TPei - creator, maintainer
