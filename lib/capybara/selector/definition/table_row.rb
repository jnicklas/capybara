# frozen_string_literal: true

Capybara.add_selector(:table_row, locator_type: [Array, Hash, Integer]) do
  xpath do |locator, headers: false, **|
    cell_type = XPath::Expression.new(:literal, headers ? :th : :td)
    cell_type = cell_type.or(:td) if headers == true

    xpath = XPath.descendant(:tr)
    if locator.is_a? Hash
      locator.reduce(xpath) do |xp, (header, cell)|
        header_xp = XPath.ancestor(:table)[1].descendant(:tr)[1].descendant(:th)[XPath.string.n.is(header)]
        cell_xp = XPath.descendant(cell_type)[
          XPath.string.n.is(cell) & header_xp.boolean & XPath.position.equals(header_xp.preceding_sibling.count.plus(1))
        ]
        xp.where(cell_xp)
      end
    elsif locator.is_a? Array
      initial_td = XPath.descendant(cell_type)[XPath.string.n.is(locator.shift)]
      tds = locator.reverse.map { |cell| XPath.following_sibling(cell_type)[XPath.string.n.is(cell)] }
                           .reduce { |xp, cell| cell.where(xp) }
      xpath[initial_td[tds]]
    elsif locator.is_a? Integer
      xpath.where(cell_type)[locator]
    else
      xpath.where(cell_type)
    end
  end
end
