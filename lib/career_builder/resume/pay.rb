class Pay

  include HappyMapper

  element :amount, String, :tag => "Amount"
  element :per, String, :tag => "Per"

end
