Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should see the header "([^"]*)"$/) do |header_text|
  expect(page).to have_selector('h1,h2,h3,h4,h5,h6', text: header_text)
end

Then(/^I should see a table with class "([^"]*)" containing (\d+) rows?$/) do |classname, row_count|
  expect(page).to have_selector("table.#{classname} tbody tr", count: row_count)
end

Then(/^I should see a link to the URL (.*)$/) do |href|
  expect(page).to have_link('', href: href)
end

Then(/^I should see a link to the organisation (.*)$/) do |org_abbr|
  expect(page).to have_link('', href: organisation_path(org_abbr))
end

Then(/^I should see links top and bottom to page ([0-9]+)$/) do |page_number|
  expect(page).to have_link(page_number, count: 2)
end

Then(/^I should see (\d+) as the current page$/) do |page_number|
  expect(page).to have_selector('span.page.current', text: page_number)
end

Then(/^the page title should be "([^"]*)"$/) do |title|
  expect(page).to have_title(title)
end

Then(/^I should be returned to the mappings list for (.*)$/) do |site_abbr|
  expect(current_path).to eql(site_mappings_path(site_abbr))
end

Then(/^I should still be editing a mapping$/) do
  step 'I should see "Edit mapping"'
end

Then(/^I should not see "([^"]*)"$/) do |content|
  expect(page).not_to have_content(content)
end

Then(/^the filter box should contain "([^"]*)"$/) do |path|
  expect(page).to have_field('Filter by path', with: path)
end

Then(/^I should see a link to remove the filter$/) do
  expect(page).to have_link('Remove filter')
end

Then(/^I should see that (.*) is responsible for an (.*)$/) do |user_name, action|
  within '.versions' do
    expect(page).to have_selector('td', text: user_name)
    expect(page).to have_selector('td', text: action)
  end
end

Then(/^I should see no history$/) do
  expect(page).not_to have_link('History')
end

Then(/^I should see that (.*) was changed from (.*) to (.*)$/) do |field_name, old_value, new_value|
  within '.versions' do
    expect(page).to have_content(field_name)
    expect(page).to have_content(old_value)
    expect(page).to have_content(new_value)
  end
end

Then(/^I should see a link to "([^"]*)"$/) do |title|
  expect(page).to have_link(title)
end

Then(/^I should see redirect fields$/) do
  within '.js-edit-mapping-form' do
    expect(page).to have_selector('.js-for-redirect')
  end
end

Then(/^I should not see redirect fields$/) do
  within '.js-edit-mapping-form' do
    expect(page).not_to have_selector('.js-for-redirect')
  end
end

Then(/^I should see archive fields$/) do
  within '.js-edit-mapping-form' do
    expect(page).to have_selector('.js-for-archive')
  end
end

Then(/^I should not see archive fields$/) do
  within '.js-edit-mapping-form' do
    expect(page).not_to have_selector('.js-for-archive')
  end
end

Then(/^I should see links to all this organisation's sites and homepages$/) do
  @organisation.sites.each do |site|
    expect(page).to have_link('', href: site_mappings_path(site.abbr))
    expect(page).to have_link('', href: site.homepage)
  end
end

Then(/^I should see that this organisation works with its parent$/) do
  expect(page).to have_link('', href: organisation_path(@organisation.parent))
end

Then(/^I should see all hits for the Attorney General's office in descending count order$/) do
  within '.hits' do
    counts = page.all(:css, 'td.count').map { |node| node.text.to_i }

    expect(counts).to be_sorted.descending
  end
end

Then(/^I should not see hits for the Cabinet Office site$/) do
  within '.hits' do
    expect(page).to_not have_content('/cabinetoffice')
  end
end

Then(/^the hits should be aggregated by status$/) do
  within '.hits' do
    expect(page).to have_selector('tbody tr', count: 5)
    expect(page).to have_selector('tbody tr:first-child .count', text: '190')
  end
end

Then(/^the top hit should be represented by a 100% bar$/) do
  within '.hits' do
    expect(page).to have_selector('tbody tr:first-child .bar-chart-row[style*="width: 100"]')
  end
end

Then(/^subsequent hits should have smaller bars$/) do
  within '.hits' do
    expect(page).to have_selector('tbody tr:nth-child(2) .bar-chart-row[style*="width: 78.9"]')
  end
end

Then(/^each path should be a link to the real URL$/) do
  within '.hits' do
    anchors = page.all(:css, '.path a')
    expect(anchors).to have(5).links
  end
end
