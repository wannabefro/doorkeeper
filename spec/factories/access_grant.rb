FactoryGirl.define do
  factory :access_grant, class: Doorkeeper::AccessGrant do
    sequence(:resource_owner_id) { |n| n }
    application
    redirect_uri "https://app.com/callback"
    expires_in 100
    scope "public write"
  end
end
