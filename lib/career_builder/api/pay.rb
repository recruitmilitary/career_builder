module CareerBuilder
  
  module API

    class Pay

      include HappyMapper

      element :amount, Integer, :tag => "Amount"
      element :per, String, :tag => "Per"

    end

  end
  
end
