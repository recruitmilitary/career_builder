module CareerBuilder

  Error              = Class.new(StandardError)
  InvalidCredentials = Class.new(Error)
  OutOfCredits       = Class.new(Error)

end
