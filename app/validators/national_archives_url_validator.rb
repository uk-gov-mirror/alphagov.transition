class NationalArchivesURLValidator < ActiveModel::EachValidator
  NATIONAL_ARCHIVES_HOST = 'webarchive.nationalarchives.gov.uk'

  def validate_each(record, attribute, value)
    return if value.blank?
    valid_url = begin
      uri = Addressable::URI.parse(value)
      uri.host == NATIONAL_ARCHIVES_HOST
    rescue Addressable::URI::InvalidURIError
      false
    end
    record.errors.add attribute, (options[:message] || \
      "must be on the National Archives domain, #{NATIONAL_ARCHIVES_HOST}") unless valid_url
  end
end
