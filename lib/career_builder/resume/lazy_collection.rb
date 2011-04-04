module CareerBuilder

  class Resume::LazyCollection

    attr_reader :search_options, :client

    def initialize(client, options)
      @client = client
      @search_options = options
      @current_page = @search_options[:page] || 1
    end

    def each
      results = results_for @current_page

      loop do
        results.each do |resume|
          yield Resume.new(client, resume)
        end

        @current_page += 1

        results = results_for @current_page
        break if results.empty?
      end
    end

    private

    def results_for(page)
      attempts = 0
      search = client.advanced_resume_search(search_options.merge(:page_number => page, :rows_per_page => 500))
      search.results
    rescue Errno::ECONNRESET => e
      attempts += 1
      retry if attempts < 5
      raise e
    end

  end

end
