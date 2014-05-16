module View
  module Mappings
    ##
    # Canonicalize a URL, path or substring for use as a filter.
    # Alternatively, when not canonicalizing, just ensure the filter is a
    # path or substring, not a URL.
    class CanonicalFilter
      def initialize(site, filter)
        @site     = site
        @filter   = filter || ''
      end

      def to_s
        # Canonicalisation removes trailing slashes, which in this case
        # can be an important part of the search string. Put them back.
        @canonicalized ||= if @filter.ends_with?('/')
                             canonicalized + '/'
                           else
                             canonicalized
                           end
      end

    private
      def canonicalized
        case
        when parseable_url? || path?
          @site.canonical_path(@filter)
        when url? # and not parseable
          @filter
        else
          canonical_substring
        end
      end

      def canonical_substring
        # Canonicalization requires a path. Canonicalize a substring
        # by pretending the substring is a path, then remove the leading '/'
        @site.canonical_path('/' + @filter)[1..-1]
      end

      def path?
        @filter.starts_with?('/')
      end

      def url?
        @filter =~ /^https?:\/\//
      end

      def parseable_url?
        begin
          url? && Addressable::URI.parse(@filter)
        rescue Addressable::URI::InvalidURIError
          false
        end
      end
    end

    def self.canonical_filter(site, filter)
      CanonicalFilter.new(site, filter).to_s
    end
  end
end
