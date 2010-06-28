module CareerBuilder

  module API

    class JobType

      include HappyMapper

      element :text, String, :tag => "string"

    end

  end

end
