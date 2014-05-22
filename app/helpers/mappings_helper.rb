module MappingsHelper

  ##
  # Twitter bootstrap-flavour tabs.
  # Produce a <ul class="nav nav-tabs">
  # with list items with links in them.
  # e.g.
  #
  #   +bootstrap_flavour_tabs(
  #      {
  #        'Edit'    => edit_path,
  #        'History' => history_path
  #      }, active: 'Edit'
  #    )
  def bootstrap_flavour_tabs(titles_to_links, options)
    content_tag :ul, class: 'nav nav-tabs' do
      titles_to_links.inject('') do |result, title_link|
        title, href       = title_link[0], title_link[1]
        active            = options[:active] == title
        html_opts         = {}
        html_opts[:class] = 'active' if active

        result << content_tag(:li, html_opts) do
          link_to(title, active ? '#' : href)
        end
      end.html_safe
    end
  end

  ##
  # Tabs for mapping editing
  def mapping_edit_tabs(options = {})
    if @mapping.versions.any?
      content_tag :div, class: 'add-bottom-margin' do
        bootstrap_flavour_tabs(
          {
            'Edit'    => edit_site_mapping_path(@mapping.site, @mapping),
            'History' => site_mapping_versions_path(@mapping.site, @mapping)
          },
          options)
      end
    end
  end

  ##
  # Return a FormBuilder-compatible list of mapping types
  # e.g. [['Redirect', 'redirect'], ['Archive', 'archive']]
  def options_for_supported_types
    Mapping::SUPPORTED_TYPES.map do |type|
      ["#{type.titleize}", type]
    end
  end

  SUPPORTED_OPERATIONS = ['tag'] + Mapping::SUPPORTED_TYPES
  ##
  # Convert 'redirect'/'archive'/'tag' into 'Redirect'/'Archive'/'Tag'
  # to use in title and heading for edit_multiple
  def operation_name(operation)
    operation.titleize if SUPPORTED_OPERATIONS.include?(operation)
  end

  def friendly_hit_count(hit_count)
    hit_count ? number_with_delimiter(hit_count) : '0'
  end

  def friendly_hit_percentage(hit_percentage)
    case
      when hit_percentage.zero?  then ''
      when hit_percentage < 0.01 then '< 0.01%'
      when hit_percentage < 10.0 then hit_percentage.round(2).to_s + '%'
      else hit_percentage.round(1).to_s + '%'
    end
  end

  def show_preview_links?
    @site.default_host.aka_host &&
      @site.default_host.aka_host.redirected_by_gds? &&
      @site.hosts.excluding_aka.none?(&:redirected_by_gds?)
  end

  def side_by_side_url(site, mapping=nil)
    url = "http://#{site.default_host.hostname}.side-by-side.alphagov.co.uk/__/#"
    url << mapping.path if mapping
    url
  end

end
