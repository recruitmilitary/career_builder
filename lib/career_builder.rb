require "rubygems"
require "bundler"
Bundler.setup

require 'net/http'
require 'nokogiri'
require 'happymapper'
require 'active_support/inflector'

if RUBY_VERSION < '1.9'
  class BasicObject 
    instance_methods.each do |m| 
      undef_method(m) if m.to_s !~ /(?:^__|^nil\?$|^send$|^object_id$)/ 
    end 
  end
end

require 'career_builder/errors'
require 'career_builder/api/resume_search_result'
require 'career_builder/api/resume_search'
require 'career_builder/api/company'
require 'career_builder/api/interest'
require 'career_builder/api/job_type'
require 'career_builder/api/language'
require 'career_builder/api/location'
require 'career_builder/api/pay'
require 'career_builder/api/school'
require 'career_builder/api/shift_preference'
require 'career_builder/api/word_document'
require 'career_builder/api/resume'
require 'career_builder/resume'
require 'career_builder/resume/lazy_collection'
require 'career_builder/request'
require 'career_builder/request/authenticated'
require 'career_builder/requests/authentication'
require 'career_builder/requests/advanced_resume_search'
require 'career_builder/requests/get_resume'
require 'career_builder/requests/resume_actions_remaining_today'
require 'career_builder/client'
