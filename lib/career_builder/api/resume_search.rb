module CareerBuilder

  module API

    class ResumeSearch

      include HappyMapper

      tag 'Packet'

      has_many :results, ResumeSearchResult

      element :page_number, Integer, :tag => "PageNumber"
      element :search_time, Time, :tag => "SearchTime"
      element :hits, Integer, :tag => "Hits"
      element :max_page, Integer, :tag => "MaxPage"

    end

  end

end
