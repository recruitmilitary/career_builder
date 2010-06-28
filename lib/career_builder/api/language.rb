module CareerBuilder

  module API

    class Language

      include HappyMapper

      element :text, String, :tag => "string"

    end

  end

end
