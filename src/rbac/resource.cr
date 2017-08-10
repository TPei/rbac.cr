module Rbac
  module Resource
    getter roles

    @roles = [] of Symbol

    # add allowed roles
    # ```
    # s = Store.new # includes Resource
    # s.has_roles :add, :delete
    # ```
    def has_roles(*_roles : Symbol)
      @roles += _roles.to_a
      @roles.uniq!
    end

    # add allowed roles
    # ```
    # s = Store.new # includes Resource
    # s.has_roles [:add, :delete]
    # ```
    def has_roles(roles : Array(Symbol))
      @roles += roles
      @roles.uniq!
    end

    # check if a resource has a specific role
    # ```
    # s = Store.new # includes Resource
    # s.has_roles :add, :delete
    # s.has_role? :add # => true
    # ```
    def has_role?(role : Symbol)
      @roles.includes? role
    end

    # check if a Roleable has any of the roles that the resource has
    # ```
    # s = Store.new # includes Resource
    # s.has_roles :add, :delete
    #
    # u = User.new # includes Roleable
    # u.has_roles :add, :edit
    #
    # s.authorized?(u) # => true because of :add
    # ```
    def authorized?(roleable : Roleable)
      roles - roleable.roles != roles
    end

    # check if a Roleable has a specific role that the resource has
    # ```
    # s = Store.new # includes Resource
    # s.has_roles :add, :delete
    #
    # u = User.new # includes Roleable
    # u.has_roles :add, :edit
    #
    # s.may?(u, :add) # => true
    # s.may?(u, :delete) # => false
    # s.may?(u, :edit) # => false because store does not include :edit role
    #
    # # check multiple rows at once:
    # s.may?(u, :add, :delete) # => false
    # ```
    def may?(roleable : Roleable, *_roles : Symbol)
      _roles.each do |role|
        if(!has_role?(role) || !roleable.has_role?(role))
          return false
        end
      end
      return true
    end
  end
end
