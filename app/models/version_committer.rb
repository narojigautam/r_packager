class VersionCommitter < ActiveRecord::Base
  belongs_to :author, -> { where "version_committers.role in ('author', 'all')" }
  belongs_to :version
  belongs_to :maintainer, -> { where "version_committers.role in ('maintainer', 'all')" },
    class_name: "Author", foreign_key: :author_id

  @@valid_roles = [:author, :maintainer, :all]
end
