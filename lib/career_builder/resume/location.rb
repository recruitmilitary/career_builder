class Location

  include HappyMapper

  element :city, String, :tag => "City"
  element :state, String, :tag => "State"
  element :zip_code, String, :tag => "ZipCode"
  element :work_status, String, :tag => "WorkStatus"

end
