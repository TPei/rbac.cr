module Rbac
  module Roleable
    getter roles

    @roles = [] of Symbol

    # add allowed roles
    # ```
    # u = User.new # includes Roleable
    # u.has_roles :add, :delete
    # ```
    def has_roles(*_roles : Symbol)
      @roles += _roles.to_a
      @roles.uniq!
    end

    # check if a accessor has a specific role
    # ```
    # u = User..new # includes Roleable
    # u.has_roles :add, :delete
    # u.has_role? :add # => true
    # ```
    def has_role?(role : Symbol)
      @roles.includes? role
    end
  end
end
