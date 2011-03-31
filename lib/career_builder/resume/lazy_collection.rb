module CareerBuilder

  class Resume::LazyCollection

    attr_reader :search_options, :client

    def initialize(client, options)
      @client = client
      @search_options = options
    end

    def each
      current_page = search_options[:page] || 1

      search = client.advanced_resume_search(search_options.merge(:page_number => current_page, :rows_per_page => 500))

      results = search.results

      loop do
        results.each do |resume|
          yield Resume.new(client, resume)
        end

        current_page += 1

        search = client.advanced_resume_search(search_options.merge(:page_number => current_page, :rows_per_page => 500))
        results = search.results
        break if results.empty?
      end
    end

  end

end
