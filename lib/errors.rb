class AuthorizationError < StandardError
  def message
    return 'We could not authenticate you. Please, re-enter your details and try again, or attempt another login option.'
  end
end

class UnavailableError < StandardError
  def message
    return "Zendesk services are unavailable at the moment. Please, try again later. If the error persists, please contact support."
  end
end

class GeneralError < StandardError
  def message
    return "Looks like something went wrong! Try again?"
  end
end