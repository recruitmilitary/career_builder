class School

  include HappyMapper

  element :name, String, :tag => "SchoolName"
  element :major, String, :tag => "Major"
  element :degree, String, :tag => "Degree"
  element :graduation_date, String, :tag => "GraduationDate"

end
