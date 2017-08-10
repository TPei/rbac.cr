require "./../spec_helper"

describe Rbac::Roleable do
  describe "#has_roles" do
    it "sets roles for a user" do
      roles = {:add, :edit}

      u = User.new
      u.has_roles *roles
      u.roles.should eq roles.to_a
    end

    it "allows setting via array as well" do
      roles = [:add, :edit]

      s = Store.new
      s.has_roles roles
      s.roles.should eq roles.to_a
    end

    it "does not have role duplicates" do
      roles = {:add, :edit}

      u = User.new
      u.has_roles *roles
      u.has_roles *roles
      u.has_roles :add
      u.roles.should eq roles.to_a
    end
  end

  describe "#roles" do
    it "returns a model instances roles" do
      roles = {:add, :edit}

      u = User.new
      u.has_roles *roles
      u.roles.should eq roles.to_a
    end
  end

  describe "#has_role?" do
    it "checks if an instance has a specific role" do
      roles = {:add, :edit}

      u = User.new
      u.has_roles *roles
      u.has_role?(:add).should eq true
      u.has_role?(:delete).should eq false
      User.new.has_role?(:add).should eq false
    end
  end
end

class User
  include Rbac::Roleable
end
