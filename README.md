# CareerBuilder

Ruby wrapper for the [CareerBuilder V2 HTTP XML API](http://ws.careerbuilder.com/schemas/).  While the CareerBuilder::Client mimics the interface of the HTTP API, it also provides some convenience methods to make your life easier.

**NOTE** currently only the resume portion of the API is implemented, others are a work in progress.

## Installation

    gem install career_builder

## Usage

    require 'career_builder'

### Authenticate

    client = CareerBuilder.new('your_email', 'your_password')
    session_token = client.authenticate

### Resume API

http://ws.careerbuilder.com/resumes/resumes.asmx

#### advanced_resume_search

     resumes = client.advanced_resume_search(:keywords => "Ruby",
                                             :zip_code => "45140",
                                             :search_radius_in_miles => 50)

#### get_resume

     partial_resume = resumes.first
     resume = client.get_resume(:resume_id => partial_resume.id)

#### resume_actions_remaining_today

This method requires your AccountDID, I could not find an official way to find this identifier, but I followed these steps:

1. Sign into CareerBuilder with your email / password credentials
2. Click My CareerBuilder -> My Account Info
3. Copy the AccountDID URL parameter from your address bar

    client.resume_actions_remaining_today(:account_did => "D7C10Q67ZKG123VCRMC") # => 42

### Resume Convenience Methods / Classes

fetch a lazy collection of resumes, nothing actually happens until you iterate.

    resumes = client.resumes(:keywords => "Ruby",
                             :zip_code => "45140",
                             :search_radius_in_miles => 50)

iterate through the resumes, automatically paging through the result set.

    resumes.each do |resume|
      puts resume.id
    end

resumes that are fetched from a Resume::LazyCollection are also lazy in the sense that they do not attempt to use the Client#get_resume method until you access one of the attributes that requires using an API credit.

    resume = resumes.first

Client#get_resume is not called when retrieving the id

    resume.id # => "42XXASDFJKLQWERTY"

Client#get_resume(:resume_id => "42XXASDFJKLQWERTY") is called behind the scenes in order to fetch the real email address associated with the resume.

    resume.real_contact_email # => "michael@jordan.com"

## TODO

* More / better specs
* Implement Application Web Service
* Implement Job Web Service
* Implement Accounts Web Service
* Implement Document Matching Web Service

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Michael Guterl. See LICENSE for details.
