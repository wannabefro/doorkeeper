require 'spec_helper'
require 'active_support/core_ext/object/blank'
require 'doorkeeper/models/revocable'

describe 'Revocable' do
  subject do
    Class.new do
      include Doorkeeper::Models::Revocable
      attr_accessor :revoked_at
    end.new
  end

  describe :revoke do
    it "updates :revoked_at attribute with current time" do
      subject.revoke
      subject.revoked_at.should_not be_nil
    end
  end

  describe :revoked? do
    it "is revoked if :revoked_at is set" do
      subject.stub :revoked_at => stub
      subject.should be_revoked
    end

    it "is not revoked if :revoked_at is not set" do
      subject.stub :revoked_at => nil
      subject.should_not be_revoked
    end
  end
end
