module CareerBuilder

  module API

    class ShiftPreference

      include HappyMapper

      element :text, String, :tag => "string"

    end

  end

end
