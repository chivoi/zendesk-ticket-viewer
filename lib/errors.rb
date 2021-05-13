class IDValidationError < StandardError
  def message
    return "Looks like this Ticket ID is not on this page! Try a differrent ID."
  end
end

class TypeError < StandardError
  def message
    return "Ticket ID must be a positive integer (ex. 1, 15, 24). Use the table above as a reference an try again."
  end
end

class GeneralError < StandardError
  def message
    return "Looks like something went wrong! Try again?"
  end
end