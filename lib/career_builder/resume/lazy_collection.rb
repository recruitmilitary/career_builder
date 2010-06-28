module CareerBuilder

  class Resume::LazyCollection

    attr_reader :search_options, :client

    def initialize(options)
      @client = options.delete(:client)
      @search_options = options
    end

    def each
      current_page = search_options[:page] || 1

      search = client.advanced_resume_search(search_options.merge(:page => current_page))

      results = search.results
      hits = search.hits
      max_page = search.max_page

      loop do

        results.each do |resume|
          yield resume
        end

        current_page += 1

        break if current_page > max_page

        search = client.advanced_resume_search(search_options.merge(:page => current_page))
        results = search.results

      end
    end

  end

end
