FactoryGirl.define do
  factory :author, aliases: [:maintainer] do
    name "John Doe"
    sequence(:email, 1000) { |n| "john#{n}@snarf.com" }
  end

  factory :r_package do
    name "Snarf"
  end

  factory :version do
    number "12345"
    r_package
  end

  factory :author_committer, :class => :version_committer do
    author
    version
    role "author"
  end

  factory :maintainer_committer, :class => :version_committer do
    maintainer
    version
    role "maintainer"
  end

  factory :owner_committer, :class => :version_committer do
    author
    version
    role "all"
  end
end