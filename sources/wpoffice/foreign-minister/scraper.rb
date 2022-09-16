#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'See also')]]//preceding-sibling::ul[1]//li")
  end

  class Officeholder < OfficeholderNonTableBase
    def item
      noko.css('a/@wikidata').last
    end

    def itemLabel
      noko.css('a').first.text.tidy
    end

    def raw_combo_date
      years = noko.text.split(':').first
      years =~ /^\d{4}$/ ? "#{years} - #{years}" : years
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
