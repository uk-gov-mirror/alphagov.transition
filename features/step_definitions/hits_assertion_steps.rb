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

Then(/^the hits should be grouped by path and status$/) do
  within '.hits' do
    expect(page).to have_selector('tbody tr', count: 4)
    expect(page).to have_selector('tbody tr:first-child .count', text: '300')
  end
end

Then(/^the top hit should be represented by a 100% bar$/) do
  within '.hits' do
    expect(page).to have_selector('tbody tr:first-child .bar-chart-row[style*="width: 100"]')
  end
end

Then(/^subsequent hits should have smaller bars$/) do
  within '.hits' do
    expect(page).to have_selector('tbody tr:nth-child(2) .bar-chart-row[style*="width: 66.6"]')
  end
end

Then(/^each path should be a link to the real URL$/) do
  within '.hits' do
    anchors = page.all(:css, '.path a')
    expect(anchors).to have(4).links
  end
end

Then(/^I should see a section for the most common (\w+)$/) do |category|
  expect(page).to have_selector('h2', text: category.titleize)
end

Then(/^I should see a section for the other hits, the most common miscellany$/) do
  expect(page).to have_selector('h2', text: 'Other')
end

Then(/^it should show only the top (\d+) (\w+) in descending count order$/) do |count, category|

  case category
  when "errors"
    status = 404
  when "archives"
    status = 410
  when "redirects"
    status = 301
  else
    status = 200
  end

  within ".hits-#{category}" do
    expect(page).to have_sorted_bar_rows(count).for_status(status)
  end
end

Then(/^I should see a graph representing hits data over time$/) do
  expect(page).to have_selector("svg")

  result = page.evaluate_script('rawData')
  expect(result).to eql([
    ["Date",        "All hits", "Errors", "Archives", "Redirects"],
    ["2012-10-17",  800,        200,      200,        200        ],
    ["2012-10-18",  3240,       810,      810,        810        ]
  ])
end

Then(/^I should see a trend for all hits, errors, archives and redirects$/) do
  ['#999999', '#ee9999', '#99ee99', '#aaaaaa'].each do |color|
    expect(page).to have_selector("path[stroke='#{color}']")
  end

  ['All hits', 'Errors', 'Archives', 'Redirects'].each do |category|
    expect(page).to have_svg_text(category)
  end
end

Then(/^I should see all hits with a[n]? (\w+) status for the Attorney General's office in descending count order$/) do |category|

  case category
  when "error"
    status = 404
  when "archive"
    status = 410
  when "redirect"
    status = 301
  else
    status = 200
  end

  within '.hits' do
    expect(page).to have_sorted_bar_rows(11).for_status(status)
  end
end

Then(/^each hit should have a link to check its mapping$/) do
  within '.hits tbody' do
    page.all('tr').each do |row|
      path = row.find(:css, '.path').text
      mapping = row.find(:css, '.action')
      expect(mapping).to have_link('', href: site_mapping_find_path(@site, path: path))
    end
  end
end

Then(/^I should be on the new mapping page$/) do
  step 'I should see "New mapping"'
end

Then(/^the top hit's canonicalized path should already be in the form$/) do
  expect(find_field('Path').value).to eql('/a')
end

Then(/^a[n]? (\w+) graph showing two dates and a (\w+) trend line$/) do |category, color|

  case color
  when "red"
    color = "#ee9999"
  when "green"
    color = "#99ee99"
  else
    color = "#aaaaaa"
  end

  result = page.evaluate_script('rawData')
  expect(result).to eql([["Date", category.titleize], ["2012-10-17", 200], ["2012-10-18", 810]])

  # Poltergeist doesnt correctly find content of SVG text elements
  # Use an SVG matcher instead of:
  # expect(page).to have_selector('text', text: 'Errors')

  expect(page).to have_svg_text(category.titleize)
  expect(page).to have_selector("path[stroke='#{color}']")
end
