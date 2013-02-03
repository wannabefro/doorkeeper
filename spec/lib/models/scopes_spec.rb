require 'spec_helper'
require 'active_support/core_ext/module/delegation'
require 'doorkeeper/oauth/scopes'
require 'doorkeeper/models/scopes'

describe 'Doorkeeper::Models::Scopes' do
  subject do
    Class.new do
      include Doorkeeper::Models::Scopes
      attr_accessor :scope
    end.new
  end

  before do
    subject.scope = 'public admin'
  end

  describe :oauth_scope do
    it 'is a `Scopes` class' do
      subject.oauth_scope.should be_a(Doorkeeper::OAuth::Scopes)
    end

    it 'includes scopes' do
      subject.oauth_scope.should include(:public)
    end
  end
end
