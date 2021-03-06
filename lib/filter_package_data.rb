module FilterPackageData
  def filter_into_version package
    {
      number: package["Version"].try(:strip),
      released_on: parse_date(package["Date"]),
      dependency: package["Depends"].try(:strip),
      lazy_data: package["LazyData"].try(:strip),
      repository: package["Repository"].try(:strip),
      publication_date: parse_date_time(package["Date/Publication"])
    }
  end

  def filter_into_package package
    {
      name: package["Package"].try(:strip),
      description: package["Description"].try(:strip),
      title: package["Title"].try(:strip),
      date_created: parse_date(package["Packaged"]),
      license: package["License"].try(:strip)
    }
  end

  def filter_into_author package_author
    name_str, email_str = package_author.split("<")
    {
      name: name_str.try(:strip),
      email: email_str.try(:tr,">",'')
    }
  end

  private

  def parse_date date_str
    Date.parse(date_str) if date_str.present?
  rescue => error
    if error.class == ArgumentError and error.message == "invalid date"
      Rails.logger.warn "#{error.class.to_s}: #{error.message}"
    else
      raise error
    end
    return # to return nil
  end

  def parse_date_time date_time_str
    DateTime.parse(date_time_str) if date_time_str.present?
  end
end