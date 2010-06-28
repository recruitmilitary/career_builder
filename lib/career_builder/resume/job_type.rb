module CareerBuilder

  class JobType

    include HappyMapper

    element :text, String, :tag => "string"

  end

end
