require "./../spec_helper"

describe Rbac::Resource do
  describe "#has_roles" do
    it "sets roles for a resource" do
      roles = {:add, :edit}

      s = Store.new
      s.has_roles *roles
      s.roles.should eq roles.to_a
    end

    it "allows setting via array as well" do
      roles = [:add, :edit]

      s = Store.new
      s.has_roles roles
      s.roles.should eq roles.to_a
    end

    it "does not have role duplicates" do
      roles = {:add, :edit}

      s = Store.new
      s.has_roles *roles
      s.has_roles *roles
      s.has_roles :add
      s.roles.should eq roles.to_a
    end
  end

  describe "#roles" do
    it "returns a resources roles" do
      roles = {:add, :edit}

      s = Store.new
      s.has_roles *roles
      s.roles.should eq roles.to_a
    end
  end

  describe "#has_role?" do
    it "checks if an resource has a specific role" do
      roles = {:add, :edit}

      s = Store.new
      s.has_roles *roles
      s.has_role?(:add).should eq true
      s.has_role?(:delete).should eq false
      Store.new.has_role?(:add).should eq false
    end
  end

  describe "authorized?" do
    it "checks if a roleable has any matching roles" do
      u = User.new
      u.has_roles :add, :edit

      s = Store.new
      s.has_roles :add, :delete

      s.authorized?(u).should eq true

      s2 = Store.new
      s2.has_roles :delete, :destroy

      s2.authorized?(u).should eq false
    end
  end

  describe "authorized?(Roleable, *Symbol)" do
    it "checks if a roleable has a specific role" do
      u = User.new
      u.has_roles :add, :edit

      s = Store.new
      s.has_roles :add, :delete

      s.authorized?(u, :add).should eq true
      s.authorized?(u, :delete).should eq false
      s.authorized?(u, :edit).should eq false
    end

    it "can be handed in multiple rows and checks that a roleable has all of them" do
      u = User.new
      u.has_roles :add, :edit, :delete

      s = Store.new
      s.has_roles :add, :delete, :swag

      s.authorized?(u, :add, :delete).should eq true
      s.authorized?(u, :add, :edit).should eq false # u has no :edit
      s.authorized?(u, :add, :swag).should eq false # s hash no :swag
    end
  end

  describe "may?" do
    it "calls authorized?(Roleable, *Symbol)" do
      u = User.new
      u.has_roles :add, :edit

      s = Store.new
      s.has_roles :add, :delete

      s.may?(u, :add).should eq s.authorized?(u, :add)
      s.may?(u, :delete).should eq s.authorized?(u, :delete)
      s.may?(u, :edit, :delete).should eq s.authorized?(u, :edit, :delete)
    end
  end
end

class Store
  include Rbac::Resource
end

class User
  include Rbac::Roleable
end
