class WordDocument

  include HappyMapper

  element :filename, String, :tag => "FileName"
  element :base64_date, String, :tag => "Base64Data"

end
