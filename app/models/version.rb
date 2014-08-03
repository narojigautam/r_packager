# The Version class mainatians R Package Versions. It also assocites with Authors and Maintainers
# A Version can have only one Author and many Maintainers.
#
class Version < ActiveRecord::Base
  belongs_to :r_package
  has_one :author_committer, -> { where "version_committers.role in ('author', 'all')" },
    class_name: "VersionCommitter"
  has_one :author, through: :author_committer
  has_many :maintainer_committers, -> { where "version_committers.role in ('maintainer', 'all')" },
    class_name: "VersionCommitter"
  has_many :maintainers, through: :maintainer_committers

  validates_presence_of :r_package_id, :number

  def package_name
    r_package.name
  end

  def set_author author_hash
    return unless author_hash[:email].present?
    v_author = Author.find_or_create_by email: author_hash[:email]
    v_author.update(author_hash)
    return if author == v_author
    if author_committer.present?
      author_committer.update(author_id: v_author.id) and return
    end
    maintainer_committer = maintainer_committers.find_by(author_id: v_author.id, role: "maintainer")
    if maintainer_committer
      maintainer_committer.update(role: "all")
    else
      VersionCommitter.create(version_id: id, author_id: v_author.id, role: "author")
    end
  end

  def add_maintainer maintainer_hash
    return unless maintainer_hash[:email].present?
    v_maintainer = Author.find_or_create_by email: maintainer_hash[:email]
    v_maintainer.update(maintainer_hash)
    return if maintainers.include?(v_maintainer)
    if author_committer and author_committer.author_id == v_maintainer.id
      author_committer.update(role: "all")
    else
      VersionCommitter.create(version_id: id, author_id: v_maintainer.id, role: "maintainer")
    end
  end

  def author_identity
    author.identity if author
  end

  def maintainers_details
    maintainers.map{|maintainer| maintainer.identity }.join(", ")
  end
end
