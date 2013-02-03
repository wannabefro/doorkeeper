require 'spec_helper'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string'
require 'doorkeeper/oauth/scopes'

describe Doorkeeper::OAuth::Scopes do
  def scope(string)
    described_class.parse string
  end

  it 'accepts symbols' do
    subject.add :public
    subject.all.should == [:public]
  end

  it 'accepts strings' do
    subject.add "public"
    subject.all.should == [:public]
  end

  it 'are unique' do
    subject.add :public
    subject.add :public
    subject.all.should == [:public]
  end

  describe :exists? do
    before do
      subject.add :public
    end

    it 'is true when scope is present' do
      subject.exists?("public").should be_true
    end

    it 'is false when scope is not present' do
      subject.exists?("other").should be_false
    end

    it 'accepts symbols as arguments' do
      subject.exists?(:public).should be_true
      subject.exists?(:other).should be_false
    end
  end

  describe '.parse' do
    it 'parses strings' do
      scope = scope "public write"
      scope.should == [:public, :write]
    end

    it 'parses arrays' do
      scope = described_class.parse [:public, :write]
      scope.should == [:public, :write]
    end
  end

  describe :+ do
    it 'adds two scopes' do
      scopes = scope("public") + scope("admin")
      scopes.all.should == [:public, :admin]
    end

    it 'returns a new object' do
      origin    = scope("public")
      new_scope = origin + scope("admin")

      origin.object_id.should_not eq new_scope.object_id
    end

    it 'raises an error if cannot handle addition' do
      expect {
        scope('public') + 'admin'
      }.to raise_error(NoMethodError)
    end
  end

  describe :== do
    it 'is equal to another set of scopes' do
      scope("public").should == scope("public")
    end

    it 'is equal to another set of scopes with no particular order' do
      scope("public write").should == scope("write public")
    end

    it 'differs from another set of scopes when scopes are not the same' do
      scope("public write").should_not == scope("write")
    end
  end

  describe :has_scopes? do
    subject { scope("public admin") }

    it "is true when at least one scope is included" do
      subject.has_scopes?(scope("public")).should be_true
    end

    it "is true when all scopes are included" do
      subject.has_scopes?(scope("public admin")).should be_true
    end

    it "is true if all scopes are included in any order" do
      subject.has_scopes?(scope("admin public")).should be_true
    end

    it "is false if no scopes are included" do
      subject.has_scopes?(scope("notexistent")).should be_false
    end

    it "is false when any scope is not included" do
      subject.has_scopes?(scope("public nope")).should be_false
    end

    it "is false if no scopes are included even for existing ones" do
      subject.has_scopes?(scope("public admin notexistent")).should be_false
    end
  end
end
