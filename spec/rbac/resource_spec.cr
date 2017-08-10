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

  describe "may?" do
    it "checks if a roleable has a specific role" do
      u = User.new
      u.has_roles :add, :edit

      s = Store.new
      s.has_roles :add, :delete

      s.may?(u, :add).should eq true
      s.may?(u, :delete).should eq false
      s.may?(u, :edit).should eq false
    end
  end
end

class Store
  include Rbac::Resource
end

class User
  include Rbac::Roleable
end
